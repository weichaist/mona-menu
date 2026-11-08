import {algoliasearch} from "algoliasearch";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {getMessaging, MulticastMessage} from "firebase-admin/messaging";
import {logger} from "firebase-functions";
import {defineSecret, defineString} from "firebase-functions/params";
import {CallableRequest, onCall} from "firebase-functions/v2/https";
import {
  onDocumentCreated,
  onDocumentDeleted,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";
import Stripe from "stripe";

initializeApp();

// Configuration ------------------------------------------------------------
// Secrets: `firebase functions:secrets:set <NAME>` (see README.md).
const stripeSecretKeyTest = defineSecret("STRIPE_SECRET_KEY_TEST");
const stripeSecretKeyLive = defineSecret("STRIPE_SECRET_KEY_LIVE");
const stripePublishableKeyTest = defineSecret("STRIPE_PUBLISHABLE_KEY_TEST");
const stripePublishableKeyLive = defineSecret("STRIPE_PUBLISHABLE_KEY_LIVE");
const algoliaAppId = defineSecret("ALGOLIA_APP_ID");
const algoliaAdminKey = defineSecret("ALGOLIA_ADMIN_KEY");

// Firestore-triggered functions must run where the database lives.
const firestoreRegion = defineString("FIRESTORE_REGION", {
  default: "us-central1",
  description:
    "Location of the Cloud Firestore database (nam5 -> us-central1, " +
    "eur3 -> europe-west1, otherwise the database region).",
});

const RESTAURANT_INDEX = "restaurant_accounts";
const POST_INDEX = "posts";

// Stripe -------------------------------------------------------------------
// Every Stripe callable takes `mode`: "TEST" uses the test keys, anything
// else uses the live keys. The apps read the mode from Firestore
// `env/stripe_mode`.

const stripeSecrets = [stripeSecretKeyTest, stripeSecretKeyLive];

type StripeMode = "TEST" | "LIVE";

/** Callable data shared by the Stripe functions. */
interface ModeData {
  mode?: string;
}

function isTestMode(data: ModeData): boolean {
  return data.mode == "TEST";
}

const stripeClients: Partial<Record<StripeMode, Stripe>> = {};

function stripeFor(data: ModeData): Stripe {
  const mode: StripeMode = isTestMode(data) ? "TEST" : "LIVE";
  if (!stripeClients[mode]) {
    const key = mode === "TEST" ?
      stripeSecretKeyTest.value() :
      stripeSecretKeyLive.value();
    stripeClients[mode] = new Stripe(key);
  }
  return stripeClients[mode]!;
}

function isAuthenticated(request: CallableRequest): boolean {
  if (request.auth == null) {
    logger.warn("Unauthenticated request");
    return false;
  }
  return true;
}

export const fetchStripePubKey = onCall(
  {secrets: [stripePublishableKeyTest, stripePublishableKeyLive]},
  async (request: CallableRequest<ModeData>) => {
    logger.log("fetch stripe pub key");
    if (!isAuthenticated(request)) return null;
    return isTestMode(request.data) ?
      stripePublishableKeyTest.value() :
      stripePublishableKeyLive.value();
  },
);

interface CreateCustomerData extends ModeData {
  uid: string;
}

export const createStripeCustomer = onCall(
  {secrets: stripeSecrets},
  async (request: CallableRequest<CreateCustomerData>) => {
    logger.log("create stripe customer id for user");
    if (!isAuthenticated(request)) return null;
    return stripeFor(request.data).customers.create({
      description: request.data.uid,
    });
  },
);

interface PaymentMethodData extends ModeData {
  paymentMethodId: string;
}

export const retrieveStripePaymentMethodDetails = onCall(
  {secrets: stripeSecrets},
  async (request: CallableRequest<PaymentMethodData>) => {
    logger.log("looking for card details");
    if (!isAuthenticated(request)) return null;
    return stripeFor(request.data).paymentMethods.retrieve(
      request.data.paymentMethodId,
    );
  },
);

interface CreatePaymentIntentData extends ModeData {
  amount: number | string;
  currency: string;
  /** A Stripe customer id, or "ApplePay" for a one-off Apple Pay payment. */
  customerId: string;
  description: string;
  receipt_email?: string;
}

export const createStripePaymentIntent = onCall(
  {secrets: stripeSecrets},
  async (request: CallableRequest<CreatePaymentIntentData>) => {
    logger.log("creating payment intent");
    if (!isAuthenticated(request)) return null;
    const data = request.data;
    const stripe = stripeFor(data);
    const amount = Number(data.amount);
    if (data.customerId == "ApplePay") {
      return stripe.paymentIntents.create({
        amount,
        currency: data.currency,
        allowed_payment_method_types: ["card"],
        description: isTestMode(data) ?
          data.description + " by " + request.auth!.uid :
          data.description,
        receipt_email: data.receipt_email,
      });
    }
    return stripe.paymentIntents.create({
      amount,
      currency: data.currency,
      setup_future_usage: "on_session",
      customer: data.customerId,
      allowed_payment_method_types: ["card"],
      description: data.description,
      receipt_email: data.receipt_email,
    });
  },
);

interface ConfirmPaymentIntentData extends ModeData {
  paymentIntentId: string;
  paymentMethodId: string;
}

export const confirmPaymentIntent = onCall(
  {secrets: stripeSecrets},
  async (request: CallableRequest<ConfirmPaymentIntentData>) => {
    logger.log("confirm payment intent");
    if (!isAuthenticated(request)) return null;
    return stripeFor(request.data).paymentIntents.confirm(
      request.data.paymentIntentId,
      {payment_method: request.data.paymentMethodId},
    );
  },
);

interface PaymentIntentData extends ModeData {
  stripeIntent: string;
}

export const cancelStripePayment = onCall(
  {secrets: stripeSecrets},
  async (request: CallableRequest<PaymentIntentData>) => {
    logger.log("cancel stripe payment");
    if (!isAuthenticated(request)) return null;
    return stripeFor(request.data).paymentIntents.cancel(
      request.data.stripeIntent,
    );
  },
);

export const refundStripePayment = onCall(
  {secrets: stripeSecrets},
  async (request: CallableRequest<PaymentIntentData>) => {
    logger.log("refund payment");
    if (!isAuthenticated(request)) return null;
    return stripeFor(request.data).refunds.create({
      payment_intent: request.data.stripeIntent,
    });
  },
);

// Algolia ------------------------------------------------------------------
// Keeps the `restaurant_accounts` and `posts` indices in sync with the
// Firestore collections of the same name. Firestore Timestamps are stored as
// {_seconds, _nanoseconds}; the diner app reads them back in that shape.

const algoliaSecrets = [algoliaAppId, algoliaAdminKey];

function algolia() {
  return algoliasearch(algoliaAppId.value(), algoliaAdminKey.value());
}

async function saveToIndex(
  indexName: string,
  objectID: string,
  data: Record<string, unknown> | undefined,
): Promise<void> {
  if (!data) return;
  try {
    await algolia().addOrUpdateObject({
      indexName,
      objectID,
      body: {...data, objectID},
    });
  } catch (err) {
    logger.error(`Algolia save to ${indexName} failed`, err);
  }
}

async function deleteFromIndex(
  indexName: string,
  objectID: string,
): Promise<void> {
  try {
    await algolia().deleteObject({indexName, objectID});
  } catch (err) {
    logger.error(`Algolia delete from ${indexName} failed`, err);
  }
}

const triggerOptions = {region: firestoreRegion, secrets: algoliaSecrets};

export const restaurantAddToIndex = onDocumentCreated(
  {...triggerOptions, document: "restaurant_accounts/{restaurantId}"},
  async (event) => {
    if (!event.data) return;
    await saveToIndex(RESTAURANT_INDEX, event.data.id, event.data.data());
  },
);

export const restaurantUpdateIndex = onDocumentUpdated(
  {...triggerOptions, document: "restaurant_accounts/{restaurantId}"},
  async (event) => {
    if (!event.data) return;
    const after = event.data.after;
    await saveToIndex(RESTAURANT_INDEX, after.id, after.data());
  },
);

export const restaurantDeleteIndex = onDocumentDeleted(
  {...triggerOptions, document: "restaurant_accounts/{restaurantId}"},
  async (event) => {
    await deleteFromIndex(RESTAURANT_INDEX, event.params.restaurantId);
  },
);

export const postAddToIndex = onDocumentCreated(
  {...triggerOptions, document: "posts/{postId}"},
  async (event) => {
    if (!event.data) return;
    await saveToIndex(POST_INDEX, event.data.id, event.data.data());
  },
);

export const postUpdateIndex = onDocumentUpdated(
  {...triggerOptions, document: "posts/{postId}"},
  async (event) => {
    if (!event.data) return;
    const after = event.data.after;
    await saveToIndex(POST_INDEX, after.id, after.data());
  },
);

export const postDeleteIndex = onDocumentDeleted(
  {...triggerOptions, document: "posts/{postId}"},
  async (event) => {
    await deleteFromIndex(POST_INDEX, event.params.postId);
  },
);

// Notifications ------------------------------------------------------------
// Sends a push notification to the device tokens stored in
// restaurant_accounts/{uid}.tokens when a diner places an order.

export const sendOrderNotificationToRestaurant = onDocumentCreated(
  {
    region: firestoreRegion,
    document: "restaurant_accounts/{restaurantUid}/customer_orders/{orderId}",
  },
  async (event) => {
    const order = event.data?.data();
    if (!order) return;
    const restaurant = await getFirestore()
      .collection("restaurant_accounts")
      .doc(order["restaurantUid"])
      .get();
    const tokens: string[] = restaurant.data()?.["tokens"] ?? [];
    logger.log(`tokens: ${tokens}`);
    if (tokens.length == 0) {
      logger.warn("no device tokens");
      return;
    }
    const message: MulticastMessage = {
      notification: {
        title: "新しい注文",
        body: "ご確認お願いします!",
      },
      data: {
        userUid: order["orderedBy"],
      },
      apns: {
        payload: {
          aps: {
            badge: 0,
            sound: "default",
          },
        },
      },
      tokens,
    };
    logger.log("sending notification");
    await getMessaging().sendEachForMulticast(message);
  },
);

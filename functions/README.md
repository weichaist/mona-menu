# Mona Menu Cloud Functions

TypeScript Cloud Functions (2nd gen, Node.js 22) used by the two apps:

- Stripe callables: `fetchStripePubKey`, `createStripeCustomer`,
  `createStripePaymentIntent`, `refundStripePayment`,
  `retrieveStripePaymentMethodDetails`, `confirmPaymentIntent`,
  `cancelStripePayment`. Each takes `mode` (`"TEST"` or anything else for
  live) and picks the matching Stripe key.
- Algolia sync: Firestore triggers that mirror `restaurant_accounts` and
  `posts` into Algolia indices of the same name.
- `sendOrderNotificationToRestaurant`: push notification to a restaurant's
  `tokens` when an order is created.

Details: [../docs/architecture.md](../docs/architecture.md).

## Configuration

| Name | Kind | Purpose |
| --- | --- | --- |
| `STRIPE_SECRET_KEY_TEST`, `STRIPE_SECRET_KEY_LIVE` | secret | Stripe secret keys (`sk_test_…`, `sk_live_…`) |
| `STRIPE_PUBLISHABLE_KEY_TEST`, `STRIPE_PUBLISHABLE_KEY_LIVE` | secret | Returned by `fetchStripePubKey` |
| `ALGOLIA_APP_ID`, `ALGOLIA_ADMIN_KEY` | secret | Algolia application id and an API key that can add and delete records |
| `FIRESTORE_REGION` | param (`functions/.env`) | Location of the Firestore database; the triggers run there. Default `us-central1`. |

```bash
firebase functions:secrets:set STRIPE_SECRET_KEY_TEST   # repeat for each secret
cp .env.example .env                                     # then set FIRESTORE_REGION
```

Every secret must exist before deploying. If you only use test mode, give the
live secrets a placeholder value.

## Commands

```bash
npm ci
npm run lint
npm run build
firebase deploy --only functions   # from the repository root
```

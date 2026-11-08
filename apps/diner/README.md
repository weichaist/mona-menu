# Mona Menu diner app

The Flutter app diners use (Android and iOS, portrait). Dart package:
`mona_diner`. UI copy is in Japanese and English (`assets/translations`).

What it does:

- Phone-number sign-in (Firebase Auth) and a three-step profile setup.
- Home: the list of restaurants marked `public` in Firestore.
- Restaurant page: lunch/dinner menu by category, dish posts (latest, by the
  restaurant's regulars, by people you follow), a map, business hours, what
  was ordered today, and applying to become a regular ("repeater").
- Cart and checkout: pick a table, pay with a saved card or Apple Pay
  (Stripe), order history.
- Posting: write a post with photos about a dish you ordered, edit or delete
  it, share a link to it, report a post.
- Profile: follow lists, order/post/reward history, saved cards, bank account
  and private info.

See [../../docs/architecture.md](../../docs/architecture.md) for the data model
and the Cloud Functions it calls, and the [root README](../../README.md) for
setting up Firebase, Stripe and Algolia.

## Configure

1. **Build-time values.** Copy `config/example.json` to `config/dev.json`
   (gitignored) and fill it in:

   | Key | What it is | Where to get it |
   | --- | --- | --- |
   | `FIREBASE_PROJECT_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_STORAGE_BUCKET` | Firebase project settings | Firebase console > Project settings > General |
   | `FIREBASE_ANDROID_API_KEY`, `FIREBASE_ANDROID_APP_ID` | The Android app registered for `app.mona.mona_menu_r1` | Same page, Android app |
   | `FIREBASE_IOS_API_KEY`, `FIREBASE_IOS_APP_ID` | The iOS app registered for `app.mona.monaMenuR1` | Same page, iOS app |
   | `ALGOLIA_APP_ID`, `ALGOLIA_SEARCH_KEY` | Algolia application id and a **search-only** API key | Algolia dashboard > Settings > API keys |
   | `APPLE_MERCHANT_ID` | Apple Pay merchant id (default `merchant.app.mona`); must match `ios/Runner/Runner.entitlements` | Apple Developer > Identifiers > Merchant IDs |
   | `SHARE_BASE_URL` | Base of the link shared for a post (`<base>/post/<postId>`) | Your website |
   | `TERMS_URL` | Terms page linked from sign-in | Your website |

   Instead of the `FIREBASE_*` values you can run `flutterfire configure`,
   which overwrites `lib/firebase_options.dart` with your project's values.

2. **Google Maps keys** (the restaurant page shows a map):
   - Android: add `MAPS_API_KEY=...` to `android/local.properties`
     (gitignored), or export `MAPS_API_KEY` before building.
   - iOS: copy `ios/Flutter/Secrets.example.xcconfig` to
     `ios/Flutter/Secrets.xcconfig` (gitignored) and set `MAPS_API_KEY`.

3. **Phone sign-in.** Enable the Phone provider in Firebase Auth. On Android,
   add your signing key's SHA-1 and SHA-256 to the Firebase Android app. On
   iOS, set `FIREBASE_IOS_URL_SCHEME` in `ios/Flutter/Secrets.xcconfig` to the
   iOS app's Encoded App ID (used for the reCAPTCHA fallback).

4. **Apple Pay** needs a merchant id with a Stripe certificate and the
   in-app-payments capability on the bundle id. The Stripe publishable key is
   not part of the build: the app reads it from Firestore `env/stripe_keys`
   for the mode in `env/stripe_mode`.

5. **Release signing (Android).** Create `android/key.properties`
   (gitignored) with `storeFile`, `storePassword`, `keyAlias` and
   `keyPassword`. Without it, release builds use the debug key.

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=config/dev.json
```

```bash
flutter analyze
flutter test
```

Application ids: Android `app.mona.mona_menu_r1`, iOS `app.mona.monaMenuR1`.
Launcher icons and the splash screen are generated with
`dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`
(configured in `pubspec.yaml`).

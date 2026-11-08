# Mona Menu partner console

The Flutter app restaurant partners use, laid out for a landscape tablet
(iPad first; Android and iOS). Dart package: `mona_console`. UI copy is in
Japanese.

What it does:

- Email/password sign-in and password reset (accounts are created by you in
  Firebase Auth; the app has no sign-up).
- Onboarding: look up the restaurant with the Google Places API (New) to fill
  in name, address, phone and location, then upload a profile and background
  picture.
- Home: outstanding (`paid`) orders and today's confirmed orders, order
  details, confirm or refund (Stripe refund through a Cloud Function).
- Order history, customer management (approve regular-customer applications),
  the restaurant's dish posts and photo gallery.
- Settings: basic info, introduction, business hours, lunch and dinner menus
  (dishes, photos, categories, ordering), table numbers, and the "seats
  available now" toggle.

See [../../docs/architecture.md](../../docs/architecture.md) for the data model
and the [root README](../../README.md) for the Firebase setup, including how to
add a partner account.

## Configure

Copy `config/example.json` to `config/dev.json` (gitignored) and fill it in:

| Key | What it is | Where to get it |
| --- | --- | --- |
| `FIREBASE_PROJECT_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_STORAGE_BUCKET` | Firebase project settings | Firebase console > Project settings > General |
| `FIREBASE_ANDROID_API_KEY`, `FIREBASE_ANDROID_APP_ID` | The Android app registered for `app.mona.mona_restaurant_console` | Same page, Android app |
| `FIREBASE_IOS_API_KEY`, `FIREBASE_IOS_APP_ID` | The iOS app registered for `app.mona.monaRestaurantConsole` | Same page, iOS app |
| `GOOGLE_PLACES_API_KEY` | Key with **Places API (New)** enabled, used by onboarding | Google Cloud console > APIs & Services > Credentials |
| `SUPPORT_EMAIL` | Contact address shown under Settings > 問い合わせ | You |
| `TERMS_URL` | Terms page linked from sign-in | Your website |

Instead of the `FIREBASE_*` values you can run `flutterfire configure`, which
overwrites `lib/firebase_options.dart` with your project's values.

The Places key ships inside the app, so restrict it to the Places API and to
your app's bundle id / package name.

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=config/dev.json
```

```bash
flutter analyze
flutter test
```

Application ids: Android `app.mona.mona_restaurant_console`, iOS
`app.mona.monaRestaurantConsole`. The iOS launcher icon and the splash screen
are generated with `dart run flutter_launcher_icons` and
`dart run flutter_native_splash:create` (configured in `pubspec.yaml`); the
Android launcher icon is still Flutter's default.

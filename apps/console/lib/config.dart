/// Build-time configuration.
///
/// Values come from `--dart-define-from-file=config/<name>.json`
/// (see `config/example.json`).
class AppConfig {
  const AppConfig._();

  /// Google Maps Platform key with the Places API (New) enabled. Used by the
  /// onboarding screen to look up the restaurant's address and phone number.
  static const googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
  );

  /// Contact address shown under Settings > 問い合わせ.
  static const supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@example.com',
  );

  /// Terms and conditions page linked from the sign-in screen.
  static const termsUrl = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://example.com/terms',
  );
}

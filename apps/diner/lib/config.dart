/// Build-time configuration.
///
/// Values come from `--dart-define-from-file=config/<name>.json`
/// (see `config/example.json`). Nothing here is a server secret: the Algolia
/// key must be a search-only key.
class AppConfig {
  const AppConfig._();

  static const algoliaAppId = String.fromEnvironment('ALGOLIA_APP_ID');
  static const algoliaSearchKey = String.fromEnvironment('ALGOLIA_SEARCH_KEY');

  /// Apple Pay merchant id; must match `ios/Runner/Runner.entitlements`.
  static const appleMerchantId = String.fromEnvironment(
    'APPLE_MERCHANT_ID',
    defaultValue: 'merchant.app.mona',
  );

  /// Base URL used when sharing a post (`<base>/post/<postId>`).
  static const shareBaseUrl = String.fromEnvironment(
    'SHARE_BASE_URL',
    defaultValue: 'https://example.com',
  );

  /// Terms and conditions page shown from the sign-in screen.
  static const termsUrl = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://example.com/terms',
  );
}

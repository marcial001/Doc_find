abstract final class AppConstants {
  // Mock login credentials (mock data source only, removed when real API lands)
  static const String mockDemoEmail = 'demo@docfind.cm';
  static const String mockDemoPassword = 'demo1234';
  static const String mockDemoName = 'K. N.';
  static const String mockDemoPhone = '670000000';

  // Storage keys
  static const String keyIntroSeen = 'docfind_intro_seen';
  static const String keyAuthToken = 'docfind_auth_token';
  static const String keyThemeMode = 'docfind_theme_mode';
  static const String keyLocale = 'docfind_locale';
  static const String keyDefaultTown = 'docfind_default_town';

  // Timings
  static const Duration splashDuration = Duration(milliseconds: 3300);
  static const Duration mockReplyDuration = Duration(milliseconds: 1400);
}

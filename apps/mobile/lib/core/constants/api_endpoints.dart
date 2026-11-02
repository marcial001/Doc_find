import 'dart:io';

abstract final class ApiEndpoints {
  /// Base API URL with platform-aware localhost resolution:
  /// - Android emulator maps host machine localhost to 10.0.2.2
  /// - iOS simulator / macOS / desktop maps directly to localhost
  static String get baseUrl {
    const String defaultHost = '127.0.0.1';
    final String host = Platform.isAndroid ? '10.0.2.2' : defaultHost;
    return 'http://$host:8000/api/v1';
  }

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';

  // Submissions (Finder flow)
  static const String submissions = '/submissions';

  // Listings (Public feed & search)
  static const String listings = '/listings';

  // Claims
  static const String claims = '/claims';

  // Alerts
  static const String alerts = '/alerts';
}

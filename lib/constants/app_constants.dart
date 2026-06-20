class AppConstants {
  AppConstants._();

  static const String appName = 'Huỳnh Gia';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String cachedMembers = 'CACHED_MEMBERS';
  static const String cachedBranches = 'CACHED_BRANCHES';

  // API
  static const String serverUrl = 'http://172.16.0.148:3000';

  static String get baseUrl => '$serverUrl/api';

  // Pagination
  static const int defaultPageSize = 50;
}

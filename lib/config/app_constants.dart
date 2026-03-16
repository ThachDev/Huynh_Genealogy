import 'dart:io';

class AppConstants {
  AppConstants._();

  // Storage keys
  static const String cachedMembers = 'CACHED_MEMBERS';
  static const String cachedBranches = 'CACHED_BRANCHES';

  // API
  static String get serverUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static String get baseUrl => '$serverUrl/api';

  // Pagination
  static const int defaultPageSize = 50;
}

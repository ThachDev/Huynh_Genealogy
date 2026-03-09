class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'http://localhost:3000/api';

  // Endpoints
  static const String membersEndpoint = '/members';
  static const String branchesEndpoint = '/branches';

  // Storage keys
  static const String cachedMembers = 'CACHED_MEMBERS';
  static const String cachedBranches = 'CACHED_BRANCHES';

  // Pagination
  static const int defaultPageSize = 50;
}

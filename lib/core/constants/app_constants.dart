class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'http://localhost:3000/api';

  // Endpoints
  static const String membersEndpoint = '/members';
  static const String branchesEndpoint = '/branches';
  static const String loginEndpoint = '/auth/login';
  static const String familiesEndpoint = '/families';
  static const String verifyCodeEndpoint = '/families/verify-code';
  static const String joinFamilyEndpoint = '/families/join';
  static const String approveRequestEndpoint = '/families/requests';

  // Storage keys
  static const String cachedMembers = 'CACHED_MEMBERS';
  static const String cachedBranches = 'CACHED_BRANCHES';
  static const String cachedUser = 'CACHED_USER';
  static const String cachedToken = 'CACHED_TOKEN';

  // Pagination
  static const int defaultPageSize = 50;
}

class AppConstants {
  AppConstants._();

  // API
  // static const String baseUrl = 'https://be-family-tree.thachhuynh-dev.workers.dev/api';
  static const String baseUrl = 'http://10.0.2.2:8787/api';

  // Endpoints
  static const String membersEndpoint = '/members';
  static const String branchesEndpoint = '/branches';
  static const String loginEndpoint = '/auth/login';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String familiesEndpoint = '/families';
  static const String verifyCodeEndpoint = '/families/verify-code';
  static const String joinFamilyEndpoint = '/families/join';
  static const String approveRequestEndpoint = '/families/requests';
  static const String transferOwnershipEndpoint = '/families/transfer-ownership';

  // Storage keys
  static const String cachedMembers = 'CACHED_MEMBERS';
  static const String cachedBranches = 'CACHED_BRANCHES';
  static const String cachedUser = 'CACHED_USER';
  static const String cachedToken = 'CACHED_TOKEN';
  static const String cachedCredentials = 'CACHED_CREDENTIALS';

  // Pagination
  static const int defaultPageSize = 50;
}

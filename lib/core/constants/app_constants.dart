import '../config/app_config.dart';

class AppConstants {
  AppConstants._();

  // API
  static String get baseUrl => AppConfig.baseUrl;

  // Endpoints
  static const String membersEndpoint = '/members';
  static const String branchesEndpoint = '/branches';
  static const String loginEndpoint = '/auth/login';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String deleteAccountEndpoint = '/auth/account';
  static const String familiesEndpoint = '/families';
  static const String verifyCodeEndpoint = '/families/verify-code';
  static const String joinFamilyEndpoint = '/families/join';
  static const String approveRequestEndpoint = '/families/requests';
  static const String transferOwnershipEndpoint =
      '/families/transfer-ownership';
  static const String eventsEndpoint = '/events';
  static const String authEndpoint = '/auth';
  static const String auditLogsEndpoint = '/families/audit-logs';
  static const String reportsEndpoint = '/reports';
  static const String wishReactEndpoint = '/wishes';

  // Storage keys
  static const String cachedMembers = 'CACHED_MEMBERS';
  static const String cachedBranches = 'CACHED_BRANCHES';
  static const String cachedUser = 'CACHED_USER';
  static const String cachedToken = 'CACHED_TOKEN';
  static const String cachedCredentials = 'CACHED_CREDENTIALS';

  // Local preferences keys
  static const String themeModeKey = 'THEME_MODE';
  static const String languageCodeKey = 'LANGUAGE_CODE';

  // Pagination
  static const int defaultPageSize = 50;
}

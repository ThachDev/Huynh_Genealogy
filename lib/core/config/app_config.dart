/// App Environment Enum
enum Environment {
  dev,
  staging,
  prod,
}

/// Centralized Application Configuration
///
/// Supports injection via `--dart-define` or `--dart-define-from-file`.
/// Example:
/// `flutter run --dart-define-from-file=config/env.dev.json`
class AppConfig {
  AppConfig._();

  static const String _defaultBaseUrl =
      'https://be-family-tree.thachhuynh-dev.workers.dev/api';

  /// Current environment name (e.g. dev, staging, prod)
  static const String environmentName = String.fromEnvironment(
    'ENV',
    defaultValue: 'prod',
  );

  /// Current API base URL
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  /// App Name displayed in UI or debug info
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Gia Tộc Việt',
  );

  /// Whether to enable verbose debug logging
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  /// Current active environment enum
  static Environment get currentEnvironment {
    switch (environmentName.toLowerCase()) {
      case 'dev':
      case 'development':
        return Environment.dev;
      case 'staging':
      case 'stage':
        return Environment.staging;
      case 'prod':
      case 'production':
      default:
        return Environment.prod;
    }
  }

  /// Helper checks
  static bool get isDev => currentEnvironment == Environment.dev;
  static bool get isStaging => currentEnvironment == Environment.staging;
  static bool get isProd => currentEnvironment == Environment.prod;
}

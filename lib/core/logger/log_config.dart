import 'package:flutter/foundation.dart';

/// Cấu hình bật/tắt các loại log.
/// Tất cả tự động tắt hoàn toàn trên Production (kReleaseMode).
class LogConfig {
  // ─── General ──────────────────────────────────────────────────────────────
  static const enableGeneralLog = kDebugMode;
  static const isPrettyJson = kDebugMode;

  // ─── Bloc ─────────────────────────────────────────────────────────────────
  static const logOnBlocEvent = kDebugMode;
  static const logOnBlocTransition = false;
  static const logOnBlocChange = false;

  // ─── API Interceptor ──────────────────────────────────────────────────────
  static const enableLogInterceptor = kDebugMode;
  static const enableLogSuccessResponse = kDebugMode;
  static const enableLogErrorResponse = kDebugMode;

  // ─── UseCase ──────────────────────────────────────────────────────────────
  static const enableLogUseCaseInput = kDebugMode;
  static const enableLogUseCaseOutput = false;
  static const enableLogUseCaseError = kDebugMode;
}

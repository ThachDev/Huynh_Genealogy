import 'exceptions.dart';
import 'failures.dart';

/// Tập trung việc chuyển đổi (mapping) `Exception` sang `Failure`.
///
/// Repository layer không cần tự viết lại chuỗi `on XException catch (e)` cho
/// từng loại lỗi nữa mà chỉ cần gọi [ErrorHandler.map].
///
/// Tuân theo convention của `error-handling.md`:
///   - Mọi exception đều được map về một `Failure` tương ứng.
///   - Exception không xác định sẽ về [ServerFailure] với message gốc.
class ErrorHandler {
  ErrorHandler._();

  /// Chuyển một [error] bất kỳ thành [Failure].
  ///
  /// Bảo toàn `message` và `statusCode` (nếu có) để [Failure.message] /
  /// [Failure.getMessage] tiếp tục làm sạch thành thông điệp thân thiện.
  static Failure map(Object error) {
    if (error is ServerException) {
      return ServerFailure(message: error.message, statusCode: error.statusCode);
    }
    if (error is NetworkException) {
      return NetworkFailure(message: error.message);
    }
    if (error is CacheException) {
      return CacheFailure(message: error.message);
    }
    if (error is NotFoundException) {
      return NotFoundFailure(message: error.message);
    }
    if (error is AuthException) {
      return AuthFailure(message: error.message);
    }
    if (error is PermissionException) {
      return PermissionFailure(message: error.message);
    }
    if (error is AppTimeoutException) {
      return TimeoutFailure(message: error.message);
    }
    return ServerFailure(message: error.toString());
  }
}

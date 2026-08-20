/// Base class dùng chung cho mọi exception của ứng dụng.
///
/// Tuân theo convention trong `error-handling.md`:
///   - [message]: thông điệp lỗi (có thể null, sẽ được làm sạch ở Failure layer).
///   - [code]: mã lỗi nghiệp vụ (VD: `INVALID_EMAIL`, `NOT_FOUND`, ...).
///   - [details]: dữ liệu bổ sung để debug (response body, stack, ...).
abstract class AppException implements Exception {
  const AppException({this.message, this.code, this.details});

  final String? message;
  final String? code;
  final dynamic details;

  @override
  String toString() => 'AppException: ${message ?? 'Error'}';
}

class ServerException extends AppException {
  const ServerException({
    super.message,
    super.code,
    super.details,
    this.statusCode,
  });
  final int? statusCode;

  @override
  String toString() =>
      'ServerException: ${message ?? 'Server error'} (status: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({super.message, super.code, super.details});

  @override
  String toString() =>
      'NetworkException: ${message ?? 'No network connection'}';
}

class CacheException extends AppException {
  const CacheException({super.message, super.code, super.details});

  @override
  String toString() => 'CacheException: ${message ?? 'Cache error'}';
}

class NotFoundException extends AppException {
  const NotFoundException({super.message, super.code, super.details});

  @override
  String toString() => 'NotFoundException: ${message ?? 'Data not found'}';
}

class AuthException extends AppException {
  const AuthException({super.message, super.code, super.details});

  @override
  String toString() =>
      'AuthException: ${message ?? 'Authentication failed'}';
}

class PermissionException extends AppException {
  const PermissionException({super.message, super.code, super.details});

  @override
  String toString() => 'PermissionException: ${message ?? 'Access denied'}';
}

class AppTimeoutException extends AppException {
  const AppTimeoutException({super.message, super.code, super.details});

  @override
  String toString() =>
      'AppTimeoutException: ${message ?? 'Connection timed out'}';
}
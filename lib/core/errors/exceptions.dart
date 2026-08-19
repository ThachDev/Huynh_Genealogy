class ServerException implements Exception {

  const ServerException({
    this.message,
    this.statusCode,
  });
  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: ${message ?? 'Server error'} (status: $statusCode)';
}

class NetworkException implements Exception {
  const NetworkException({this.message});
  final String? message;

  @override
  String toString() => 'NetworkException: ${message ?? 'No network connection'}';
}

class CacheException implements Exception {
  const CacheException({this.message});
  final String? message;

  @override
  String toString() => 'CacheException: ${message ?? 'Cache error'}';
}

class NotFoundException implements Exception {
  const NotFoundException({this.message});
  final String? message;

  @override
  String toString() => 'NotFoundException: ${message ?? 'Data not found'}';
}

class AuthException implements Exception {
  const AuthException({this.message});
  final String? message;

  @override
  String toString() => 'AuthException: ${message ?? 'Authentication failed'}';
}

class PermissionException implements Exception {
  const PermissionException({this.message});
  final String? message;

  @override
  String toString() => 'PermissionException: ${message ?? 'Access denied'}';
}

class TimeoutException implements Exception {
  const TimeoutException({this.message});
  final String? message;

  @override
  String toString() => 'TimeoutException: ${message ?? 'Connection timed out'}';
}



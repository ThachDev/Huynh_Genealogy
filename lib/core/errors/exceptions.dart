class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  const ServerException({
    this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: ${message ?? 'Server error'} (status: $statusCode)';
}

class NetworkException implements Exception {
  final String? message;
  const NetworkException({this.message});

  @override
  String toString() => 'NetworkException: ${message ?? 'No network connection'}';
}

class CacheException implements Exception {
  final String? message;
  const CacheException({this.message});

  @override
  String toString() => 'CacheException: ${message ?? 'Cache error'}';
}

class NotFoundException implements Exception {
  final String? message;
  const NotFoundException({this.message});

  @override
  String toString() => 'NotFoundException: ${message ?? 'Data not found'}';
}

class AuthException implements Exception {
  final String? message;
  const AuthException({this.message});

  @override
  String toString() => 'AuthException: ${message ?? 'Authentication failed'}';
}

class PermissionException implements Exception {
  final String? message;
  const PermissionException({this.message});

  @override
  String toString() => 'PermissionException: ${message ?? 'Access denied'}';
}

class TimeoutException implements Exception {
  final String? message;
  const TimeoutException({this.message});

  @override
  String toString() => 'TimeoutException: ${message ?? 'Connection timed out'}';
}



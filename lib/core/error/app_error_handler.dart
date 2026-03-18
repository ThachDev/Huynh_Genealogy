import 'package:dio/dio.dart';
import 'failures.dart';
import 'exceptions.dart';

class AppErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        statusCode: error.statusCode,
      );
    } else if (error is NetworkException) {
      return const NetworkFailure();
    } else if (error is CacheException) {
      return const CacheFailure();
    } else if (error is NotFoundException) {
      return const NotFoundFailure();
    } else if (error is Exception) {
      final message = error.toString().replaceFirst('Exception: ', '');
      return ServerFailure(message: message);
    } else {
      return const ServerFailure(message: 'Đã có lỗi không xác định xảy ra');
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Kết nối máy chủ quá hạn. Vui lòng thử lại.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data is Map
            ? error.response?.data['message'] ?? 'Lỗi từ máy chủ ($statusCode)'
            : 'Lỗi từ máy chủ ($statusCode)';

        if (statusCode == 404) {
          return const NotFoundFailure();
        }
        return ServerFailure(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Yêu cầu đã bị hủy');
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          message: 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra internet.',
        );
      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkFailure();
        }
        return ServerFailure(
          message: error.message ?? 'Đã có lỗi xảy ra trong quá trình xử lý',
        );
    }
  }
}

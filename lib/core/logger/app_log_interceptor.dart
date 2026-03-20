import 'package:dio/dio.dart';
import 'package:app_family_tree/core/logger/log.dart';
import 'package:app_family_tree/core/logger/log_config.dart';

/// Interceptor tự động log mọi API request/response/error.
/// Thay thế LogInterceptor mặc định của Dio với format đẹp hơn.
class AppLogInterceptor extends Interceptor {
  static const _name = 'API';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (LogConfig.enableLogInterceptor) {
      Log.d('🌐 *** Request ***', name: _name);
      Log.d('🌐 ${options.method} ${options.uri}', name: _name);
      if (options.headers.isNotEmpty) {
        Log.d('🌐 Headers: ${options.headers}', name: _name);
      }
      if (options.data != null) {
        Log.d('🌐 Body: ${options.data}', name: _name);
      }
      if (options.queryParameters.isNotEmpty) {
        Log.d('🌐 Query: ${options.queryParameters}', name: _name);
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (LogConfig.enableLogSuccessResponse) {
      Log.d('🎉 *** Request Response ***', name: _name);
      Log.d(
        '🎉 ${response.requestOptions.method} ${response.requestOptions.uri}',
        name: _name,
      );
      Log.d('🎉 Success Code: ${response.statusCode}', name: _name);
      if (response.data is Map<String, dynamic>) {
        Log.d(
          '🎉 ${Log.prettyJson(response.data as Map<String, dynamic>)}',
          name: _name,
        );
      } else {
        Log.d('🎉 ${response.data}', name: _name);
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (LogConfig.enableLogErrorResponse) {
      Log.e('⛔️ *** Request Error ***', name: _name);
      Log.e(
        '⛔️ ${err.requestOptions.method} ${err.requestOptions.uri}',
        name: _name,
      );
      Log.e('⛔️ Error Code: ${err.response?.statusCode}', name: _name);
      if (err.response?.data is Map<String, dynamic>) {
        Log.e(
          '⛔️ ${Log.prettyJson(err.response?.data as Map<String, dynamic>)}',
          name: _name,
          errorObject: err,
        );
      } else {
        Log.e(
          '⛔️ ${err.response?.data ?? err.message}',
          name: _name,
          errorObject: err,
          stackTrace: err.stackTrace,
        );
      }
    }
    super.onError(err, handler);
  }
}

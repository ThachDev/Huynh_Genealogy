import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _YellowLogInterceptor(),
      _RetryInterceptor(),
      _ErrorInterceptor(),
    ]);

    return dio;
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Có thể thêm logic refresh token hoặc log lỗi tại đây
    handler.next(err);
  }
}

class _RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
  ];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    // Retry conditions: network errors, timeouts, 5xx errors
    bool shouldRetry = false;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      shouldRetry = true;
    } else if (err.response?.statusCode != null &&
        err.response!.statusCode! >= 500) {
      shouldRetry = true;
    }

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    final delay = retryDelays[retryCount];
    await Future.delayed(delay);

    // Increment retry count and retry
    requestOptions.extra['retry_count'] = retryCount + 1;
    try {
      final response = await DioClient.instance.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
          responseType: requestOptions.responseType,
          contentType: requestOptions.contentType,
          extra: requestOptions.extra,
        ),
      );
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}

class _YellowLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final uri = options.uri.toString();
    final data = options.data;

    // \x1B[33m is ANSI Yellow
    String logMsg =
        '\n\x1B[33m┌─── POSTMAN REQUEST ───────────────────────────────────────\n'
        '│ Method: $method\n'
        '│ URL: $uri\n';
    if (data != null) {
      logMsg += '│ Data: ${_prettyPrintJson(data)}\n';
    }
    logMsg +=
        '└──────────────────────────────────────────────────────────┘\x1B[0m';

    debugPrint(logMsg);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final method = response.requestOptions.method;
    final uri = response.requestOptions.uri.toString();
    final statusCode = response.statusCode;
    final data = response.data;

    String logMsg =
        '\n\x1B[33m┌─── POSTMAN RESPONSE ──────────────────────────────────────\n'
        '│ Method: $method\n'
        '│ URL: $uri\n'
        '│ Status: $statusCode\n';
    if (data != null) {
      logMsg += '│ Body: ${_prettyPrintJson(data)}\n';
    }
    logMsg +=
        '└──────────────────────────────────────────────────────────┘\x1B[0m';

    debugPrint(logMsg);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final method = err.requestOptions.method;
    final uri = err.requestOptions.uri.toString();
    final statusCode = err.response?.statusCode;
    final message = err.message;
    final data = err.response?.data;

    String logMsg =
        '\n\x1B[31m┌─── POSTMAN ERROR ─────────────────────────────────────────\n'
        '│ Method: $method\n'
        '│ URL: $uri\n'
        '│ Status: $statusCode\n'
        '│ Message: $message\n';
    if (data != null) {
      logMsg += '│ Data: ${_prettyPrintJson(data)}\n';
    }
    logMsg +=
        '└──────────────────────────────────────────────────────────┘\x1B[0m';

    debugPrint(logMsg);
    handler.next(err);
  }

  String _prettyPrintJson(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is String) {
        final decoded = json.decode(data);
        return const JsonEncoder.withIndent('  ')
            .convert(decoded)
            .replaceAll('\n', '\n│ ');
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ')
            .convert(data)
            .replaceAll('\n', '\n│ ');
      }
    } catch (_) {}
    return data.toString();
  }
}

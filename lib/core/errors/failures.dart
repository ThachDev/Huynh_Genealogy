import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../../resources/app_localizations.dart';

// ─── Base failures ────────────────────────────────────────────────────────────
abstract class Failure extends Equatable {
  final String? customMessage;
  const Failure({this.customMessage});

  String get message => customMessage ?? 'Có lỗi xảy ra';

  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errUnknown;
  }

  @override
  List<Object?> get props => [customMessage];
}

// ─── Concrete failures ────────────────────────────────────────────────────────

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({String? message, this.statusCode}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Lỗi máy chủ';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errServer;
  }

  @override
  List<Object?> get props => [customMessage, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Không có kết nối mạng';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errNetwork;
  }
}

class CacheFailure extends Failure {
  const CacheFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Lỗi bộ nhớ đệm';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errCache;
  }
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Không tìm thấy dữ liệu';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errNotFound;
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Dữ liệu không hợp lệ';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errValidation;
  }
}

class AuthFailure extends Failure {
  const AuthFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Lỗi xác thực';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errAuth;
  }
}

class PermissionFailure extends Failure {
  const PermissionFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Không có quyền truy cập';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errPermission;
  }
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({String? message}) : super(customMessage: message);

  @override
  String get message => customMessage ?? 'Kết nối quá hạn';

  @override
  String getMessage(BuildContext context) {
    return customMessage ?? AppLocalizations.of(context)!.errTimeout;
  }
}



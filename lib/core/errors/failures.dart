import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import '../../resources/app_localizations.dart';

// ─── Global Language Helper ──────────────────────────────────────────────────
/// Helper truy cập [AppLocalizations] ngoài widget tree (data source, service,
/// bloc). Instance được quản lý bởi GetIt (xem `injection_container.dart`) để
/// dễ thay thế trong test thay vì static singleton ẩn.
class AppLanguage {
  AppLocalizations? _current;

  void init(BuildContext context) {
    _current = AppLocalizations.of(context);
  }

  AppLocalizations? get l10n => _current;

  /// Truy cập nhanh không cần inject: lấy instance từ GetIt.
  static AppLocalizations? get current {
    final sl = GetIt.instance;
    if (sl.isRegistered<AppLanguage>()) return sl<AppLanguage>()._current;
    return null;
  }
}

// ─── Base failures ────────────────────────────────────────────────────────────
abstract class Failure extends Equatable {
  const Failure({
    this.customMessage,
    this.code,
    this.details,
    this.timestamp,
  });

  final String? customMessage;

  /// Mã lỗi nghiệp vụ (VD: `INVALID_EMAIL`, `NOT_FOUND`, `UNAUTHORIZED`, ...).
  final String? code;

  /// Dữ liệu bổ sung phục vụ debug/error reporting.
  final dynamic details;

  /// Thời điểm lỗi xảy ra.
  final DateTime? timestamp;

  String get message =>
      _sanitizeRawMessage(customMessage, 'Có lỗi xảy ra. Vui lòng thử lại.');

  String getMessage(BuildContext context) {
    return _sanitizeMessage(context, AppLocalizations.of(context).errUnknown);
  }

  /// Làm sạch các thông điệp lỗi kỹ thuật không cần BuildContext (sử dụng AppLanguage.current)
  String _sanitizeRawMessage(String? customMessage, String fallback) {
    if (customMessage == null || customMessage.trim().isEmpty) {
      return fallback;
    }

    final msg = customMessage.toLowerCase();

    // Phát hiện các lỗi kỹ thuật thô
    if (msg.contains('exception:') ||
        msg.contains('error:') ||
        msg.contains('socketexception') ||
        msg.contains('http status') ||
        msg.contains('null pointer') ||
        msg.contains('failed host lookup') ||
        msg.contains('connection refused') ||
        msg.contains('firebase') ||
        msg.contains('api_error') ||
        msg.contains('invalid-credential') ||
        msg.contains('invalid-email') ||
        msg.contains('wrong-password') ||
        msg.contains('user-not-found') ||
        msg.contains('email-already-in-use') ||
        msg.contains('network_error') ||
        msg.contains('deadline exceeded') ||
        msg.contains('permission_denied') ||
        msg.contains('permission-denied') ||
        msg.contains('unauthorized') ||
        msg.contains('forbidden')) {
      final l10n = AppLanguage.current;
      if (l10n != null) {
        if (msg.contains('invalid-email') || msg.contains('invalid email')) {
          return l10n.errEmailInvalid;
        }
        if (msg.contains('wrong-password') ||
            msg.contains('invalid-credential') ||
            msg.contains('user-not-found')) {
          return l10n.errAuth;
        }
        if (msg.contains('email-already-in-use')) {
          return l10n.errValidation;
        }
        if (msg.contains('socketexception') ||
            msg.contains('failed host lookup') ||
            msg.contains('network_error') ||
            msg.contains('connection refused')) {
          return l10n.errNetwork;
        }
        if (msg.contains('timeout') || msg.contains('deadline exceeded')) {
          return l10n.errTimeout;
        }
        if (msg.contains('permission') ||
            msg.contains('access denied') ||
            msg.contains('forbidden') ||
            msg.contains('unauthorized')) {
          return l10n.errPermission;
        }
      } else {
        // Fallback dự phòng nếu chưa khởi tạo AppLanguage (ví dụ trong môi trường Test đơn giản)
        if (msg.contains('invalid-email') || msg.contains('invalid email')) {
          return 'Email không đúng định dạng (Ví dụ: ten@gmail.com)';
        }
        if (msg.contains('wrong-password') ||
            msg.contains('invalid-credential') ||
            msg.contains('user-not-found')) {
          return 'Mật khẩu hoặc tài khoản không chính xác. Vui lòng thử lại.';
        }
        if (msg.contains('email-already-in-use')) {
          return 'Địa chỉ email này đã được đăng ký sử dụng.';
        }
        if (msg.contains('socketexception') ||
            msg.contains('failed host lookup') ||
            msg.contains('network_error') ||
            msg.contains('connection refused')) {
          return 'Không có kết nối mạng. Vui lòng kiểm tra lại Wi-Fi hoặc dữ liệu di động.';
        }
        if (msg.contains('timeout') || msg.contains('deadline exceeded')) {
          return 'Kết nối mạng quá chậm hoặc bị gián đoạn. Vui lòng thử lại.';
        }
        if (msg.contains('permission') ||
            msg.contains('access denied') ||
            msg.contains('forbidden') ||
            msg.contains('unauthorized')) {
          return 'Tài khoản của bạn không có quyền thực hiện chức năng này.';
        }
      }

      return fallback;
    }

    return customMessage;
  }

  /// Làm sạch các thông điệp lỗi kỹ thuật, thô từ backend/mạng/Firebase
  /// và chuyển thành thông điệp thân thiện với người dùng (hỗ trợ đa ngôn ngữ).
  String _sanitizeMessage(BuildContext context, String fallback) {
    if (customMessage == null || customMessage!.trim().isEmpty) {
      return fallback;
    }

    final msg = customMessage!.toLowerCase();

    // Phát hiện các lỗi kỹ thuật thô
    if (msg.contains('exception:') ||
        msg.contains('error:') ||
        msg.contains('socketexception') ||
        msg.contains('http status') ||
        msg.contains('null pointer') ||
        msg.contains('failed host lookup') ||
        msg.contains('connection refused') ||
        msg.contains('firebase') ||
        msg.contains('api_error') ||
        msg.contains('invalid-credential') ||
        msg.contains('invalid-email') ||
        msg.contains('wrong-password') ||
        msg.contains('user-not-found') ||
        msg.contains('email-already-in-use') ||
        msg.contains('network_error') ||
        msg.contains('deadline exceeded') ||
        msg.contains('permission_denied') ||
        msg.contains('permission-denied') ||
        msg.contains('unauthorized') ||
        msg.contains('forbidden')) {
      // Ánh xạ các trường hợp đặc biệt sang chuỗi dịch thân thiện tương ứng
      if (msg.contains('invalid-email') || msg.contains('invalid email')) {
        return AppLocalizations.of(context).errEmailInvalid;
      }
      if (msg.contains('wrong-password') ||
          msg.contains('invalid-credential') ||
          msg.contains('user-not-found')) {
        return AppLocalizations.of(context).errAuth;
      }
      if (msg.contains('email-already-in-use')) {
        return AppLocalizations.of(context).errValidation;
      }
      if (msg.contains('socketexception') ||
          msg.contains('failed host lookup') ||
          msg.contains('network_error') ||
          msg.contains('connection refused')) {
        return AppLocalizations.of(context).errNetwork;
      }
      if (msg.contains('timeout') || msg.contains('deadline exceeded')) {
        return AppLocalizations.of(context).errTimeout;
      }
      if (msg.contains('permission') ||
          msg.contains('access denied') ||
          msg.contains('forbidden') ||
          msg.contains('unauthorized')) {
        return AppLocalizations.of(context).errPermission;
      }

      return fallback;
    }

    return customMessage!;
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

// ─── Concrete failures ────────────────────────────────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({
    String? message,
    this.statusCode,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);
  final int? statusCode;

  @override
  String get message {
    if (statusCode == 429) {
      return 'Quá nhiều lần thử. Vui lòng đợi một lúc rồi thử lại.';
    }
    if (statusCode == 401) {
      return 'Phiên đăng nhập đã hết hạn hoặc thông tin tài khoản không chính xác. Vui lòng đăng nhập lại.';
    }
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errServer
        : 'Hệ thống đang gặp sự cố tạm thời. Vui lòng thử lại sau ít phút.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    if (statusCode == 429) {
      return 'Quá nhiều lần thử. Vui lòng đợi một lúc rồi thử lại.';
    }
    if (statusCode == 401) {
      return AppLocalizations.of(context).errAuth;
    }
    return _sanitizeMessage(context, AppLocalizations.of(context).errServer);
  }

  @override
  List<Object?> get props => [customMessage, statusCode, code, details, timestamp];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errNetwork
        : 'Không có kết nối mạng. Vui lòng kiểm tra lại Wi-Fi hoặc dữ liệu di động.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(context, AppLocalizations.of(context).errNetwork);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

class CacheFailure extends Failure {
  const CacheFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errCache
        : 'Không thể truy xuất dữ liệu lưu tạm trên thiết bị. Vui lòng tải lại trang.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(context, AppLocalizations.of(context).errCache);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errNotFound
        : 'Không tìm thấy thông tin yêu cầu hoặc dữ liệu đã bị xóa.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(context, AppLocalizations.of(context).errNotFound);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errValidation
        : 'Thông tin nhập vào chưa chính xác. Vui lòng kiểm tra lại.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(
        context, AppLocalizations.of(context).errValidation);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

class AuthFailure extends Failure {
  const AuthFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errAuth
        : 'Phiên đăng nhập đã hết hạn hoặc tài khoản/mật khẩu không chính xác. Vui lòng đăng nhập lại.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(context, AppLocalizations.of(context).errAuth);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errPermission
        : 'Tài khoản của bạn không có quyền thực hiện chức năng này.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(
        context, AppLocalizations.of(context).errPermission);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String? message,
    super.code,
    super.details,
    super.timestamp,
  }) : super(customMessage: message);

  @override
  String get message {
    final l10n = AppLanguage.current;
    final fallback = l10n != null
        ? l10n.errTimeout
        : 'Kết nối mạng quá chậm hoặc bị gián đoạn. Vui lòng thử lại.';
    return _sanitizeRawMessage(customMessage, fallback);
  }

  @override
  String getMessage(BuildContext context) {
    return _sanitizeMessage(context, AppLocalizations.of(context).errTimeout);
  }

  @override
  List<Object?> get props => [customMessage, code, details, timestamp];
}

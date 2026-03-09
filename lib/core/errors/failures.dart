import 'package:equatable/equatable.dart';

// ─── Base failures ────────────────────────────────────────────────────────────
abstract class Failure extends Equatable {
  final String message;
  const Failure({this.message = 'Có lỗi xảy ra'});

  @override
  List<Object?> get props => [message];
}

// ─── Concrete failures ────────────────────────────────────────────────────────

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({super.message = 'Lỗi máy chủ', this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Không có kết nối mạng'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Lỗi bộ nhớ đệm'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Không tìm thấy dữ liệu'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Dữ liệu không hợp lệ'});
}

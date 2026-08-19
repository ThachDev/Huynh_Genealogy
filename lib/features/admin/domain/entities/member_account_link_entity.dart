import 'package:equatable/equatable.dart';

/// Một nút thành viên trên cây gia phả kèm trạng thái liên kết tài khoản.
/// Dùng cho màn hình "Quản lý Tài khoản & Liên kết".
class MemberAccountLinkEntity extends Equatable {

  const MemberAccountLinkEntity({
    required this.memberId,
    required this.fullName,
    required this.gender,
    this.avatarUrl,
    this.generation,
    this.parentId,
    this.spouseId,
    this.linkedAccount,
    this.pendingInvite,
  });
  final int memberId;
  final String fullName;
  final String gender;
  final String? avatarUrl;
  final int? generation;
  final int? parentId;
  final int? spouseId;

  /// Tài khoản đang liên kết với nút này (nếu có).
  final LinkedAccountEntity? linkedAccount;

  /// Lời mời email đang chờ (chưa có tài khoản tương ứng đăng ký).
  final PendingInviteEntity? pendingInvite;

  bool get isLinked => linkedAccount != null;

  @override
  List<Object?> get props => [
        memberId,
        fullName,
        gender,
        avatarUrl,
        generation,
        parentId,
        spouseId,
        linkedAccount,
        pendingInvite,
      ];
}

class LinkedAccountEntity extends Equatable {

  const LinkedAccountEntity({
    required this.userId,
    required this.email,
    required this.fullName,
  });
  final int userId;
  final String email;
  final String fullName;

  @override
  List<Object?> get props => [userId, email, fullName];
}

class PendingInviteEntity extends Equatable {

  const PendingInviteEntity({
    required this.id,
    required this.email,
    required this.status,
  });
  final int id;
  final String email;
  final String status;

  @override
  List<Object?> get props => [id, email, status];
}
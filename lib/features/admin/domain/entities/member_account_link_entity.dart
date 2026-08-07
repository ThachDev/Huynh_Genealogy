import 'package:equatable/equatable.dart';

/// Một nút thành viên trên cây gia phả kèm trạng thái liên kết tài khoản.
/// Dùng cho màn hình "Quản lý Tài khoản & Liên kết".
class MemberAccountLinkEntity extends Equatable {
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
  final int userId;
  final String email;
  final String fullName;

  const LinkedAccountEntity({
    required this.userId,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object?> get props => [userId, email, fullName];
}

class PendingInviteEntity extends Equatable {
  final int id;
  final String email;
  final String status;

  const PendingInviteEntity({
    required this.id,
    required this.email,
    required this.status,
  });

  @override
  List<Object?> get props => [id, email, status];
}
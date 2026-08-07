import '../../domain/entities/member_account_link_entity.dart';

class MemberAccountLinkModel {
  static MemberAccountLinkEntity fromJson(Map<String, dynamic> json) {
    final member = json['member'] as Map<String, dynamic>? ?? {};
    final linkedJson = json['linkedAccount'] as Map<String, dynamic>?;
    final pendingJson = json['pendingInvite'] as Map<String, dynamic>?;

    return MemberAccountLinkEntity(
      memberId: _toInt(member['id']) ?? 0,
      fullName: member['fullName'] as String? ?? '',
      gender: member['gender'] as String? ?? 'unknown',
      avatarUrl: member['avatarUrl'] as String?,
      generation: _toInt(member['generation']),
      parentId: _toInt(member['parentId']),
      spouseId: _toInt(member['spouseId']),
      linkedAccount: linkedJson == null
          ? null
          : LinkedAccountEntity(
              userId: _toInt(linkedJson['userId']) ?? 0,
              email: linkedJson['email'] as String? ?? '',
              fullName: linkedJson['fullName'] as String? ?? '',
            ),
      pendingInvite: pendingJson == null
          ? null
          : PendingInviteEntity(
              id: _toInt(pendingJson['id']) ?? 0,
              email: pendingJson['email'] as String? ?? '',
              status: pendingJson['status'] as String? ?? 'PENDING',
            ),
    );
  }

  /// Ép kiểu an toàn: chấp nhận số thật (int/double) hoặc chuỗi số.
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value.trim());
    }
    return null;
  }
}
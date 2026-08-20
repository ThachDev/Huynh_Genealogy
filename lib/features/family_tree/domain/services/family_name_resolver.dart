import '../entities/member_entity.dart';

/// Giải quyết tên họ của gia tộc từ danh sách thành viên.
///
/// Tên họ được lấy từ thành viên gốc (thế hệ 1 hoặc không có cha/mẹ).
/// Dùng chung cho cả Admin Dashboard và User Dashboard.
class FamilyNameResolver {
  const FamilyNameResolver._();

  /// Trả về phần họ (từ đầu tiên trong họ tên) của thành viên gốc.
  ///
  /// Trả về `null` nếu danh sách trống hoặc thành viên gốc không có tên hợp lệ.
  static String? resolveSurname(List<MemberEntity> members) {
    if (members.isEmpty) return null;

    final rootMembers = members.where(
      (m) => m.generation == 1 || m.parentId == null,
    );
    final rootMember = rootMembers.isNotEmpty
        ? rootMembers.first
        : members.first;

    final parts = rootMember.fullName.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return null;

    return parts.first;
  }
}
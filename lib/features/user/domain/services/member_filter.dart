import '../../../../core/domain/entity/member_entity.dart';

/// Filter criteria cho danh sách thành viên.
class MemberFilter {
  const MemberFilter({
    this.branchId,
    this.status = MemberStatusFilter.all,
    this.gender = MemberGenderFilter.all,
    this.searchQuery = '',
  });

  final int? branchId;
  final MemberStatusFilter status;
  final MemberGenderFilter gender;
  final String searchQuery;

  /// Tạo bản sao với thay đổi một số trường.
  MemberFilter copyWith({
    int? branchId,
    MemberStatusFilter? status,
    MemberGenderFilter? gender,
    String? searchQuery,
  }) {
    return MemberFilter(
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Kiểm tra có filter nào active không (để hiện UI clear/reset).
  bool get hasActiveFilters =>
      branchId != null ||
      status != MemberStatusFilter.all ||
      gender != MemberGenderFilter.all ||
      searchQuery.isNotEmpty;

  /// Lọc danh sách [MemberEntity] theo criteria.
  List<MemberEntity> apply(List<MemberEntity> members) {
    final query = searchQuery.trim().toLowerCase();

    return members.where((m) {
      // Branch filter
      if (branchId != null && m.branchId != branchId) return false;

      // Status filter
      if (status == MemberStatusFilter.alive && !m.isAlive) return false;
      if (status == MemberStatusFilter.deceased && m.isAlive) return false;

      // Gender filter
      if (gender == MemberGenderFilter.male && m.gender != Gender.male) return false;
      if (gender == MemberGenderFilter.female && m.gender != Gender.female) return false;

      // Search filter (tên hoặc tên chi tộc)
      if (query.isNotEmpty) {
        final nameMatch = m.fullName.toLowerCase().contains(query);
        final branchMatch = m.branchName?.toLowerCase().contains(query) ?? false;
        if (!nameMatch && !branchMatch) return false;
      }

      return true;
    }).toList();
  }
}

/// Filter trạng thái: tất cả / còn sống / đã mất.
enum MemberStatusFilter { all, alive, deceased }

/// Filter giới tính: tất cả / nam / nữ.
enum MemberGenderFilter { all, male, female }
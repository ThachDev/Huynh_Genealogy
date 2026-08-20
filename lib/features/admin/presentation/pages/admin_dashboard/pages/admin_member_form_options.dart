import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';

/// Kết quả lọc thông minh danh sách ứng viên cho các dropdown
/// Cha/Mẹ, Vợ/Chồng trong form thành viên.
///
/// Thuần logic — tách khỏi UI để dễ kiểm thử các luật ràng buộc quan hệ.
class MemberFormOptions {
  const MemberFormOptions({
    required this.parentOptions,
    required this.spouseOptions,
  });

  final List<MemberEntity> parentOptions;
  final List<MemberEntity> spouseOptions;

  static MemberFormOptions compute({
    required List<MemberEntity> allMembers,
    required MemberEntity? existingMember,
    required int? parentId,
    required int? spouseId,
    required Gender gender,
    required int? currentGeneration,
    required int? initialParentId,
    required int? initialSpouseId,
  }) {
    // Đệ quy tìm tất cả con cháu trực hệ của một member để tránh chọn con làm cha mẹ
    Set<int> getDescendantIds(int memberId) {
      final descendants = <int>{};
      void dfs(int id) {
        for (final child in allMembers) {
          if (child.parentId == id && !descendants.contains(child.id)) {
            descendants.add(child.id);
            dfs(child.id);
          }
        }
      }

      dfs(memberId);
      return descendants;
    }

    final descendants = existingMember != null
        ? getDescendantIds(existingMember.id)
        : <int>{};

    final ancestors = <int>{};
    void dfsAncestors(int? parentId) {
      if (parentId == null) return;
      if (!ancestors.contains(parentId)) {
        ancestors.add(parentId);
        final parent =
            allMembers.where((m) => m.id == parentId).firstOrNull;
        if (parent != null) {
          dfsAncestors(parent.parentId);
        }
      }
    }

    if (existingMember != null) {
      dfsAncestors(existingMember.parentId);
    }

    // Cha/Mẹ: Danh sách thành viên (chỉ loại trừ chính mình, vợ/chồng hiện tại và con cháu)
    final parentOptions = allMembers.where((m) {
      if (m.id == existingMember?.id) return false;
      // LUÔN CHO PHÉP parent hiện tại để không bị reset ngầm khi chỉnh sửa
      if (existingMember != null && m.id == existingMember.parentId) {
        return true;
      }
      if (initialParentId != null && m.id == initialParentId) {
        return true;
      }

      // Không được chọn vợ/chồng làm cha/mẹ
      if (spouseId != null && m.id == spouseId) return false;
      // Không được chọn con cháu của chính mình làm cha/mẹ
      if (descendants.contains(m.id)) return false;

      return true;
    }).toList();

    // Vợ/Chồng: cùng thế hệ + ngược giới tính + chưa có vợ/chồng khác
    final spouseOptions = allMembers.where((m) {
      if (m.id == existingMember?.id) return false;
      // LUÔN CHO PHÉP spouse hiện tại để không bị reset ngầm khi chỉnh sửa
      if (existingMember != null && m.id == existingMember.spouseId) {
        return true;
      }
      if (initialSpouseId != null && m.id == initialSpouseId) {
        return true;
      }

      // Không được chọn cha/mẹ làm vợ/chồng
      if (parentId != null && m.id == parentId) return false;
      // Không được cưới tổ tiên hoặc con cháu
      if (descendants.contains(m.id) || ancestors.contains(m.id)) {
        return false;
      }
      // Lọc cùng thế hệ
      if (currentGeneration != null && m.generation != null) {
        if (m.generation != currentGeneration) return false;
      }
      // Lọc ngược giới tính
      if (gender == Gender.male && m.gender == Gender.male) {
        return false;
      }
      if (gender == Gender.female && m.gender == Gender.female) {
        return false;
      }
      // Bỏ những người đã có vợ/chồng khác
      if (m.spouseId != null &&
          m.spouseId != existingMember?.id &&
          m.spouseId != spouseId) {
        // Cho phép Đa thê: Nếu Nữ đang chọn chồng, thì cho phép chọn Nam dù Nam đã có vợ
        if (gender == Gender.female && m.gender == Gender.male) {
          // allow
        } else {
          return false;
        }
      }
      // Không được cưới anh/chị/em ruột (chung parentId)
      if (parentId != null &&
          m.parentId != null &&
          m.parentId == parentId) {
        return false;
      }
      // Không được cưới anh/em họ trực hệ gần (con của cô dì chú bác ruột - chung ông bà)
      if (parentId != null) {
        final myParent =
            allMembers.where((x) => x.id == parentId).firstOrNull;
        if (myParent != null &&
            myParent.parentId != null &&
            m.parentId != null) {
          final spouseParent =
              allMembers.where((x) => x.id == m.parentId).firstOrNull;
          if (spouseParent != null &&
              spouseParent.parentId == myParent.parentId) {
            return false; // Chung ông/bà nội ngoại
          }
        }
      }
      return true;
    }).toList();

    return MemberFormOptions(
      parentOptions: parentOptions,
      spouseOptions: spouseOptions,
    );
  }
}
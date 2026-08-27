import '../entities/kinship_result_entity.dart';
import '../entities/member_entity.dart';

class KinshipCalculatorService {
  static const String unknownRelation = 'Đồng tộc / Chưa rõ liên kết';

  /// Tính toán mối quan hệ và danh xưng xưng hô 2 chiều giữa [fromMember] và [toMember]
  KinshipResultEntity calculate({
    required MemberEntity fromMember,
    required MemberEntity toMember,
    required List<MemberEntity> allMembers,
  }) {
    // 1. Cùng 1 người
    if (fromMember.id == toMember.id) {
      return KinshipResultEntity(
        fromMember: fromMember,
        toMember: toMember,
        generationDiff: 0,
        fromCallsTo: 'Bản thân',
        toCallsFrom: 'Bản thân',
        selfPronounFrom: 'Tôi',
        selfPronounTo: 'Tôi',
        relationshipName: 'Chính mình',
        explanation: 'Đây là chính hồ sơ của bạn.',
        path: [KinshipPathStep(member: fromMember, roleInPath: 'Bản thân')],
        isSamePerson: true,
      );
    }

    final memberMap = {for (final m in allMembers) m.id: m};

    // 2. Kiểm tra quan hệ Vợ - Chồng trực tiếp
    if (_areDirectSpouses(fromMember, toMember)) {
      return _buildSpouseResult(fromMember, toMember);
    }

    // 3. Xử lý trường hợp Dâu / Rể (Một trong 2 người là dâu/rể không có cha mẹ trong cây)
    final fromBlood = _getBloodRelative(fromMember, memberMap);
    final toBlood = _getBloodRelative(toMember, memberMap);

    // 4. Tìm đường dẫn tổ tiên từ mỗi người
    final pathFrom = _buildAncestorPath(fromBlood, memberMap);
    final pathTo = _buildAncestorPath(toBlood, memberMap);

    // 5. Tìm Tổ tiên chung gần nhất (LCA)
    MemberEntity? lca;
    int? fromLcaIndex;
    int? toLcaIndex;

    for (int i = 0; i < pathFrom.length; i++) {
      final a = pathFrom[i];
      final j = pathTo.indexWhere((b) =>
          b.id == a.id ||
          (b.spouseId != null && b.spouseId == a.id) ||
          (a.spouseId != null && a.spouseId == b.id));
      if (j != -1) {
        lca = a;
        fromLcaIndex = i;
        toLcaIndex = j;
        break;
      }
    }

    // Không tìm thấy tổ tiên chung
    if (lca == null || fromLcaIndex == null || toLcaIndex == null) {
      return KinshipResultEntity(
        fromMember: fromMember,
        toMember: toMember,
        generationDiff: (fromMember.generation ?? 0) - (toMember.generation ?? 0),
        fromCallsTo: 'Đồng tộc / Chưa rõ liên kết',
        toCallsFrom: 'Đồng tộc / Chưa rõ liên kết',
        selfPronounFrom: 'Tôi',
        selfPronounTo: 'Tôi',
        relationshipName: 'Cùng dòng họ (Chưa nối cây)',
        explanation:
            'Chưa tìm thấy tổ tiên chung kết nối giữa ${fromMember.fullName} và ${toMember.fullName} trong cây gia phả hiện tại.',
        path: [
          KinshipPathStep(member: fromMember, roleInPath: 'Bắt đầu'),
          KinshipPathStep(member: toMember, roleInPath: 'Đích đến'),
        ],
      );
    }

    // 6. Xây dựng danh sách chuỗi mắt xích liên kết (Full Path)
    final fullPathMembers = <MemberEntity>[];
    for (int i = 0; i <= fromLcaIndex; i++) {
      fullPathMembers.add(pathFrom[i]);
    }
    for (int j = toLcaIndex - 1; j >= 0; j--) {
      fullPathMembers.add(pathTo[j]);
    }

    // Nếu fromMember là dâu/rể, thêm vào đầu
    if (fromMember.id != fromBlood.id) {
      fullPathMembers.insert(0, fromMember);
    }
    // Nếu toMember là dâu/rể, thêm vào cuối
    if (toMember.id != toBlood.id) {
      fullPathMembers.add(toMember);
    }

    final pathSteps = _generatePathSteps(
      fullPathMembers,
      fromMember,
      toMember,
      lca,
    );

    // 7. Khoảng cách thế hệ: dFrom = số đời từ LCA xuống fromBlood, dTo = số đời từ LCA xuống toBlood
    final dFrom = fromLcaIndex;
    final dTo = toLcaIndex;
    final genDiff = dFrom - dTo;

    // 8. Kiểm tra quan hệ Trực hệ (Cha - Con, Ông - Cháu, Cụ - Chắt)
    if (dTo == 0) {
      // toMember (hoặc vợ/chồng toMember) chính là Tổ tiên trực hệ của fromMember
      return _buildDirectAncestorResult(
        fromMember: fromMember,
        toMember: toMember,
        lca: lca,
        generationDiff: dFrom,
        pathSteps: pathSteps,
        isToSpouse: toMember.id != toBlood.id,
      );
    }

    if (dFrom == 0) {
      // fromMember (hoặc vợ/chồng fromMember) chính là Tổ tiên trực hệ của toMember
      return _buildDirectDescendantResult(
        fromMember: fromMember,
        toMember: toMember,
        lca: lca,
        generationDiff: -dTo,
        pathSteps: pathSteps,
        isFromSpouse: fromMember.id != fromBlood.id,
      );
    }

    // 9. Quan hệ Bàng hệ (Anh em họ, Chú bác họ, Ông bà họ...)
    // Xác định 2 nhánh con trực tiếp của LCA
    final subRootFrom = pathFrom[fromLcaIndex - 1];
    final subRootTo = pathTo[toLcaIndex - 1];

    // So sánh thứ bậc giữa 2 nhánh con (nhánh nào sinh trước / là cành Bác / Trưởng)
    final isToSeniorBranch = _isSenior(subRootTo, subRootFrom, memberMap);

    return _buildCollateralResult(
      fromMember: fromMember,
      toMember: toMember,
      fromBlood: fromBlood,
      toBlood: toBlood,
      lca: lca,
      dFrom: dFrom,
      dTo: dTo,
      genDiff: genDiff,
      isToSeniorBranch: isToSeniorBranch,
      pathSteps: pathSteps,
    );
  }

  // --- Helper Methods ---

  bool _areDirectSpouses(MemberEntity a, MemberEntity b) {
    return (a.spouseId != null && a.spouseId == b.id) ||
        (b.spouseId != null && b.spouseId == a.id);
  }

  MemberEntity _getBloodRelative(
      MemberEntity member, Map<int, MemberEntity> map) {
    // Nếu thành viên không có cha mẹ nhưng có spouseId thì tìm người hôn phối
    if ((member.parentId == null || member.parentId == 0) &&
        (member.motherId == null || member.motherId == 0) &&
        member.spouseId != null &&
        map.containsKey(member.spouseId)) {
      final spouse = map[member.spouseId]!;
      if ((spouse.parentId != null && spouse.parentId != 0) ||
          (spouse.motherId != null && spouse.motherId != 0)) {
        return spouse;
      }
    }
    return member;
  }

  List<MemberEntity> _buildAncestorPath(
      MemberEntity start, Map<int, MemberEntity> map) {
    final path = <MemberEntity>[start];
    final visited = <int>{start.id};
    var curr = start;

    while (true) {
      MemberEntity? parent;
      if (curr.parentId != null && curr.parentId != 0 && map.containsKey(curr.parentId)) {
        parent = map[curr.parentId];
      } else if (curr.motherId != null && curr.motherId != 0 && map.containsKey(curr.motherId)) {
        parent = map[curr.motherId];
      }

      // Chuẩn hóa parent: nếu parent là nữ và có chồng nam trong cây gia phả, hoặc parent không có cha mẹ nhưng chồng có cha mẹ
      if (parent != null && parent.spouseId != null && map.containsKey(parent.spouseId)) {
        final spouse = map[parent.spouseId]!;
        if ((parent.gender == Gender.female && spouse.gender == Gender.male) ||
            ((parent.parentId == null || parent.parentId == 0) &&
             (spouse.parentId != null && spouse.parentId != 0))) {
          parent = spouse;
        }
      }

      if (parent != null && !visited.contains(parent.id)) {
        path.add(parent);
        visited.add(parent.id);
        curr = parent;
      } else {
        break;
      }
    }
    return path;
  }

  bool _isSenior(
      MemberEntity a, MemberEntity b, Map<int, MemberEntity> memberMap) {
    if (a.id == b.id) return false;

    // So sánh ngày sinh
    final birthA = _parseBirthDate(a.dateOfBirth);
    final birthB = _parseBirthDate(b.dateOfBirth);
    if (birthA != null && birthB != null) {
      if (birthA.isBefore(birthB)) return true;
      if (birthA.isAfter(birthB)) return false;
    }

    // Nếu không có ngày sinh, so sánh ID nhỏ hơn làm nhánh anh (quy ước phổ biến trong dữ liệu)
    return a.id < b.id;
  }

  DateTime? _parseBirthDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    final parts = dateStr.split('-');
    if (parts.length == 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2]);
      if (y != null && m != null && d != null) {
        return DateTime(y, m, d);
      }
    } else if (parts.length == 1) {
      final y = int.tryParse(parts[0]);
      if (y != null) return DateTime(y);
    }
    return null;
  }

  KinshipResultEntity _buildSpouseResult(MemberEntity from, MemberEntity to) {
    final fromIsMale = from.gender == Gender.male;
    final fromCallsTo = fromIsMale ? 'Vợ' : 'Chồng';
    final toCallsFrom = fromIsMale ? 'Chồng' : 'Vợ';
    final selfPronounFrom = fromIsMale ? 'Chồng' : 'Vợ';
    final selfPronounTo = fromIsMale ? 'Vợ' : 'Chồng';

    return KinshipResultEntity(
      fromMember: from,
      toMember: to,
      generationDiff: 0,
      fromCallsTo: fromCallsTo,
      toCallsFrom: toCallsFrom,
      selfPronounFrom: selfPronounFrom,
      selfPronounTo: selfPronounTo,
      relationshipName: 'Vợ chồng',
      explanation:
          '${from.fullName} và ${to.fullName} có quan hệ hôn phối (Vợ chồng).',
      path: [
        KinshipPathStep(member: from, roleInPath: fromCallsTo == 'Vợ' ? 'Chồng' : 'Vợ'),
        KinshipPathStep(member: to, roleInPath: toCallsFrom == 'Vợ' ? 'Chồng' : 'Vợ'),
      ],
      areSpouses: true,
      isDirectLineage: true,
    );
  }

  KinshipResultEntity _buildDirectAncestorResult({
    required MemberEntity fromMember,
    required MemberEntity toMember,
    required MemberEntity lca,
    required int generationDiff,
    required List<KinshipPathStep> pathSteps,
    required bool isToSpouse,
  }) {
    final isMale = toMember.gender == Gender.male;
    String fromCallsTo = '';
    String toCallsFrom = '';
    String relationshipName = '';
    String explanation = '';

    switch (generationDiff) {
      case 1:
        fromCallsTo = isMale ? 'Bố' : 'Mẹ';
        toCallsFrom = fromMember.gender == Gender.male ? 'Con trai' : 'Con gái';
        relationshipName = 'Bố/Mẹ - Con';
        explanation = '${toMember.fullName} là $fromCallsTo ruột của ${fromMember.fullName}.';
        break;
      case 2:
        fromCallsTo = isMale ? 'Ông nội' : 'Bà nội';
        toCallsFrom = 'Cháu';
        relationshipName = 'Ông/Bà - Cháu';
        explanation = '${toMember.fullName} là $fromCallsTo của ${fromMember.fullName}.';
        break;
      case 3:
        fromCallsTo = isMale ? 'Cụ ông' : 'Cụ bà';
        toCallsFrom = 'Chắt';
        relationshipName = 'Cụ - Chắt';
        explanation = '${toMember.fullName} là $fromCallsTo (Tằng tổ) của ${fromMember.fullName}.';
        break;
      case 4:
        fromCallsTo = isMale ? 'Kỵ ông' : 'Kỵ bà';
        toCallsFrom = 'Chút (Chít)';
        relationshipName = 'Kỵ - Chút';
        explanation = '${toMember.fullName} là $fromCallsTo (Cao tổ) của ${fromMember.fullName}.';
        break;
      default:
        fromCallsTo = 'Cụ Tổ đời thứ $generationDiff';
        toCallsFrom = 'Cháu chắt đời thứ $generationDiff';
        relationshipName = 'Tổ tiên - Hậu duệ';
        explanation = '${toMember.fullName} là Tổ tiên trực hệ cách $generationDiff đời của ${fromMember.fullName}.';
    }

    return KinshipResultEntity(
      fromMember: fromMember,
      toMember: toMember,
      lowestCommonAncestor: lca,
      generationDiff: generationDiff,
      fromCallsTo: fromCallsTo,
      toCallsFrom: toCallsFrom,
      selfPronounFrom: generationDiff == 1 ? 'Con' : (generationDiff == 2 ? 'Cháu' : 'Chắt'),
      selfPronounTo: fromCallsTo,
      relationshipName: relationshipName,
      explanation: explanation,
      path: pathSteps,
      isDirectLineage: true,
    );
  }

  KinshipResultEntity _buildDirectDescendantResult({
    required MemberEntity fromMember,
    required MemberEntity toMember,
    required MemberEntity lca,
    required int generationDiff,
    required List<KinshipPathStep> pathSteps,
    required bool isFromSpouse,
  }) {
    // Ngược lại của Direct Ancestor
    final inv = _buildDirectAncestorResult(
      fromMember: toMember,
      toMember: fromMember,
      lca: lca,
      generationDiff: -generationDiff,
      pathSteps: pathSteps.reversed.toList(),
      isToSpouse: isFromSpouse,
    );

    return KinshipResultEntity(
      fromMember: fromMember,
      toMember: toMember,
      lowestCommonAncestor: lca,
      generationDiff: generationDiff,
      fromCallsTo: inv.toCallsFrom,
      toCallsFrom: inv.fromCallsTo,
      selfPronounFrom: inv.selfPronounTo,
      selfPronounTo: inv.selfPronounFrom,
      relationshipName: inv.relationshipName,
      explanation: '${fromMember.fullName} là ${inv.fromCallsTo} của ${toMember.fullName}.',
      path: pathSteps,
      isDirectLineage: true,
    );
  }

  KinshipResultEntity _buildCollateralResult({
    required MemberEntity fromMember,
    required MemberEntity toMember,
    required MemberEntity fromBlood,
    required MemberEntity toBlood,
    required MemberEntity lca,
    required int dFrom,
    required int dTo,
    required int genDiff,
    required bool isToSeniorBranch,
    required List<KinshipPathStep> pathSteps,
  }) {
    final toIsMale = toMember.gender == Gender.male;
    final isToSpouse = toMember.id != toBlood.id;
    final isFromSpouse = fromMember.id != fromBlood.id;

    String fromCallsTo = '';
    String toCallsFrom = '';
    String selfPronounFrom = '';
    String selfPronounTo = '';
    String relationshipName = '';
    String explanation = '';

    if (genDiff == 0) {
      // --- CÙNG THẾ HỆ (Ngang hàng) ---
      if (dFrom == 1) {
        // Cùng cha mẹ ruột
        final toIsOlder = _isSenior(toMember, fromMember, {});
        if (toIsOlder) {
          fromCallsTo = toIsMale ? 'Anh ruột' : 'Chị ruột';
          toCallsFrom = 'Em ruột';
          selfPronounFrom = 'Em';
          selfPronounTo = toIsMale ? 'Anh' : 'Chị';
          relationshipName = 'Anh/Chị - Em ruột';
          explanation = '${toMember.fullName} là $fromCallsTo của ${fromMember.fullName}.';
        } else {
          fromCallsTo = 'Em ruột';
          toCallsFrom = fromMember.gender == Gender.male ? 'Anh ruột' : 'Chị ruột';
          selfPronounFrom = fromMember.gender == Gender.male ? 'Anh' : 'Chị';
          selfPronounTo = 'Em';
          relationshipName = 'Anh/Chị - Em ruột';
          explanation = '${fromMember.fullName} là $toCallsFrom của ${toMember.fullName}.';
        }
      } else {
        // Anh em họ (Con chú con bác / Con cô cậu / Họ hàng)
        final degree = dFrom == 2 ? 'con chú con bác' : '$dFrom đời';
        if (isToSeniorBranch) {
          // toMember thuộc cành Bác (nhánh trên)
          if (isToSpouse) {
            fromCallsTo = toIsMale ? 'Anh rể họ' : 'Chị dâu họ';
          } else {
            fromCallsTo = toIsMale ? 'Anh họ' : 'Chị họ';
          }
          toCallsFrom = isFromSpouse
              ? (fromMember.gender == Gender.male ? 'Em rể họ' : 'Em dâu họ')
              : 'Em họ';
          selfPronounFrom = 'Em';
          selfPronounTo = toIsMale ? 'Anh' : 'Chị';
          relationshipName = 'Anh/Chị họ - Em họ ($degree)';
          explanation =
              '${toMember.fullName} thuộc nhánh trên (cành Bác) cùng thế hệ. ${fromMember.fullName} gọi ${toMember.fullName} là $fromCallsTo và xưng $selfPronounFrom.';
        } else {
          // fromMember thuộc cành Bác (nhánh trên)
          fromCallsTo = isToSpouse
              ? (toIsMale ? 'Em rể họ' : 'Em dâu họ')
              : 'Em họ';
          toCallsFrom = isFromSpouse
              ? (fromMember.gender == Gender.male ? 'Anh rể họ' : 'Chị dâu họ')
              : (fromMember.gender == Gender.male ? 'Anh họ' : 'Chị họ');
          selfPronounFrom = fromMember.gender == Gender.male ? 'Anh' : 'Chị';
          selfPronounTo = 'Em';
          relationshipName = 'Anh/Chị họ - Em họ ($degree)';
          explanation =
              '${fromMember.fullName} thuộc nhánh trên (cành Bác) cùng thế hệ. ${toMember.fullName} gọi ${fromMember.fullName} là $toCallsFrom và xưng $selfPronounTo.';
        }
      }
    } else if (genDiff == 1) {
      // --- toMember LÀ BẬC CHA CHÚ (Cách 1 đời) ---
      if (dTo == 1) {
        // toMember là anh/em ruột của Bố/Mẹ fromMember
        if (isToSeniorBranch) {
          fromCallsTo = isToSpouse
              ? (toIsMale ? 'Bác dượng' : 'Bác dâu')
              : (toIsMale ? 'Bác trai' : 'Bác gái');
        } else {
          if (toIsMale) {
            fromCallsTo = isToSpouse ? 'Chú dượng' : 'Chú';
          } else {
            fromCallsTo = isToSpouse ? 'Thím' : 'Cô';
          }
        }
        toCallsFrom = 'Cháu';
      } else {
        // toMember là anh em họ của Bố/Mẹ fromMember
        if (isToSeniorBranch) {
          fromCallsTo = isToSpouse
              ? (toIsMale ? 'Bác dượng họ' : 'Bác dâu họ')
              : (toIsMale ? 'Bác họ' : 'Bác gái họ');
        } else {
          if (toIsMale) {
            fromCallsTo = isToSpouse ? 'Chú dượng họ' : 'Chú họ';
          } else {
            fromCallsTo = isToSpouse ? 'Thím họ' : 'Cô họ';
          }
        }
        toCallsFrom = 'Cháu họ';
      }
      selfPronounFrom = 'Cháu';
      selfPronounTo = fromCallsTo.contains('Bác')
          ? 'Bác'
          : (fromCallsTo.contains('Chú') ? 'Chú' : (fromCallsTo.contains('Thím') ? 'Thím' : 'Cô'));
      relationshipName = '$fromCallsTo - $toCallsFrom';
      explanation =
          '${toMember.fullName} là bậc trên (cách 1 thế hệ so với ${fromMember.fullName}). Bạn gọi là $fromCallsTo và xưng $selfPronounFrom.';
    } else if (genDiff == -1) {
      // --- fromMember LÀ BẬC CHA CHÚ CỦA toMember ---
      final inv = _buildCollateralResult(
        fromMember: toMember,
        toMember: fromMember,
        fromBlood: toBlood,
        toBlood: fromBlood,
        lca: lca,
        dFrom: dTo,
        dTo: dFrom,
        genDiff: 1,
        isToSeniorBranch: !isToSeniorBranch,
        pathSteps: pathSteps.reversed.toList(),
      );
      fromCallsTo = inv.toCallsFrom;
      toCallsFrom = inv.fromCallsTo;
      selfPronounFrom = inv.selfPronounTo;
      selfPronounTo = inv.selfPronounFrom;
      relationshipName = inv.relationshipName;
      explanation = '${fromMember.fullName} là bậc trên (cách 1 thế hệ). ${toMember.fullName} gọi bạn là $toCallsFrom và xưng $selfPronounTo.';
    } else if (genDiff == 2) {
      // --- toMember LÀ BẬC ÔNG BÀ HỌ (Cách 2 đời) ---
      if (isToSeniorBranch) {
        fromCallsTo = toIsMale ? 'Ông Bác' : 'Bà Bác';
      } else {
        fromCallsTo = toIsMale ? 'Ông Chú' : 'Bà Cô';
      }
      toCallsFrom = 'Cháu họ';
      selfPronounFrom = 'Cháu';
      selfPronounTo = toIsMale ? 'Ông' : 'Bà';
      relationshipName = '$fromCallsTo - $toCallsFrom';
      explanation =
          '${toMember.fullName} thuộc hàng Ông/Bà họ (cách 2 thế hệ). ${fromMember.fullName} gọi là $fromCallsTo và xưng $selfPronounFrom.';
    } else if (genDiff == -2) {
      // --- fromMember LÀ BẬC ÔNG BÀ HỌ ---
      final inv = _buildCollateralResult(
        fromMember: toMember,
        toMember: fromMember,
        fromBlood: toBlood,
        toBlood: fromBlood,
        lca: lca,
        dFrom: dTo,
        dTo: dFrom,
        genDiff: 2,
        isToSeniorBranch: !isToSeniorBranch,
        pathSteps: pathSteps.reversed.toList(),
      );
      fromCallsTo = inv.toCallsFrom;
      toCallsFrom = inv.fromCallsTo;
      selfPronounFrom = inv.selfPronounTo;
      selfPronounTo = inv.selfPronounFrom;
      relationshipName = inv.relationshipName;
      explanation = '${fromMember.fullName} là hàng Ông/Bà họ (cách 2 thế hệ). ${toMember.fullName} gọi bạn là $toCallsFrom và xưng $selfPronounTo.';
    } else if (genDiff >= 3) {
      // --- toMember LÀ BẬC CỤ / KỴ HỌ ---
      final title = genDiff == 3 ? 'Cụ' : (genDiff == 4 ? 'Kỵ' : 'Tổ');
      fromCallsTo = '$title họ';
      toCallsFrom = genDiff == 3 ? 'Chắt họ' : 'Chút họ';
      selfPronounFrom = genDiff == 3 ? 'Chắt' : 'Cháu';
      selfPronounTo = title;
      relationshipName = '$fromCallsTo - $toCallsFrom';
      explanation = '${toMember.fullName} là bậc tiền bối họ hàng cách $genDiff thế hệ.';
    } else {
      // --- fromMember LÀ BẬC CỤ / KỴ HỌ ---
      final title = (-genDiff) == 3 ? 'Cụ' : ((-genDiff) == 4 ? 'Kỵ' : 'Tổ');
      fromCallsTo = (-genDiff) == 3 ? 'Chắt họ' : 'Chút họ';
      toCallsFrom = '$title họ';
      selfPronounFrom = title;
      selfPronounTo = (-genDiff) == 3 ? 'Chắt' : 'Cháu';
      relationshipName = '$toCallsFrom - $fromCallsTo';
      explanation = '${fromMember.fullName} là bậc tiền bối họ hàng cách ${-genDiff} thế hệ.';
    }

    return KinshipResultEntity(
      fromMember: fromMember,
      toMember: toMember,
      lowestCommonAncestor: lca,
      generationDiff: genDiff,
      fromCallsTo: fromCallsTo,
      toCallsFrom: toCallsFrom,
      selfPronounFrom: selfPronounFrom,
      selfPronounTo: selfPronounTo,
      relationshipName: relationshipName,
      explanation: explanation,
      path: pathSteps,
    );
  }

  List<KinshipPathStep> _generatePathSteps(
    List<MemberEntity> members,
    MemberEntity from,
    MemberEntity to,
    MemberEntity lca,
  ) {
    return members.map((m) {
      String role = '';
      if (m.id == from.id) {
        role = 'Bạn (Người xưng)';
      } else if (m.id == to.id) {
        role = 'Người được tra cứu';
      } else if (m.id == lca.id) {
        role = 'Tổ tiên chung gần nhất (LCA)';
      } else if (m.id == from.parentId) {
        role = 'Bố của bạn';
      } else if (m.id == to.parentId) {
        role = 'Bố của đối phương';
      } else {
        role = 'Đời thứ ${m.generation ?? "?"}';
      }
      return KinshipPathStep(member: m, roleInPath: role);
    }).toList();
  }
}

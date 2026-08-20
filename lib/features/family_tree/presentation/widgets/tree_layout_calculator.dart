import 'package:flutter/material.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import 'tree_edge_painter.dart';

/// Tính toán vị trí (Offset) của từng member trong cây gia phả dựa trên quan
/// hệ cha mẹ / vợ chồng. Thuật toán layout thuần — tách khỏi UI để dễ test.
class TreeLayoutCalculator {
  const TreeLayoutCalculator();

  Map<int, Offset> calculate(
    List<MemberEntity> rawMembers, {
    required List<TreeCoupleEdge> coupleEdges, // Junction edges: 1 entry = 1 cặp + tất cả con
    required List<TreeEdgeData> orphanEdges, // Fallback bezier cho nodes không qua layout chính
    required List<TreeSpouseEdge> spouseEdges,
    required double nodeHeight,
  }) {
    // Tách danh sách con theo cha/mẹ
    final childrenMap = <int?, List<MemberEntity>>{};
    for (final m in rawMembers) {
      if (m.parentId != null) {
        childrenMap.putIfAbsent(m.parentId, () => []).add(m);
      }
    }

    // Lọc bỏ những member hoàn toàn cô lập: không cha mẹ, không vợ chồng, không con, không chi tộc
    final members = rawMembers.where((m) {
      final hasParent = m.parentId != null || m.motherId != null;
      final hasSpouse = m.spouseId != null;
      final hasChildren = (childrenMap[m.id] ?? []).isNotEmpty;
      final hasBranch = m.branchId != null;

      // Nếu có ít nhất 1 mối liên kết -> Giữ lại để vẽ cây
      return hasParent || hasSpouse || hasChildren || hasBranch;
    }).toList();

    final memberMap = {for (final m in members) m.id: m};
    final childrenOf = <int?, List<MemberEntity>>{};
    for (final m in members) {
      childrenOf.putIfAbsent(m.parentId, () => []).add(m);
    }

    int minGen = 999;
    for (final m in members) {
      if (m.generation != null && m.generation! < minGen) {
        minGen = m.generation!;
      }
    }
    if (minGen == 999) minGen = 1;

    final visited = <int>{};

    (Map<int, Offset>, double) layoutSubtree(int nodeId, int gen) {
      if (visited.contains(nodeId)) return (<int, Offset>{}, 0.0);
      visited.add(nodeId);

      final member = memberMap[nodeId]!;
      final currentGen = member.generation ?? gen;
      final y = (currentGen - minGen) * TreeLayoutMetrics.vSpacing;

      final spouseIds = <int>[];
      if (member.spouseId != null && memberMap.containsKey(member.spouseId)) {
        spouseIds.add(member.spouseId!);
      }
      // Tìm xem có ai trỏ spouseId vào member này không
      for (final m in members) {
        if (m.spouseId == member.id && !spouseIds.contains(m.id)) {
          spouseIds.add(m.id);
        }
      }

      // Lọc các spouse đã được vẽ (do data lỗi cyclic)
      spouseIds.removeWhere((id) => visited.contains(id));
      visited.addAll(spouseIds);

      // Children linked to primary parent
      final primaryChildren = childrenOf[nodeId] ?? <MemberEntity>[];
      // Children linked to spouses
      final spouseChildren = <MemberEntity>[];
      for (final sId in spouseIds) {
        final children = childrenOf[sId];
        if (children != null) {
          spouseChildren.addAll(children);
        }
      }

      // Gộp và loại bỏ các con bị lặp lại hoặc đã được xử lý
      final allChildrenMap = <int, MemberEntity>{};
      for (final c in primaryChildren) {
        if (!visited.contains(c.id)) allChildrenMap[c.id] = c;
      }
      for (final c in spouseChildren) {
        if (!visited.contains(c.id)) allChildrenMap[c.id] = c;
      }
      final allChildren = allChildrenMap.values.toList();

      // Layout each side's subtrees
      final allResults =
          allChildren.map((c) => layoutSubtree(c.id, currentGen + 1)).toList();

      // Chỉ giữ lại những con thực sự được vẽ (width > 0)
      final validChildren = <MemberEntity>[];
      final validResults = <(Map<int, Offset>, double)>[];
      for (int i = 0; i < allChildren.length; i++) {
        if (allResults[i].$2 > 0) {
          validChildren.add(allChildren[i]);
          validResults.add(allResults[i]);
        }
      }

      // Spouse center X coordinates relative to primary (0 = primary center)
      final spouseCenterXList = <double>[];
      for (int i = 0; i < spouseIds.length; i++) {
        spouseCenterXList.add((i + 1) * (TreeLayoutMetrics.nodeWidth + TreeLayoutMetrics.spouseGap));
      }
      final maxSpouseCenterX =
          spouseIds.isNotEmpty ? spouseCenterXList.last : 0.0;

      // Midpoint giữa toàn bộ nhóm cha/mẹ (local coords) — dùng để căn giữa tất cả con
      final coupleCenter = maxSpouseCenterX / 2;

      // Tổng chiều rộng của tất cả con
      double totalChildWidth = 0;
      for (final r in validResults) {
        totalChildWidth += r.$2;
      }
      if (validResults.length > 1) {
        totalChildWidth += TreeLayoutMetrics.hSpacing * (validResults.length - 1);
      }

      // Tính bounding box của toàn bộ subtree
      double minX = -TreeLayoutMetrics.nodeWidth / 2;
      double maxX = TreeLayoutMetrics.nodeWidth / 2;
      if (spouseIds.isNotEmpty) {
        maxX = maxSpouseCenterX + TreeLayoutMetrics.nodeWidth / 2;
      }
      if (totalChildWidth > 0) {
        final childLeft = coupleCenter - totalChildWidth / 2;
        final childRight = coupleCenter + totalChildWidth / 2;
        if (childLeft < minX) minX = childLeft;
        if (childRight > maxX) maxX = childRight;
      }

      final totalWidth = maxX - minX;
      final shift = -minX; // Shift to map minX → 0

      final allPos = <int, Offset>{};
      allPos[nodeId] = Offset(shift, y);

      int prevId = nodeId;
      for (int i = 0; i < spouseIds.length; i++) {
        final sId = spouseIds[i];
        allPos[sId] = Offset(shift + spouseCenterXList[i], y);

        final isDivorced =
            memberMap[sId]?.maritalStatus == MaritalStatus.divorced ||
                memberMap[prevId]?.maritalStatus == MaritalStatus.divorced;

        spouseEdges.add(TreeSpouseEdge(
          leftMemberId: prevId,
          rightMemberId: sId,
          isDivorced: isDivorced,
        ));
        prevId = sId;
      }

      // Đặt tất cả con căn giữa tại coupleCenter (midpoint cha+mẹ)
      // cx = vị trí bắt đầu của bộ con, trong local coords (không có shift)
      double cx = coupleCenter - totalChildWidth / 2;
      for (int i = 0; i < validResults.length; i++) {
        final cPos = validResults[i].$1;
        final cWidth = validResults[i].$2;
        for (final entry in cPos.entries) {
          // entry.value.dx đo từ left-edge của subtree bounding box
          // shift + cx đặt left-edge đó đúng vị trí
          allPos[entry.key] = Offset(
            entry.value.dx + shift + cx,
            entry.value.dy,
          );
        }
        cx += cWidth + TreeLayoutMetrics.hSpacing;
      }

      if (validChildren.isNotEmpty) {
        final Map<int?, List<MemberEntity>> childrenByMother = {};
        for (final child in validChildren) {
          final mId = child.motherId;
          childrenByMother.putIfAbsent(mId, () => []).add(child);
        }

        for (final entry in childrenByMother.entries) {
          final mId = entry.key;
          final children = entry.value;

          int? edgeSpouseId;
          if (mId != null && spouseIds.contains(mId)) {
            edgeSpouseId = mId;
          }

          coupleEdges.add(TreeCoupleEdge(
            primaryId: nodeId,
            spouseId: edgeSpouseId,
            childIds: children.map((c) => c.id).toList(),
          ));
        }
      }

      return (allPos, totalWidth);
    }

    final roots = members
        .where(
          (m) => m.parentId == null || !memberMap.containsKey(m.parentId),
        )
        .toList();

    final allPositions = <int, Offset>{};
    double rootX = 0;

    if (roots.isEmpty && members.isNotEmpty) {
      // Nếu không tìm thấy root nào khớp điều kiện trên nhưng danh sách không rỗng (ví dụ data cũ)
      final firstWithLink = members.firstWhere(
        (m) =>
            m.generation == 1 ||
            m.spouseId != null ||
            (childrenOf[m.id] ?? []).isNotEmpty,
        orElse: () => members.first,
      );
      final (positions, _) = layoutSubtree(firstWithLink.id, minGen);
      for (final entry in positions.entries) {
        allPositions[entry.key] = entry.value;
      }
    } else {
      for (final root in roots) {
        // Nếu đã được đặt vị trí (ví dụ là spouse của root trước) → bỏ qua
        // tránh layout lại gây overwrite positions và duplicate coupleEdges
        if (allPositions.containsKey(root.id)) continue;
        final gen = root.generation ?? minGen;
        final (positions, width) = layoutSubtree(root.id, gen);
        for (final entry in positions.entries) {
          allPositions[entry.key] =
              Offset(entry.value.dx + rootX + width / 2, entry.value.dy);
        }
        rootX += width + TreeLayoutMetrics.rootSpacing;
      }
    }

    // Chỉ tạo spouseEdges cho các cặp không qua coupleEdges (nếu có)
    for (final m in members) {
      if (allPositions.containsKey(m.id)) {
        if (m.spouseId != null && allPositions.containsKey(m.spouseId)) {
          spouseEdges.add(TreeSpouseEdge(
            leftMemberId: m.id < m.spouseId! ? m.id : m.spouseId!,
            rightMemberId: m.id < m.spouseId! ? m.spouseId! : m.id,
          ));
        }
      }
    }

    if (allPositions.isEmpty) return allPositions;

    double minX = double.infinity, minY = double.infinity;
    for (final entry in allPositions.entries) {
      final left = entry.value.dx - TreeLayoutMetrics.nodeWidth / 2;
      final top = entry.value.dy - nodeHeight / 2;
      if (left < minX) minX = left;
      if (top < minY) minY = top;
    }

    final shift = Offset(-minX + TreeLayoutMetrics.padding, -minY + TreeLayoutMetrics.padding);
    for (final entry in allPositions.entries) {
      allPositions[entry.key] = entry.value + shift;
    }

    return allPositions;
  }
}
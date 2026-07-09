import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/auth.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../bloc/family_tree_bloc.dart';
import '../widgets/family_member_node_widget.dart';
import 'family_member_detail_page.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_member_form_page.dart';

const double _nodeWidth = 140.0;
const double _nodeHeight =
    160.0; // Đồng bộ với height cố định trong FamilyMemberNodeWidget
const double _hSpacing = 40.0;
const double _vSpacing =
    220.0; // Phải > _nodeHeight (160) để nodes không chồng lên nhau
const double _rootSpacing = 60.0;
const double _padding = 40.0;
const double _spouseGap = 16.0;

class _EdgeData {
  final int parentId;
  final int childId;
  _EdgeData({required this.parentId, required this.childId});
}

class _SpouseEdge {
  final int leftMemberId;
  final int rightMemberId;
  final bool isDivorced;
  _SpouseEdge({
    required this.leftMemberId,
    required this.rightMemberId,
    this.isDivorced = false,
  });
}

/// Nhóm tất cả con của một cặp đôi để vẽ T-bar junction thay vì bezier rời rạc
class _CoupleEdge {
  final int primaryId;
  final int? spouseId;
  final List<int> childIds;
  _CoupleEdge({
    required this.primaryId,
    this.spouseId,
    required this.childIds,
  });
}

class FamilyTreeViewPage extends StatefulWidget {
  const FamilyTreeViewPage({super.key});

  @override
  State<FamilyTreeViewPage> createState() => _FamilyTreeViewPageState();
}

class _FamilyTreeViewPageState extends State<FamilyTreeViewPage> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authState = context.read<AuthBloc>().state;
      final familyId =
          authState is Authenticated ? authState.user.familyId : null;
      context
          .read<FamilyTreeBloc>()
          .add(FamilyTreeLoadEvent(familyId: familyId));
    });
  }

  void _zoomIn() {
    final current = _transformationController.value;
    final currentScale = current.getMaxScaleOnAxis();
    final newScale = (currentScale * 1.3).clamp(0.3, 3.0);
    final scaleFactor = newScale / currentScale;
    _transformationController.value = current.clone()
      ..multiply(Matrix4.diagonal3Values(scaleFactor, scaleFactor, 1.0));
  }

  void _zoomOut() {
    final current = _transformationController.value;
    final currentScale = current.getMaxScaleOnAxis();
    final newScale = (currentScale / 1.3).clamp(0.3, 3.0);
    final scaleFactor = newScale / currentScale;
    _transformationController.value = current.clone()
      ..multiply(Matrix4.diagonal3Values(scaleFactor, scaleFactor, 1.0));
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  Map<int, Offset> _calculateLayout(
    List<MemberEntity> members,
    List<_CoupleEdge>
        coupleEdges, // Junction edges: 1 entry = 1 cặp + tất cả con
    List<_EdgeData>
        orphanEdges, // Fallback bezier cho nodes không qua layout chính
    List<_SpouseEdge> spouseEdges,
  ) {
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
      final y = (currentGen - minGen) * _vSpacing;

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
        spouseCenterXList.add((i + 1) * (_nodeWidth + _spouseGap));
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
        totalChildWidth += _hSpacing * (validResults.length - 1);
      }

      // Tính bounding box của toàn bộ subtree
      double minX = -_nodeWidth / 2;
      double maxX = _nodeWidth / 2;
      if (spouseIds.isNotEmpty) {
        maxX = maxSpouseCenterX + _nodeWidth / 2;
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

        spouseEdges.add(_SpouseEdge(
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
        cx += cWidth + _hSpacing;
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
          } else if (spouseIds.isNotEmpty) {
            edgeSpouseId = spouseIds.last;
          }

          coupleEdges.add(_CoupleEdge(
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
      final (positions, _) = layoutSubtree(members.first.id, minGen);
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
        rootX += width + _rootSpacing;
      }
    }

    for (final m in members) {
      if (!allPositions.containsKey(m.id)) {
        final gen = (m.generation ?? minGen) - minGen;
        allPositions[m.id] = Offset(rootX, gen * _vSpacing);
        rootX += _nodeWidth + _hSpacing;
        if (m.parentId != null && allPositions.containsKey(m.parentId)) {
          orphanEdges.add(_EdgeData(parentId: m.parentId!, childId: m.id));
        }
        if (m.spouseId != null && allPositions.containsKey(m.spouseId)) {
          spouseEdges.add(_SpouseEdge(
            leftMemberId: m.id < m.spouseId! ? m.id : m.spouseId!,
            rightMemberId: m.id < m.spouseId! ? m.spouseId! : m.id,
          ));
        }
      }
    }

    if (allPositions.isEmpty) return allPositions;

    double minX = double.infinity, minY = double.infinity;
    for (final entry in allPositions.entries) {
      final left = entry.value.dx - _nodeWidth / 2;
      final top = entry.value.dy - _nodeHeight / 2;
      if (left < minX) minX = left;
      if (top < minY) minY = top;
    }

    final shift = Offset(-minX + _padding, -minY + _padding);
    for (final entry in allPositions.entries) {
      allPositions[entry.key] = entry.value + shift;
    }

    return allPositions;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.familyTreeTitle,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.helpCircle, color: Colors.white),
            tooltip: l10n.helpTooltip,
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomFab(
            icon: LucideIcons.plus,
            tooltip: 'Phóng to',
            onPressed: _zoomIn,
            color: context.primary,
          ),
          const SizedBox(height: 8),
          _ZoomFab(
            icon: LucideIcons.maximize2,
            tooltip: 'Đặt lại',
            onPressed: _resetZoom,
            color: context.accent,
          ),
          const SizedBox(height: 8),
          _ZoomFab(
            icon: LucideIcons.minus,
            tooltip: 'Thu nhỏ',
            onPressed: _zoomOut,
            color: context.primary,
          ),
        ],
      ),
      body: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
        builder: (context, state) {
          if (state is FamilyTreeLoading) {
            return const Center(child: AppLoading(size: 80));
          }

          if (state is FamilyTreeError) {
            return Center(
              child: Text(
                state.message,
                style: GoogleFonts.inter(color: context.primary),
              ),
            );
          }

          if (state is FamilyTreeLoaded) {
            if (state.members.isEmpty) {
              return Center(
                child: Text(
                  l10n.noTreeDataMessage,
                  style: GoogleFonts.inter(
                    color: context.textSecondary,
                    fontSize: 16,
                  ),
                ),
              );
            }

            final coupleEdges = <_CoupleEdge>[];
            final orphanEdges = <_EdgeData>[];
            final spouseEdges = <_SpouseEdge>[];
            final positions = _calculateLayout(
              state.members,
              coupleEdges,
              orphanEdges,
              spouseEdges,
            );

            double maxX = _padding * 2, maxY = _padding * 2;
            for (final entry in positions.entries) {
              final right = entry.value.dx + _nodeWidth / 2;
              final bottom = entry.value.dy + _nodeHeight / 2;
              maxX = maxX > right ? maxX : right;
              maxY = maxY > bottom ? maxY : bottom;
            }
            final treeSize = Size(maxX, maxY);

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
                  return const SizedBox.shrink();
                }
                return InteractiveViewer(
                  transformationController: _transformationController,
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  minScale: 0.3,
                  maxScale: 3.0,
                  child: SizedBox(
                    width: treeSize.width,
                    height: treeSize.height,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: treeSize,
                          painter: _TreeEdgePainter(
                            coupleEdges: coupleEdges,
                            orphanEdges: orphanEdges,
                            spouseEdges: spouseEdges,
                            positions: positions,
                            linePaint: Paint()
                              ..color = context.connectionLine
                              ..strokeWidth = 2.0
                              ..strokeCap = StrokeCap.round
                              ..style = PaintingStyle.stroke,
                            spousePaint: Paint()
                              ..color = context.connectionLine
                              ..strokeWidth = 1.5
                              ..strokeCap = StrokeCap.round
                              ..style = PaintingStyle.stroke,
                          ),
                        ),
                        ...state.members.map((member) {
                          final pos = positions[member.id];
                          if (pos == null) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            left: pos.dx - _nodeWidth / 2,
                            top: pos.dy - _nodeHeight / 2,
                            child: FamilyMemberNodeWidget(
                              member: member,
                              isSelected: state.selectedMemberId == member.id,
                              onTap: () {
                                context.read<FamilyTreeBloc>().add(
                                    FamilyTreeSelectMemberEvent(member.id));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FamilyMemberDetailPage(member: member),
                                  ),
                                );
                              },
                              onAddChildTap: canEdit
                                  ? () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AdminMemberFormPage(
                                            initialParentId: member.id,
                                            initialGeneration:
                                                (member.generation ?? 0) + 1,
                                            isLockedContext: true,
                                          ),
                                        ),
                                      );
                                      if (result == true && context.mounted) {
                                        final authState =
                                            context.read<AuthBloc>().state;
                                        final familyId =
                                            authState is Authenticated
                                                ? authState.user.familyId
                                                : null;
                                        context.read<FamilyTreeBloc>().add(
                                            FamilyTreeLoadEvent(
                                                familyId: familyId));
                                      }
                                    }
                                  : null,
                              onAddSpouseTap: canEdit
                                  ? () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AdminMemberFormPage(
                                            initialSpouseId: member.id,
                                            initialGeneration:
                                                member.generation,
                                            isLockedContext: true,
                                          ),
                                        ),
                                      );
                                      if (result == true && context.mounted) {
                                        final authState =
                                            context.read<AuthBloc>().state;
                                        final familyId =
                                            authState is Authenticated
                                                ? authState.user.familyId
                                                : null;
                                        context.read<FamilyTreeBloc>().add(
                                            FamilyTreeLoadEvent(
                                                familyId: familyId));
                                      }
                                    }
                                  : null,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showHelp(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.background,
        title: Text(
          l10n.usageGuideTitle,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            color: context.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(l10n.helpDragInstruction),
            _buildHelpItem(l10n.helpZoomInstruction),
            _buildHelpItem(l10n.helpTapInstruction),
            Divider(color: context.accent, height: 20),
            _buildLegendItem(l10n.genderMale, context.nodeMale),
            _buildLegendItem(l10n.genderFemale, context.nodeFemale),
            _buildLegendItem(l10n.deceasedLabel, context.nodeDeceased),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.understoodLabel,
              style: GoogleFonts.inter(
                color: context.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: context.accent, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: context.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _TreeEdgePainter extends CustomPainter {
  final List<_CoupleEdge> coupleEdges;
  final List<_EdgeData> orphanEdges;
  final List<_SpouseEdge> spouseEdges;
  final Map<int, Offset> positions;
  final Paint linePaint;
  final Paint spousePaint;

  _TreeEdgePainter({
    required this.coupleEdges,
    required this.orphanEdges,
    required this.spouseEdges,
    required this.positions,
    required this.linePaint,
    required this.spousePaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Couple edges — T-bar junction style ──────────────────────────────
    for (final ce in coupleEdges) {
      final primary = positions[ce.primaryId];
      if (primary == null) continue;
      // Điểm xuất phát X = từ chính thành viên gốc, nhưng nếu là nhánh của cụ thể 1 người mẹ (đa thê) thì xuất phát từ người mẹ.
      double sourceX = primary.dx;
      if (ce.spouseId != null) {
        final spouse = positions[ce.spouseId!];
        if (spouse != null) {
          sourceX = spouse.dx;
        }
      }
      final sourceY = primary.dy + _nodeHeight / 2;

      final childPositions =
          ce.childIds.map((id) => positions[id]).whereType<Offset>().toList();
      if (childPositions.isEmpty) continue;

      final childTopY = childPositions.first.dy - _nodeHeight / 2;
      final junctionY = (sourceY + childTopY) / 2;

      final path = Path();
      const radius = 16.0;

      for (final childPos in childPositions) {
        final start = Offset(sourceX, sourceY);
        final end = Offset(childPos.dx, childTopY);

        if ((start.dx - end.dx).abs() < 1.0) {
          path.moveTo(start.dx, start.dy);
          path.lineTo(end.dx, end.dy);
        } else {
          final direction = (end.dx > start.dx) ? 1.0 : -1.0;
          final maxRX = (start.dx - end.dx).abs() / 2;
          final maxRY = (junctionY - start.dy < end.dy - junctionY)
              ? (junctionY - start.dy)
              : (end.dy - junctionY);
          final r = radius < maxRX
              ? (radius < maxRY ? radius : maxRY)
              : (maxRX < maxRY ? maxRX : maxRY);

          path.moveTo(start.dx, start.dy);
          path.lineTo(start.dx, junctionY - r);
          path.quadraticBezierTo(
              start.dx, junctionY, start.dx + direction * r, junctionY);
          path.lineTo(end.dx - direction * r, junctionY);
          path.quadraticBezierTo(end.dx, junctionY, end.dx, junctionY + r);
          path.lineTo(end.dx, end.dy);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // ── Orphan edges — bezier (fallback cho nodes ngoài layout chính) ────
    for (final edge in orphanEdges) {
      final parent = positions[edge.parentId];
      final child = positions[edge.childId];
      if (parent == null || child == null) continue;

      final start = Offset(parent.dx, parent.dy + _nodeHeight / 2);
      final end = Offset(child.dx, child.dy - _nodeHeight / 2);
      final midY = (start.dy + end.dy) / 2;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(start.dx, midY, end.dx, midY, end.dx, end.dy);
      canvas.drawPath(path, linePaint);
    }

    // ── Spouse edges — đường ngang + chấm tròn giữa ─────────────────────
    for (final se in spouseEdges) {
      final left = positions[se.leftMemberId];
      final right = positions[se.rightMemberId];
      if (left == null || right == null) continue;

      final start = Offset(left.dx + _nodeWidth / 2, left.dy);
      final end = Offset(right.dx - _nodeWidth / 2, right.dy);

      // Vẽ đường gạch nối ngang
      canvas.drawLine(start, end, spousePaint);

      final midX = (start.dx + end.dx) / 2;

      // Chọn icon dựa vào trạng thái hôn nhân
      final icon =
          se.isDivorced ? LucideIcons.heartCrack : LucideIcons.heartHandshake;
      final iconColor = se.isDivorced ? Colors.grey : Colors.redAccent;

      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            color: iconColor,
            fontSize: 16,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            backgroundColor: const Color(
                0xFFF9F6F0), // Nền để che đường kẻ (giống màu nền app)
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(midX - textPainter.width / 2, start.dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TreeEdgePainter oldDelegate) {
    return oldDelegate.coupleEdges != coupleEdges ||
        oldDelegate.orphanEdges != orphanEdges ||
        oldDelegate.spouseEdges != spouseEdges ||
        oldDelegate.positions != positions;
  }
}

/// Nút zoom nhỏ gọn — hiển thị ở góc phải dưới màn hình
class _ZoomFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;

  const _ZoomFab({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.resolve(
                Colors.white.withValues(alpha: 0.92),
                const Color(0xFF2A2A2A).withValues(alpha: 0.92),
              ),
              shape: BoxShape.circle,
              border:
                  Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

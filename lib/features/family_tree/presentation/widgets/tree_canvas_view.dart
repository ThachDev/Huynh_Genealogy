import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/services/kinship_calculator_service.dart';
import 'family_member_node_widget.dart';
import 'tree_edge_painter.dart';

/// Canvas tương tác InteractiveViewer vẽ các liên kết và node thành viên trên Cây Gia Phả
class TreeCanvasView extends StatelessWidget {
  const TreeCanvasView({
    super.key,
    required this.transformationController,
    required this.treeSize,
    required this.nodeHeight,
    required this.members,
    required this.positions,
    required this.coupleEdges,
    required this.orphanEdges,
    required this.spouseEdges,
    required this.generationLevels,
    required this.selectedMemberId,
    required this.userMemberId,
    required this.canEdit,
    required this.onSelectMember,
    required this.onAddChild,
    required this.onAddSpouse,
  });

  final TransformationController transformationController;
  final Size treeSize;
  final double nodeHeight;
  final List<MemberEntity> members;
  final Map<int, Offset> positions;
  final List<TreeCoupleEdge> coupleEdges;
  final List<TreeEdgeData> orphanEdges;
  final List<TreeSpouseEdge> spouseEdges;
  final Map<int, double> generationLevels;
  final int? selectedMemberId;
  final int? userMemberId;
  final bool canEdit;
  final ValueChanged<MemberEntity> onSelectMember;
  final ValueChanged<MemberEntity> onAddChild;
  final ValueChanged<MemberEntity> onAddSpouse;

  @override
  Widget build(BuildContext context) {
    final myMember = userMemberId != null
        ? members.where((m) => m.id == userMemberId).firstOrNull
        : null;

    final kinshipService = KinshipCalculatorService();

    return InteractiveViewer(
      transformationController: transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1, // Cho phép zoom out xa để xem toàn cảnh cây
      maxScale: 3.0,
      child: SizedBox(
        width: treeSize.width,
        height: treeSize.height,
        child: RepaintBoundary(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Tầng vẽ đường nối các thế hệ và hôn nhân
              RepaintBoundary(
                child: CustomPaint(
                  size: treeSize,
                  painter: TreeEdgePainter(
                    coupleEdges: coupleEdges,
                    orphanEdges: orphanEdges,
                    spouseEdges: spouseEdges,
                    positions: positions,
                    generationLevels: generationLevels,
                    nodeHeight: nodeHeight,
                    primaryColor: context.primary,
                    accentColor: context.accent,
                    surfaceColor: context.surface,
                    textColor: context.textPrimary,
                    linePaint: Paint()
                      ..color = context.resolve(
                          context.accent, Colors.grey.shade700)
                      ..strokeWidth = 3.0
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                    spousePaint: Paint()
                      ..color = context.resolve(
                          context.primary.withValues(alpha: 0.6),
                          Colors.grey.shade700.withValues(alpha: 0.6))
                      ..strokeWidth = 2.0
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                  ),
                ),
              ),

              // 2. Tầng render các Node thành viên
              ...members.map((member) {
                final pos = positions[member.id];
                if (pos == null) {
                  return const SizedBox.shrink();
                }

                String? kinshipTitle;
                if (userMemberId == member.id) {
                  kinshipTitle = 'Tôi';
                } else if (myMember != null) {
                  final res = kinshipService.calculate(
                    fromMember: myMember,
                    toMember: member,
                    allMembers: members,
                  );
                  if (res.fromCallsTo.isNotEmpty &&
                      res.fromCallsTo != 'Đồng tộc / Chưa rõ liên kết') {
                    kinshipTitle = res.fromCallsTo;
                  }
                }

                return Positioned(
                  left: pos.dx - TreeLayoutMetrics.nodeWidth / 2,
                  top: pos.dy - nodeHeight / 2,
                  child: FamilyMemberNodeWidget(
                    member: member,
                    kinshipTitle: kinshipTitle,
                    isSelected: selectedMemberId == member.id,
                    isCurrentUser: userMemberId == member.id,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onSelectMember(member);
                    },
                    onAddChildTap: canEdit ? () => onAddChild(member) : null,
                    onAddSpouseTap: canEdit ? () => onAddSpouse(member) : null,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

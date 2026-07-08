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

const double _nodeWidth = 140.0;
const double _nodeHeight = 140.0;
const double _hSpacing = 40.0;
const double _vSpacing = 120.0;
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
  _SpouseEdge({required this.leftMemberId, required this.rightMemberId});
}

class FamilyTreeViewPage extends StatefulWidget {
  const FamilyTreeViewPage({super.key});

  @override
  State<FamilyTreeViewPage> createState() => _FamilyTreeViewPageState();
}

class _FamilyTreeViewPageState extends State<FamilyTreeViewPage> {
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

  Map<int, Offset> _calculateLayout(
    List<MemberEntity> members,
    List<_EdgeData> edges,
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

    (Map<int, Offset>, double) layoutSubtree(int nodeId, int gen) {
      final y = (gen - minGen) * _vSpacing;
      final member = memberMap[nodeId]!;

      int? spouseId;
      if (member.spouseId != null &&
          memberMap.containsKey(member.spouseId)) {
        spouseId = member.spouseId;
      }

      // Children linked to primary parent
      final primaryChildren = childrenOf[nodeId] ?? <MemberEntity>[];
      // Children linked to spouse
      final spouseChildren = spouseId != null
          ? (childrenOf[spouseId] ?? <MemberEntity>[])
          : <MemberEntity>[];

      // Layout each side's subtrees
      final primaryResults =
          primaryChildren.map((c) => layoutSubtree(c.id, gen + 1)).toList();
      final spouseResults =
          spouseChildren.map((c) => layoutSubtree(c.id, gen + 1)).toList();

      double primaryWidth = 0;
      for (final r in primaryResults) {
        primaryWidth += r.$2;
      }
      if (primaryResults.length > 1) {
        primaryWidth += _hSpacing * (primaryResults.length - 1);
      }

      double spouseWidth = 0;
      for (final r in spouseResults) {
        spouseWidth += r.$2;
      }
      if (spouseResults.length > 1) {
        spouseWidth += _hSpacing * (spouseResults.length - 1);
      }

      // Spouse center x relative to primary parent center (0)
      final spouseCenterX =
          spouseId != null ? _nodeWidth + _spouseGap : 0.0;

      // Find min/max extent of all elements
      double minX = -_nodeWidth / 2;
      double maxX = _nodeWidth / 2;
      if (spouseId != null) {
        maxX = spouseCenterX + _nodeWidth / 2;
      }

      if (primaryWidth > 0) {
        minX = minX < -primaryWidth / 2 ? minX : -primaryWidth / 2;
        maxX = maxX > primaryWidth / 2 ? maxX : primaryWidth / 2;
      }
      if (spouseWidth > 0) {
        minX =
            minX < spouseCenterX - spouseWidth / 2
                ? minX
                : spouseCenterX - spouseWidth / 2;
        maxX =
            maxX > spouseCenterX + spouseWidth / 2
                ? maxX
                : spouseCenterX + spouseWidth / 2;
      }

      final totalWidth = maxX - minX;
      // Shift so that minX maps to 0
      final shift = -minX;

      final allPos = <int, Offset>{};
      allPos[nodeId] = Offset(shift, y);
      if (spouseId != null) {
        allPos[spouseId] = Offset(shift + spouseCenterX, y);
        spouseEdges
            .add(_SpouseEdge(leftMemberId: nodeId, rightMemberId: spouseId));
      }

      // Position primary children centered under primary parent (shift, y)
      double cx = -primaryWidth / 2;
      for (int i = 0; i < primaryChildren.length; i++) {
        final child = primaryChildren[i];
        final cPos = primaryResults[i].$1;
        final cWidth = primaryResults[i].$2;
        for (final entry in cPos.entries) {
          allPos[entry.key] = Offset(
            entry.value.dx + shift + cx + cWidth / 2,
            entry.value.dy,
          );
        }
        edges.add(_EdgeData(parentId: nodeId, childId: child.id));
        cx += cWidth + _hSpacing;
      }

      // Position spouse children centered under spouse
      cx = -spouseWidth / 2;
      for (int i = 0; i < spouseChildren.length; i++) {
        final child = spouseChildren[i];
        final cPos = spouseResults[i].$1;
        final cWidth = spouseResults[i].$2;
        for (final entry in cPos.entries) {
          allPos[entry.key] = Offset(
            entry.value.dx + shift + spouseCenterX + cx + cWidth / 2,
            entry.value.dy,
          );
        }
        edges.add(_EdgeData(parentId: spouseId!, childId: child.id));
        cx += cWidth + _hSpacing;
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
          edges.add(_EdgeData(parentId: m.parentId!, childId: m.id));
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

            final edges = <_EdgeData>[];
            final spouseEdges = <_SpouseEdge>[];
            final positions =
                _calculateLayout(state.members, edges, spouseEdges);

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
                if (constraints.maxWidth == 0 ||
                    constraints.maxHeight == 0) {
                  return const SizedBox.shrink();
                }
                return InteractiveViewer(
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
                            edges: edges,
                            spouseEdges: spouseEdges,
                            positions: positions,
                            linePaint: Paint()
                              ..color = context.connectionLine
                              ..strokeWidth = 2.0
                              ..strokeCap = StrokeCap.round,
                            spousePaint: Paint()
                              ..color = context.connectionLine
                              ..strokeWidth = 1.5
                              ..strokeCap = StrokeCap.round,
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
                              isSelected:
                                  state.selectedMemberId == member.id,
                              onTap: () {
                                context
                                    .read<FamilyTreeBloc>()
                                    .add(FamilyTreeSelectMemberEvent(
                                        member.id));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FamilyMemberDetailPage(
                                        member: member),
                                  ),
                                );
                              },
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
  final List<_EdgeData> edges;
  final List<_SpouseEdge> spouseEdges;
  final Map<int, Offset> positions;
  final Paint linePaint;
  final Paint spousePaint;

  _TreeEdgePainter({
    required this.edges,
    required this.spouseEdges,
    required this.positions,
    required this.linePaint,
    required this.spousePaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final parent = positions[edge.parentId];
      final child = positions[edge.childId];
      if (parent == null || child == null) continue;

      final start = Offset(parent.dx, parent.dy + _nodeHeight / 2);
      final end = Offset(child.dx, child.dy - _nodeHeight / 2);
      final midY = (start.dy + end.dy) / 2;

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          start.dx, midY,
          end.dx, midY,
          end.dx, end.dy,
        );
      canvas.drawPath(path, linePaint);
    }

    for (final se in spouseEdges) {
      final left = positions[se.leftMemberId];
      final right = positions[se.rightMemberId];
      if (left == null || right == null) continue;

      final start = Offset(left.dx + _nodeWidth / 2, left.dy);
      final end = Offset(right.dx - _nodeWidth / 2, right.dy);
      canvas.drawLine(start, end, spousePaint);

      final midX = (start.dx + end.dx) / 2;
      final smallPaint = Paint()
        ..color = spousePaint.color
        ..strokeWidth = 3.0
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(midX, start.dy), 3.0, smallPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreeEdgePainter oldDelegate) {
    return oldDelegate.edges != edges ||
        oldDelegate.spouseEdges != spouseEdges ||
        oldDelegate.positions != positions;
  }
}

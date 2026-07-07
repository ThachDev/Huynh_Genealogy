import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../bloc/family_tree_bloc.dart';
import '../widgets/family_member_node_widget.dart';
import 'family_member_detail_page.dart';

class FamilyTreeViewPage extends StatefulWidget {
  const FamilyTreeViewPage({super.key});

  @override
  State<FamilyTreeViewPage> createState() => _FamilyTreeViewPageState();
}

class _FamilyTreeViewPageState extends State<FamilyTreeViewPage> {
  final BuchheimWalkerConfiguration _algorithm =
      BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();
    _algorithm
      ..siblingSeparation = 60
      ..levelSeparation = 100
      ..subtreeSeparation = 60
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  Graph _buildGraph(List<MemberEntity> members) {
    final graph = Graph()..isTree = true;
    final nodeMap = <int, Node>{};

    // Create node for each member
    for (final member in members) {
      final node = Node.Id(member.id);
      nodeMap[member.id] = node;
    }

    // Add edges (parent → child)
    for (final member in members) {
      if (member.parentId != null && nodeMap.containsKey(member.parentId)) {
        graph.addEdge(
          nodeMap[member.parentId]!,
          nodeMap[member.id]!,
          paint: Paint()
            ..color = context.connectionLine
            ..strokeWidth = 2.0,
        );
      } else if (member.parentId == null) {
        // Root node
        if (nodeMap[member.id] != null) {
          graph.addNode(nodeMap[member.id]!);
        }
      }
    }

    return graph;
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
      body: Stack(
        children: [
          BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
            builder: (context, state) {
              if (state is FamilyTreeLoading) {
                return const Center(
                    child: AppLoading(size: 80));
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

                final graph = _buildGraph(state.members);
                final memberMap = {for (final m in state.members) m.id: m};

                return InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(500),
                  minScale: 0.1,
                  maxScale: 2.5,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(
                      _algorithm,
                      TreeEdgeRenderer(_algorithm),
                    ),
                    paint: Paint()
                      ..color = context.connectionLine
                      ..strokeWidth = 2.0
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      final memberId = node.key?.value as int?;
                      final member = memberId != null ? memberMap[memberId] : null;

                      if (member == null) {
                        return const SizedBox(width: 80, height: 40);
                      }

                      return FamilyMemberNodeWidget(
                        member: member,
                        isSelected: state.selectedMemberId == member.id,
                        onTap: () {
                          context
                              .read<FamilyTreeBloc>()
                              .add(FamilyTreeSelectMemberEvent(member.id));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FamilyMemberDetailPage(member: member),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
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

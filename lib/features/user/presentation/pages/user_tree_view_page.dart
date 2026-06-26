import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../bloc/user_tree_bloc.dart';
import '../widgets/user_member_node_widget.dart';
import 'user_member_detail_page.dart';

class UserTreeViewPage extends StatefulWidget {
  const UserTreeViewPage({super.key});

  @override
  State<UserTreeViewPage> createState() => _UserTreeViewPageState();
}

class _UserTreeViewPageState extends State<UserTreeViewPage> {
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
            ..color = AppColors.connectionLine
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
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(
          'Bản Đồ Phả Hệ',
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.helpCircle),
            tooltip: 'Hướng dẫn',
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<UserTreeBloc, UserTreeState>(
            builder: (context, state) {
              if (state is UserTreeLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.crimson));
              }

              if (state is UserTreeError) {
                return Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.inter(color: AppColors.crimson),
                  ),
                );
              }

              if (state is UserTreeLoaded) {
                if (state.members.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có dữ liệu gia phả',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
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
                      ..color = AppColors.connectionLine
                      ..strokeWidth = 2.0
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      final memberId = node.key?.value as int?;
                      final member = memberId != null ? memberMap[memberId] : null;

                      if (member == null) {
                        return const SizedBox(width: 80, height: 40);
                      }

                      return UserMemberNodeWidget(
                        member: member,
                        isSelected: state.selectedMemberId == member.id,
                        onTap: () {
                          context
                              .read<UserTreeBloc>()
                              .add(UserTreeSelectMemberEvent(member.id));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserMemberDetailPage(member: member),
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          'Hướng dẫn sử dụng',
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem('👉 Kéo sơ đồ để di chuyển'),
            _buildHelpItem('🔍 Phóng to/Thu nhỏ bằng 2 ngón tay'),
            _buildHelpItem('👤 Nhấn vào thành viên để xem chi tiết'),
            const Divider(color: AppColors.gold, height: 20),
            _buildLegendItem('Nam giới', AppColors.nodeMale),
            _buildLegendItem('Nữ giới', AppColors.nodeFemale),
            _buildLegendItem('Đã mất', AppColors.nodeDeceased),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đã rõ',
              style: GoogleFonts.inter(
                color: AppColors.crimson,
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
        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
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
              border: Border.all(color: AppColors.gold, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/member_node_widget.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/pages/member_detail_page.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  final BuchheimWalkerConfiguration _algorithm = BuchheimWalkerConfiguration();
  final TransformationController _transformationController =
      TransformationController();
  Graph? _graph;
  List<MemberEntity>? _memoizedMembers;

  @override
  void initState() {
    super.initState();
    final state = context.read<TreeBloc>().state;
    if (state is TreeInitial) {
      context.read<TreeBloc>().add(LoadTreeEvent());
    }
    _algorithm
      ..siblingSeparation = 60
      ..levelSeparation = 100
      ..subtreeSeparation = 60
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetView() {
    _transformationController.value = Matrix4.identity();
  }

  void _ensureGraph(List<MemberEntity> members) {
    if (_memoizedMembers == members && _graph != null) return;

    _memoizedMembers = members;
    final graph = Graph()..isTree = true;
    final nodeMap = <int, Node>{};

    for (final member in members) {
      final node = Node.Id(member.id);
      nodeMap[member.id] = node;
    }

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
        if (nodeMap[member.id] != null) {
          graph.addNode(nodeMap[member.id]!);
        }
      }
    }
    _graph = graph;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 10,
        centerTitle: true,
        title: Text(
          'GIA PHẢ HỌ HUỲNH',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wood_dragon.png'),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          heroTag: 'tree_reset_fab',
          onPressed: _resetView,
          backgroundColor: AppColors.crimson,
          mini: true,
          child: const Icon(
            Icons.center_focus_strong_rounded,
            color: AppColors.gold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/clouds.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          BlocBuilder<TreeBloc, TreeState>(
            builder: (context, state) {
              if (state is TreeLoading || state is TreeInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.crimson),
                );
              }

              if (state is TreeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.crimson,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: GoogleFonts.inter(color: AppColors.crimson),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<TreeBloc>().add(LoadTreeEvent()),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              if (state is TreeLoaded) {
                if (state.allMembers.isEmpty) {
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

                _ensureGraph(state.allMembers);
                final memberMap = {for (final m in state.allMembers) m.id: m};

                return InteractiveViewer(
                  transformationController: _transformationController,
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(1000),
                  minScale: 0.1,
                  maxScale: 2.5,
                  child: GraphView(
                    graph: _graph!,
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
                      final member = memberId != null
                          ? memberMap[memberId]
                          : null;

                      if (member == null) {
                        return const SizedBox(width: 80, height: 40);
                      }

                      return MemberNodeWidget(
                        member: member,
                        isSelected: state.selectedMemberId == member.id,
                        onTap: () {
                          context.read<TreeBloc>().add(
                            SelectMemberEvent(member.id),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MemberDetailPage(member: member),
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
}

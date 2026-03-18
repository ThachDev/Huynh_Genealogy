import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/member_node_widget.dart';
import 'package:app_family_tree/components/search/member_search_overlay.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resources/resources.dart';
import 'package:go_router/go_router.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> with TickerProviderStateMixin {
  final GlobalKey _graphKey = GlobalKey();
  Graph? _graph;
  final BuchheimWalkerConfiguration _builder = BuchheimWalkerConfiguration();
  final TransformationController _transformationController = TransformationController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  final Map<int, GlobalKey> _nodeKeys = {};

  AnimationController? _animationController;
  Animation<Matrix4>? _animation;
  AnimationController? _bgAnimationController;
  late Animation<double> _bgAnimation;

  List<MemberEntity>? _memoizedMembers;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..addListener(() => _transformationController.value = _animation!.value);
    _bgAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _bgAnimationController!, curve: Curves.easeInOut));
    
    _builder
      ..siblingSeparation = 40
      ..levelSeparation = 80
      ..subtreeSeparation = 60
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _bgAnimationController?.dispose();
    _transformationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetView() {
    final viewportSize = MediaQuery.of(context).size;
    final scale = 0.6;
    final x = (viewportSize.width / 2) - (600 * scale);
    final y = 60.0;
    final targetMatrix = Matrix4.identity()..setEntry(0, 0, scale)..setEntry(1, 1, scale)..setEntry(0, 3, x)..setEntry(1, 3, y);
    _animation = Matrix4Tween(begin: _transformationController.value, end: targetMatrix).animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastOutSlowIn));
    _animationController?.forward(from: 0);
  }

  void _centerNode(int memberId) {
    final key = _nodeKeys[memberId];
    if (key == null) return;
    final RenderBox? nodeBox = key.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? graphBox = _graphKey.currentContext?.findRenderObject() as RenderBox?;
    if (nodeBox == null || graphBox == null) return;
    final viewportSize = MediaQuery.of(context).size;
    final nodeOffset = nodeBox.localToGlobal(Offset.zero, ancestor: graphBox);
    final nodeSize = nodeBox.size;
    final targetScale = 1.0;
    final x = (viewportSize.width / 2) - (nodeOffset.dx + nodeSize.width / 2) * targetScale;
    final y = (viewportSize.height / 2) - (nodeOffset.dy + nodeSize.height / 2) * targetScale;
    final targetMatrix = Matrix4.identity()..setEntry(0, 0, targetScale)..setEntry(1, 1, targetScale)..setEntry(0, 3, x)..setEntry(1, 3, y);
    _animation = Matrix4Tween(begin: _transformationController.value, end: targetMatrix).animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastOutSlowIn));
    _animationController?.forward(from: 0);
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
        graph.addEdge(nodeMap[member.parentId]!, nodeMap[member.id]!, paint: Paint()..color = AppColors.connectionLine..strokeWidth = 2.0);
      } else if (member.parentId == null) {
        if (nodeMap[member.id] != null) graph.addNode(nodeMap[member.id]!);
      }
    }
    _graph = graph;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(
        titleText: l10n.familyTreeDiagram,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: l10n.searchHint,
        onSearchChanged: (val) => setState(() => _searchQuery = val),
        onSearchToggle: () => setState(() => _isSearching = true),
        onSearchClear: () {
          _searchController.clear();
          setState(() {
            _searchQuery = '';
            _isSearching = false;
          });
        },
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: AppColors.gold), onPressed: () => _showLegendDialog(context)),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          heroTag: 'tree_reset_fab',
          tooltip: l10n.familyTreeDiagram,
          onPressed: _resetView,
          backgroundColor: AppColors.crimson,
          mini: true,
          child: const Icon(Icons.center_focus_strong_rounded, color: AppColors.gold),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimation,
              builder: (context, _) => CustomPaint(painter: TreeBackgroundPainter(animationValue: _bgAnimation.value)),
            ),
          ),
          BlocBuilder<TreeBloc, TreeState>(
            builder: (context, state) {
              if (state is TreeLoading || state is TreeInitial) return const Center(child: CircularProgressIndicator(color: AppColors.crimson));
              if (state is TreeError) return _buildErrorView(l10n, state.message);
              if (state is TreeLoaded) {
                if (state.allMembers.isEmpty) return Center(child: Text(l10n.familyTreeDiagram, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16)));
                _ensureGraph(state.allMembers);
                final memberMap = {for (final m in state.allMembers) m.id: m};
                return Stack(
                  children: [
                    InteractiveViewer(
                      transformationController: _transformationController,
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(1000),
                      minScale: 0.1,
                      maxScale: 2.5,
                      child: GraphView(
                        key: _graphKey,
                        graph: _graph!,
                        algorithm: BuchheimWalkerAlgorithm(_builder, TreeEdgeRenderer(_builder)),
                        paint: Paint()..color = AppColors.connectionLine..strokeWidth = 2.0..style = PaintingStyle.stroke,
                        builder: (Node node) {
                          final memberId = node.key?.value as int?;
                          final member = memberId != null ? memberMap[memberId] : null;
                          if (member == null) return const SizedBox(width: 80, height: 40);
                          final isHighlighted = _searchQuery.isNotEmpty && member.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
                          return MemberNodeWidget(key: _nodeKeys.putIfAbsent(member.id, () => GlobalKey()), member: member, isSelected: state.selectedMemberId == member.id, isHighlighted: isHighlighted, onTap: () {
                            context.read<TreeBloc>().add(SelectMemberEvent(member.id));
                            context.push('/members/${member.id}', extra: member);
                          });
                        },
                      ),
                    ),
                    MemberSearchOverlay(
                      searchQuery: _searchQuery,
                      allMembers: state.allMembers,
                      onMemberTap: (m) {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _isSearching = false;
                        });
                        _centerNode(m.id);
                      },
                      onClose: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _isSearching = false;
                        });
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(S l10n, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: AppColors.crimson),
            const SizedBox(height: 24),
            Text(message, textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14)),
            const SizedBox(height: 24),
            SizedBox(width: 160, height: 48, child: ElevatedButton(onPressed: () => context.read<TreeBloc>().add(LoadTreeEvent()), child: Text(l10n.retry))),
          ],
        ),
      ),
    );
  }

  void _showLegendDialog(BuildContext context) {
    final l10n = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.parchment,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.legend, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.crimson)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLegendItem(color: AppColors.nodeMale, label: l10n.male, isCircle: false), const SizedBox(height: 12), _buildLegendItem(color: AppColors.nodeFemale, label: l10n.female, isCircle: false)]),
            const SizedBox(width: 20),
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLegendItem(color: const Color(0xFF2ECC71), label: l10n.stillAlive, isCircle: true), const SizedBox(height: 12), _buildLegendItem(color: AppColors.nodeDeceased, label: l10n.deceased, isCircle: true)]),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.understand, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.crimson)))],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label, bool isCircle = false}) {
    return Row(children: [Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: isCircle ? BoxShape.circle : BoxShape.rectangle, borderRadius: isCircle ? null : BorderRadius.circular(4))), const SizedBox(width: 8), Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary))]);
  }
}

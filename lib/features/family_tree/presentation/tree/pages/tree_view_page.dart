import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/member_node_widget.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';
import 'package:app_family_tree/shell/main_shell_page.dart';
import 'package:go_router/go_router.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:resources/resources.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Matrix4>? _animation;
  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;
  final GlobalKey _graphKey = GlobalKey();
  final BuchheimWalkerConfiguration _algorithm = BuchheimWalkerConfiguration();
  late final BuchheimWalkerAlgorithm _buchheimWalkerAlgorithm;
  final TransformationController _transformationController =
      TransformationController();
  Graph? _graph;
  List<MemberEntity>? _memoizedMembers;
  bool _wasActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  final Map<int, GlobalKey> _nodeKeys = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isActive = ShellIndexProvider.of(context) == 1;
    if (isActive && !_wasActive) {
      if (context.read<TreeBloc>().state is TreeLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () => _resetView(),
            );
          }
        });
      }
    }
    _wasActive = isActive;
  }

  @override
  void initState() {
    super.initState();
    // Background subtle breathing animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );

    // Zoom/reset animation controller
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 600),
        )..addListener(() {
          if (_animation != null) {
            _transformationController.value = _animation!.value;
          }
        });

    final state = context.read<TreeBloc>().state;
    // Nếu chưa load hoặc đang lỗi thì mới load lại
    if (state is TreeInitial || state is TreeError) {
      context.read<TreeBloc>().add(LoadTreeEvent());
    }
    // BỎ đoạn gọi _resetView tự động ở đây để giữ vị trí cũ khi quay lại từ MemberDetail
    _algorithm
      ..siblingSeparation =
          70 // Tăng khoảng cách ngang một chút cho thoáng
      ..levelSeparation = 100
      ..subtreeSeparation = 70
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    _buchheimWalkerAlgorithm = BuchheimWalkerAlgorithm(
      _algorithm,
      TreeEdgeRenderer(_algorithm),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _animationController?.dispose();
    _transformationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetView() {
    if (!mounted) return;
    if (ShellIndexProvider.of(context) != 1) return;
    if (_animationController == null) return;

    final RenderBox? renderBox =
        _graphKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null ||
        renderBox.size.width <= 0 ||
        renderBox.size.height <= 0) {
      _transformationController.value = Matrix4.identity();
      return;
    }

    // Get graph and viewport sizes
    final graphSize = renderBox.size;
    final viewportSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final safeTop = MediaQuery.of(context).padding.top;

    // Available height for the tree
    final availableHeight = viewportSize.height - appBarHeight - safeTop - 100;

    // Calculate scale to fit width (with 40px padding)
    double scale = (viewportSize.width / (graphSize.width + 40)).clamp(
      0.4,
      1.0,
    );

    // Check if height also needs to be constrained
    if (graphSize.height * scale > availableHeight) {
      scale = (availableHeight / graphSize.height).clamp(0.4, 1.0);
    }

    // Calculate x to center horizontally
    final x = (viewportSize.width - graphSize.width * scale) / 2;
    // Set y to place tree slightly below the top
    final y = 60.0;

    final targetMatrix = Matrix4.identity()
      ..setEntry(0, 0, scale)
      ..setEntry(1, 1, scale)
      ..setEntry(0, 3, x)
      ..setEntry(1, 3, y);

    // Create animation from current state to target
    _animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: targetMatrix,
        ).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Curves.fastOutSlowIn,
          ),
        );

    _animationController?.forward(from: 0);
  }

  void _centerNode(int memberId) {
    final key = _nodeKeys[memberId];
    if (key == null) return;

    final RenderBox? nodeBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? graphBox =
        _graphKey.currentContext?.findRenderObject() as RenderBox?;

    if (nodeBox == null || graphBox == null) return;

    final viewportSize = MediaQuery.of(context).size;

    // Position of node in graph coordinates
    final nodeOffset = nodeBox.localToGlobal(Offset.zero, ancestor: graphBox);
    final nodeSize = nodeBox.size;

    final targetScale = 1.0;

    // Calculate x/y to center the node in viewport
    final x =
        (viewportSize.width / 2) -
        (nodeOffset.dx + nodeSize.width / 2) * targetScale;
    final y =
        (viewportSize.height / 2) -
        (nodeOffset.dy + nodeSize.height / 2) * targetScale;

    final targetMatrix = Matrix4.identity()
      ..setEntry(0, 0, targetScale)
      ..setEntry(1, 1, targetScale)
      ..setEntry(0, 3, x)
      ..setEntry(1, 3, y);

    _animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: targetMatrix,
        ).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Curves.fastOutSlowIn,
          ),
        );

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
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(
        elevation: 10,
        centerTitle: false,
        title: _buildAppBarTitle(l10n),
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.gold),
              onPressed: () => setState(() => _isSearching = true),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: AppColors.gold),
              onPressed: () => _showLegendDialog(context),
            ),
          ],
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
          child: const Icon(
            Icons.center_focus_strong_rounded,
            color: AppColors.gold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // ── Animated background ──────────────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimation,
              builder: (context, _) => CustomPaint(
                painter: TreeBackgroundPainter(
                  animationValue: _bgAnimation.value,
                ),
              ),
            ),
          ),
          BlocListener<TreeBloc, TreeState>(
            listenWhen: (prev, curr) =>
                prev is! TreeLoaded && curr is TreeLoaded,
            listener: (context, state) {
              // Khi dữ liệu vừa load xong, tự động căn giữa cây sau khi build xong UI
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.delayed(
                  const Duration(milliseconds: 400),
                  () => _resetView(),
                );
              });
            },
            child: BlocBuilder<TreeBloc, TreeState>(
              builder: (context, state) {
                if (state is TreeLoading || state is TreeInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.crimson),
                  );
                }

                if (state is TreeError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            size: 60,
                            color: AppColors.crimson,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.read<TreeBloc>().add(LoadTreeEvent()),
                              child: Text(l10n.retry),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is TreeLoaded) {
                  if (state.allMembers.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.familyTreeDiagram, // Or maybe l10n.noMemberData? Let's use noMemberData here as it was empty data case
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  _ensureGraph(state.allMembers);
                  final memberMap = {for (final m in state.allMembers) m.id: m};
                  final filteredMembers = _searchQuery.isEmpty
                      ? []
                      : state.allMembers.where((m) {
                          return m.fullName.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                        }).toList();

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
                          algorithm: _buchheimWalkerAlgorithm,
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

                            final isHighlighted =
                                _searchQuery.isNotEmpty &&
                                member.fullName.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                );

                            return MemberNodeWidget(
                              key: _nodeKeys.putIfAbsent(
                                member.id,
                                () => GlobalKey(),
                              ),
                              member: member,
                              isSelected: state.selectedMemberId == member.id,
                              isHighlighted: isHighlighted,
                              onTap: () {
                                context.read<TreeBloc>().add(
                                  SelectMemberEvent(member.id),
                                );
                                context.push(
                                  '/members/${member.id}',
                                  extra: member,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (filteredMembers.isNotEmpty)
                        Positioned(
                          top: 10,
                          left: 16,
                          right: 16,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 250),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: filteredMembers.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final m = filteredMembers[index];
                                  return ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: m.gender == Gender.male
                                          ? AppColors.nodeMale
                                          : AppColors.nodeFemale,
                                      child: Icon(
                                        m.gender == Gender.male
                                            ? Icons.man
                                            : Icons.woman,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      m.fullName,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${l10n.generation} ${m.generation ?? "?"}',
                                      style: GoogleFonts.inter(fontSize: 11),
                                    ),
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                      _centerNode(m.id);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(S l10n) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.2, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _isSearching
          ? Container(
              key: const ValueKey('search_bar'),
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) => setState(() => _searchQuery = value),
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.searchHint,
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.gold,
                    size: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 2),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _isSearching = false;
                      });
                    },
                  ),
                ),
              ),
            )
          : Text(
              l10n.familyTreeDiagram.toUpperCase(),
              key: const ValueKey('app_title'),
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
                fontSize: 18,
                letterSpacing: 1.2,
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
        title: Text(
          l10n.legend,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  color: AppColors.nodeMale,
                  label: l10n.male,
                  isCircle: false,
                ),
                const SizedBox(height: 12),
                _buildLegendItem(
                  color: AppColors.nodeFemale,
                  label: l10n.female,
                  isCircle: false,
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  color: const Color(0xFF2ECC71),
                  label: l10n.stillAlive,
                  isCircle: true,
                ),
                const SizedBox(height: 12),
                _buildLegendItem(
                  color: AppColors.nodeDeceased,
                  label: l10n.deceased,
                  isCircle: true,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.understand,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.crimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required bool isCircle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isCircle ? 12 : 16,
          height: 12,
          decoration: BoxDecoration(
            color: isCircle ? color : Colors.white,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(2),
            border: isCircle
                ? Border.all(color: Colors.white, width: 1.5)
                : Border.all(color: color, width: 2.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

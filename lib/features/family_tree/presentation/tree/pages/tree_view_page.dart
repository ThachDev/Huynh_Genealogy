import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/member_node_widget.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/pages/main_shell_page.dart';
import 'package:go_router/go_router.dart';

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
    double scale = (viewportSize.width / (graphSize.width + 40)).clamp(0.4, 1.0);
    
    // Check if height also needs to be constrained
    if (graphSize.height * scale > availableHeight) {
      scale = (availableHeight / graphSize.height).clamp(0.4, 1.0);
    }

    // Calculate x to center horizontally
    final x = (viewportSize.width - graphSize.width * scale) / 2;
    // Set y to place tree slightly below the top
    final y = 60.0;

    final targetMatrix = Matrix4.identity()
      ..translate(x, y)
      ..scale(scale, scale, 1.0);

    // Create animation from current state to target
    _animation = Matrix4Tween(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.gold),
            onPressed: () => _showLegendDialog(context),
          ),
          const SizedBox(width: 8),
        ],
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
          tooltip: 'Căn giữa gốc cây',
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

                        return MemberNodeWidget(
                          member: member,
                          isSelected: state.selectedMemberId == member.id,
                          onTap: () {
                            context.read<TreeBloc>().add(
                              SelectMemberEvent(member.id),
                            );
                            context.push('/members/${member.id}', extra: member);
                          },
                        );
                      },
                    ),
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

  void _showLegendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.parchment,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Chú thích ký hiệu',
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
                  label: 'Nam',
                  isCircle: false,
                ),
                const SizedBox(height: 12),
                _buildLegendItem(
                  color: AppColors.nodeFemale,
                  label: 'Nữ',
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
                  label: 'Còn sống',
                  isCircle: true,
                ),
                const SizedBox(height: 12),
                _buildLegendItem(
                  color: AppColors.nodeDeceased,
                  label: 'Đã mất',
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
              'Đã hiểu',
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

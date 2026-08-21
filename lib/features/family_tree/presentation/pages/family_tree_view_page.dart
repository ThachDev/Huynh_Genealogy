import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/auth.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import '../bloc/family_tree_bloc.dart';
import '../widgets/family_member_node_widget.dart';
import '../widgets/add_member_option_dialog.dart';
import '../widgets/select_unlinked_member_sheet.dart';
import 'family_member_detail_page.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_member_form_page.dart';
import '../../../admin/domain/usecase/save_member.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/tree_edge_painter.dart';
import '../widgets/tree_layout_calculator.dart';

class FamilyTreeViewPage extends StatefulWidget {
  const FamilyTreeViewPage({super.key});

  @override
  State<FamilyTreeViewPage> createState() => _FamilyTreeViewPageState();
}

class _FamilyTreeViewPageState extends State<FamilyTreeViewPage>
    with TickerProviderStateMixin {
  double get _nodeHeight {
    final authState = context.read<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;
    return canEdit ? 160.0 : 125.0;
  }

  final TransformationController _transformationController =
      TransformationController();
  AnimationController? _matrixAnimationController;
  Animation<Matrix4>? _matrixAnimation;

  bool _hasFitTree = false;
  bool _showGenerationBadges = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  Map<int, Offset>? _lastPositions;
  Size? _lastViewportSize;
  Size _lastTreeSize = Size.zero;

  Timer? _searchDebounceTimer;

  void _onTransformChanged() {
    if (mounted) setState(() {});
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.trim();
        });
      }
    });
  }

  void _animateMatrixTo(Matrix4 targetMatrix) {
    _matrixAnimationController?.stop();
    _matrixAnimationController?.dispose();

    _matrixAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    final matrixTween = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    );

    _matrixAnimation = matrixTween.animate(CurvedAnimation(
      parent: _matrixAnimationController!,
      curve: Curves.easeInOutCubic,
    ));

    _matrixAnimation!.addListener(() {
      _transformationController.value = _matrixAnimation!.value;
    });

    _matrixAnimationController!.forward();
  }

  void _fitTreeOverview() {
    final viewport = _lastViewportSize;
    final treeSize = _lastTreeSize;
    if (viewport == null || treeSize == Size.zero) return;

    final scaleX = viewport.width / treeSize.width;
    final scaleY = viewport.height / treeSize.height;
    final scale = (scaleX < scaleY ? scaleX : scaleY).clamp(0.2, 1.0);

    final contentCenterX = (TreeLayoutMetrics.padding + treeSize.width) / 2;
    final contentCenterY = (TreeLayoutMetrics.padding + treeSize.height) / 2;

    final dx = viewport.width / 2 - contentCenterX * scale;
    final dy = viewport.height / 2 - contentCenterY * scale;

    final matrix = Matrix4.identity();
    matrix.setEntry(0, 0, scale);
    matrix.setEntry(1, 1, scale);
    matrix.setEntry(2, 2, 1.0);
    matrix.setEntry(0, 3, dx);
    matrix.setEntry(1, 3, dy);

    _animateMatrixTo(matrix);
  }

  void _centerOnNode(int memberId) {
    final pos = _lastPositions?[memberId];
    final viewport = _lastViewportSize;
    if (pos == null || viewport == null) return;

    const scale = 1.0;
    final tx = viewport.width / 2 - pos.dx * scale;
    final ty = viewport.height / 2 - pos.dy * scale;

    final matrix = Matrix4.identity();
    matrix.setEntry(0, 0, scale);
    matrix.setEntry(1, 1, scale);
    matrix.setEntry(2, 2, 1.0);
    matrix.setEntry(0, 3, tx);
    matrix.setEntry(1, 3, ty);

    _animateMatrixTo(matrix);
  }

  /// Reload cây gia phả sau khi thêm thành viên/vợ chồng.
  void _reloadTree() {
    if (!mounted) return;
    final authState = context.read<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;
    context.read<FamilyTreeBloc>().add(FamilyTreeLoadEvent(familyId: familyId));
  }

  @override
  void dispose() {
    _matrixAnimationController?.stop();
    _matrixAnimationController?.dispose();
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    _searchDebounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
    _searchController.addListener(_onSearchChanged);
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

  Widget _buildSearchTitleWidget(BuildContext context, String appBarTitle) {
    final l10n = AppLocalizations.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          ),
        );
      },
      child: _isSearching
          ? Container(
              key: const ValueKey('search_input_active'),
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: context.resolve(
                  Colors.white.withValues(alpha: 0.95),
                  context.surface.withValues(alpha: 0.95),
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.12),
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textPrimary,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.searchMemberHint,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: context.textSecondary.withValues(alpha: 0.6),
                    height: 1.2,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      LucideIcons.search,
                      size: 16,
                      color: context.textSecondary,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12, left: 4),
                            child: Icon(
                              LucideIcons.x,
                              size: 16,
                              color: context.textSecondary,
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )
          : Text(
              appBarTitle,
              key: const ValueKey('search_title_inactive'),
              style: GoogleFonts.beVietnamPro(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
    );
  }

  Widget _buildSearchDropdownOverlay(
      BuildContext context, List<MemberEntity> members) {
    final l10n = AppLocalizations.of(context);
    final filteredMembers = members.where((m) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = m.fullName.toLowerCase();
      final phone = (m.phone ?? '').toLowerCase();
      return name.contains(q) || phone.contains(q);
    }).toList();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: _isSearching ? 8 : -45,
      left: 16,
      right: 16,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        opacity: _isSearching ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !_isSearching,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            color: context.surface,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 340),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filteredMembers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 18,
                            color: context.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.emptyMembers,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: filteredMembers.length > 8
                            ? 8
                            : filteredMembers.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: context.textSecondary.withValues(alpha: 0.1),
                        ),
                        itemBuilder: (context, index) {
                          final m = filteredMembers[index];
                          final genText = m.generation != null
                              ? l10n.generationLevelFormat(
                                  TreeEdgePainter.toRoman(m.generation!))
                              : '';

                          return ListTile(
                            dense: true,
                            leading: AppAvatar(
                              avatarUrl: m.avatarUrl,
                              fullName: m.fullName,
                              radius: 18,
                            ),
                            title: Text(
                              m.fullName,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              [genText, if (!m.isAlive) l10n.deceasedLabel]
                                  .where((s) => s.isNotEmpty)
                                  .join(' • '),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: context.textSecondary,
                              ),
                            ),
                            trailing: Icon(
                              LucideIcons.focus,
                              size: 16,
                              color: context.textSecondary,
                            ),
                            onTap: () {
                              _centerOnNode(m.id);
                              context.read<FamilyTreeBloc>().add(
                                    FamilyTreeSelectMemberEvent(m.id),
                                  );
                              setState(() {
                                _isSearching = false;
                                _searchQuery = '';
                                _searchController.clear();
                              });
                              _searchFocusNode.unfocus();
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;
    final treeState = context.watch<FamilyTreeBloc>().state;
    String appBarTitle = l10n.familyTreeTitle;
    List<Widget> appBarActions = [];

    if (treeState is FamilyTreeLoaded) {
      if (treeState.family != null) {
        appBarTitle = l10n.familyTreeNameFormat(treeState.family!.name);
      }
      if (treeState.members.isNotEmpty) {
        appBarActions = [
          IconButton(
            icon: Icon(
              _isSearching ? LucideIcons.x : LucideIcons.search,
              color: context.textPrimary,
            ),
            tooltip: _isSearching
                ? l10n.closeSearchTooltip
                : l10n.searchMemberTooltip,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                  _searchFocusNode.unfocus();
                } else {
                  _searchFocusNode.requestFocus();
                }
              });
            },
          ),
        ];
      }
    }

    return Scaffold(
      backgroundColor: context.appBarBg,
      appBar: AppAppBar(
        titleWidget: _buildSearchTitleWidget(context, appBarTitle),
        actions: appBarActions,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'toggle_badges_fab',
            tooltip:
                _showGenerationBadges ? l10n.hideGenBadges : l10n.showGenBadges,
            onPressed: () {
              setState(() {
                _showGenerationBadges = !_showGenerationBadges;
              });
            },
            backgroundColor:
                context.resolve(Colors.white, const Color(0xFF2A2A2A)),
            mini: true,
            child: Icon(
              LucideIcons.tag,
              color: _showGenerationBadges
                  ? context.primary
                  : context.textSecondary.withValues(alpha: 0.4),
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'fit_overview_fab',
            tooltip: l10n.treeOverviewTooltip,
            onPressed: _fitTreeOverview,
            backgroundColor:
                context.resolve(Colors.white, const Color(0xFF2A2A2A)),
            mini: true,
            child: Icon(
              LucideIcons.maximize2,
              color: context.primary,
              size: 18,
            ),
          ),
        ],
      ),
      body: AppBackgroundBody(
        child: Stack(
          children: [
            BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
              builder: (context, state) {
                if (state is FamilyTreeLoading) {
                  _hasFitTree = false; // Reset to auto-fit on next load
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: FamilyTreeSkeleton(),
                  );
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

                  final coupleEdges = <TreeCoupleEdge>[];
                  final orphanEdges = <TreeEdgeData>[];
                  final spouseEdges = <TreeSpouseEdge>[];
                  final positions = const TreeLayoutCalculator().calculate(
                    state.members,
                    coupleEdges: coupleEdges,
                    orphanEdges: orphanEdges,
                    spouseEdges: spouseEdges,
                    nodeHeight: _nodeHeight,
                  );

                  double maxX = TreeLayoutMetrics.padding * 2,
                      maxY = TreeLayoutMetrics.padding * 2;
                  for (final entry in positions.entries) {
                    final right = entry.value.dx + TreeLayoutMetrics.nodeWidth / 2;
                    final bottom = entry.value.dy + _nodeHeight / 2;
                    maxX = maxX > right ? maxX : right;
                    maxY = maxY > bottom ? maxY : bottom;
                  }
                  final treeSize = Size(maxX, maxY);

                  final generationLevels = <int, double>{};
                  for (final m in state.members) {
                    final pos = positions[m.id];
                    if (pos != null && m.generation != null) {
                      generationLevels.putIfAbsent(m.generation!, () => pos.dy);
                    }
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth == 0 ||
                          constraints.maxHeight == 0) {
                        return const SizedBox.shrink();
                      }

                      // Update positions & viewport sizes for search node centering
                      _lastPositions = positions;
                      _lastViewportSize =
                          Size(constraints.maxWidth, constraints.maxHeight);
                      _lastTreeSize = treeSize;

                      final authState = context.read<AuthBloc>().state;
                      final userMemberId = authState is Authenticated
                          ? authState.user.memberId
                          : null;

                      // Auto fit or zoom to user's node on load
                      if (!_hasFitTree) {
                        _hasFitTree = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (userMemberId != null &&
                              positions.containsKey(userMemberId)) {
                            _centerOnNode(userMemberId);
                          } else {
                            _fitTreeOverview();
                          }
                        });
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InteractiveViewer(
                            transformationController: _transformationController,
                            constrained: false,
                            boundaryMargin:
                                const EdgeInsets.all(double.infinity),
                            minScale:
                                0.1, // Allow zooming out further for overview
                            maxScale: 3.0,
                            child: SizedBox(
                              width: treeSize.width,
                              height: treeSize.height,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  RepaintBoundary(
                                    child: CustomPaint(
                                      size: treeSize,
                                      painter: TreeEdgePainter(
                                        coupleEdges: coupleEdges,
                                        orphanEdges: orphanEdges,
                                        spouseEdges: spouseEdges,
                                        positions: positions,
                                        generationLevels: generationLevels,
                                        nodeHeight: _nodeHeight,
                                        primaryColor: context.primary,
                                        accentColor: context.accent,
                                        surfaceColor: context.surface,
                                        textColor: context.textPrimary,
                                        linePaint: Paint()
                                          ..color = context.resolve(
                                              context.accent,
                                              Colors.grey.shade700)
                                          ..strokeWidth = 3.0
                                          ..strokeCap = StrokeCap.round
                                          ..style = PaintingStyle.stroke,
                                        spousePaint: Paint()
                                          ..color = context.resolve(
                                              context.primary
                                                  .withValues(alpha: 0.6),
                                              Colors.grey.shade700
                                                  .withValues(alpha: 0.6))
                                          ..strokeWidth = 2.0
                                          ..strokeCap = StrokeCap.round
                                          ..style = PaintingStyle.stroke,
                                      ),
                                    ),
                                  ),
                                  ...state.members.map((member) {
                                    final pos = positions[member.id];
                                    if (pos == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Positioned(
                                      left: pos.dx - TreeLayoutMetrics.nodeWidth / 2,
                                      top: pos.dy - _nodeHeight / 2,
                                      child: FamilyMemberNodeWidget(
                                        member: member,
                                        isSelected:
                                            state.selectedMemberId == member.id,
                                        isCurrentUser:
                                            userMemberId == member.id,
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          context.read<FamilyTreeBloc>().add(
                                              FamilyTreeSelectMemberEvent(
                                                  member.id));
                                          Navigator.push(
                                            context,
                                            SereneFadeSlidePageRoute(
                                              page: FamilyMemberDetailPage(
                                                member: member,
                                                allMembers: state.members,
                                              ),
                                            ),
                                          );
                                        },
                                        onAddChildTap: canEdit
                                            ? () => _onAddChild(
                                                member, state.members)
                                            : null,
                                        onAddSpouseTap: canEdit
                                            ? () => _onAddSpouse(
                                                member, state.members)
                                            : null,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),

                          // ── Sticky Pinned Floating Generation Badges (Ghim mép trái màn hình) ──
                          if (_showGenerationBadges)
                            AnimatedBuilder(
                              animation: _transformationController,
                              builder: (context, _) {
                                final matrix = _transformationController.value;
                                final sortedGens =
                                    generationLevels.keys.toList()..sort();

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: sortedGens.map((gen) {
                                    final canvasY = generationLevels[gen]!;
                                    final screenY = MatrixUtils.transformPoint(
                                            matrix, Offset(0, canvasY))
                                        .dy;

                                    // Ẩn badge nếu nằm ngoài khung nhìn màn hình
                                    if (screenY < -30 ||
                                        screenY > constraints.maxHeight + 30) {
                                      return const SizedBox.shrink();
                                    }

                                    return Positioned(
                                      left: 14,
                                      top: screenY - 7,
                                      child: Text(
                                        l10n
                                            .generationLevelFormat(
                                                TreeEdgePainter.toRoman(gen))
                                            .toUpperCase(),
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: context.accent,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            _buildSearchDropdownOverlay(context,
                treeState is FamilyTreeLoaded ? treeState.members : []),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddChild(
      MemberEntity parentMember, List<MemberEntity> allMembers) async {
    final l10n = AppLocalizations.of(context);
    final candidateMembers = allMembers.where((m) {
      if (m.id == parentMember.id) return false;
      return m.parentId == null && m.motherId == null;
    }).toList();

    AddMemberOption? option;
    if (candidateMembers.isNotEmpty) {
      option = await AddMemberOptionDialog.show(
        context,
        title: l10n.addChildForFormat(parentMember.fullName),
        availableCount: candidateMembers.length,
      );
      if (option == null) return;
    } else {
      option = AddMemberOption.createNew;
    }

    if (!mounted) return;

    if (option == AddMemberOption.createNew) {
      final result = await Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: AdminMemberFormPage(
            initialParentId: parentMember.id,
            initialGeneration: (parentMember.generation ?? 0) + 1,
            isLockedContext: true,
          ),
        ),
      );
      if (result == true && mounted) {
        _reloadTree();
      }
    } else if (option == AddMemberOption.selectExisting) {
      final selectedMember = await SelectUnlinkedMemberSheet.show(
        context,
        candidateMembers: candidateMembers,
        title: l10n.selectChildMemberTitle,
        subtitle: l10n.linkAsChildFormat(parentMember.fullName),
      );
      if (selectedMember == null || !mounted) return;

      final confirm = await AppDialog.confirm(
        context,
        title: l10n.confirmConnectionLabel,
        message: l10n.confirmLinkChildMessage(
            selectedMember.fullName, parentMember.fullName),
        confirmLabel: l10n.confirmConnectionLabel,
        cancelLabel: l10n.cancelLabel,
        type: AppDialogType.info,
      );

      if (confirm == true && mounted) {
        final isMother = parentMember.gender == Gender.female;
        final updatedMember = selectedMember.copyWith(
          parentId: isMother ? selectedMember.parentId : parentMember.id,
          motherId: isMother ? parentMember.id : selectedMember.motherId,
          generation: (parentMember.generation ?? 0) + 1,
        );

        final saveMemberUsecase = sl<SaveMember>();
        final result =
            await saveMemberUsecase(SaveMemberParams(member: updatedMember));
        if (!mounted) return;

        result.fold(
          (failure) {
            AppSnackBar.error(context, failure.message);
          },
          (saved) {
            AppSnackBar.success(
                context, l10n.memberConnectedSuccessFormat(saved.fullName));
            _reloadTree();
          },
        );
      }
    }
  }

  Future<void> _onAddSpouse(
      MemberEntity spouseMember, List<MemberEntity> allMembers) async {
    final l10n = AppLocalizations.of(context);
    final candidateMembers = allMembers.where((m) {
      if (m.id == spouseMember.id) return false;
      return m.spouseId == null;
    }).toList();

    AddMemberOption? option;
    if (candidateMembers.isNotEmpty) {
      option = await AddMemberOptionDialog.show(
        context,
        title: l10n.addSpouseForFormat(spouseMember.fullName),
        availableCount: candidateMembers.length,
      );
      if (option == null) return;
    } else {
      option = AddMemberOption.createNew;
    }

    if (!mounted) return;

    if (option == AddMemberOption.createNew) {
      final result = await Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: AdminMemberFormPage(
            initialSpouseId: spouseMember.id,
            initialGeneration: spouseMember.generation,
            isLockedContext: true,
          ),
        ),
      );
      if (result == true && mounted) {
        _reloadTree();
      }
    } else if (option == AddMemberOption.selectExisting) {
      final selectedMember = await SelectUnlinkedMemberSheet.show(
        context,
        candidateMembers: candidateMembers,
        title: l10n.selectSpouseMemberTitle,
        subtitle: l10n.linkSpouseFormat(spouseMember.fullName),
      );
      if (selectedMember == null || !mounted) return;

      final confirm = await AppDialog.confirm(
        context,
        title: l10n.confirmConnectionLabel,
        message: l10n.confirmLinkSpouseMessage(
            selectedMember.fullName, spouseMember.fullName),
        confirmLabel: l10n.confirmConnectionLabel,
        cancelLabel: l10n.cancelLabel,
        type: AppDialogType.info,
      );

      if (confirm == true && mounted) {
        final updatedSelected = selectedMember.copyWith(
          spouseId: spouseMember.id,
          generation: spouseMember.generation ?? selectedMember.generation,
          maritalStatus: MaritalStatus.married,
        );

        final saveMemberUsecase = sl<SaveMember>();
        final result1 =
            await saveMemberUsecase(SaveMemberParams(member: updatedSelected));

        if (spouseMember.spouseId == null) {
          final updatedSpouse = spouseMember.copyWith(
            spouseId: selectedMember.id,
            maritalStatus: MaritalStatus.married,
          );
          await saveMemberUsecase(SaveMemberParams(member: updatedSpouse));
        }

        if (!mounted) return;

        result1.fold(
          (failure) {
            AppSnackBar.error(context, failure.message);
          },
          (saved) {
            AppSnackBar.success(context, l10n.spouseConnectedSuccess);
            _reloadTree();
          },
        );
      }
    }
  }
}


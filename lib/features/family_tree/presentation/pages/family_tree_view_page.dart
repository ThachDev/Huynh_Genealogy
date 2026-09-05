import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/auth.dart';
import '../../../../resources/app_localizations.dart';
import '../../../admin/domain/usecase/save_member.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_member_form_page.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/services/family_name_resolver.dart';
import '../bloc/family_tree_bloc.dart';
import '../widgets/add_member_option_dialog.dart';
import '../widgets/select_unlinked_member_sheet.dart';
import '../widgets/tree_action_fab.dart';
import '../widgets/tree_canvas_view.dart';
import '../widgets/tree_edge_painter.dart';
import '../widgets/tree_generation_badges.dart';
import '../widgets/tree_layout_calculator.dart';
import '../widgets/tree_search_overlay.dart';
import 'family_book_config_page.dart';
import 'family_member_detail_page.dart';

class FamilyTreeViewPage extends StatefulWidget {
  const FamilyTreeViewPage({super.key});

  @override
  State<FamilyTreeViewPage> createState() => _FamilyTreeViewPageState();
}

class _FamilyTreeViewPageState extends State<FamilyTreeViewPage>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey<ExpandableFabState> _fabKey = GlobalKey<ExpandableFabState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  AnimationController? _matrixAnimationController;
  Animation<Matrix4>? _matrixAnimation;
  Timer? _searchDebounceTimer;

  bool _hasFitTree = false;
  bool _showGenerationBadges = true;
  bool _isSearching = false;
  String _searchQuery = '';

  Map<int, Offset>? _lastPositions;
  Size? _lastViewportSize;
  Size _lastTreeSize = Size.zero;

  double get _nodeHeight {
    final authState = context.read<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;
    return canEdit ? 160.0 : 125.0;
  }

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _matrixAnimationController?.stop();
    _matrixAnimationController?.dispose();
    _transformationController.dispose();
    _searchDebounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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

  void _goToMyPosition() {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthBloc>().state;
    final userMemberId =
        authState is Authenticated ? authState.user.memberId : null;
    if (userMemberId != null &&
        _lastPositions != null &&
        _lastPositions!.containsKey(userMemberId)) {
      _centerOnNode(userMemberId);
    } else {
      AppSnackBar.info(context, l10n.accountNotLinkedWithMember);
    }
  }

  void _openFamilyBookStudio() {
    final l10n = AppLocalizations.of(context);
    final state = context.read<FamilyTreeBloc>().state;
    if (state is! FamilyTreeLoaded || state.members.isEmpty) {
      AppSnackBar.error(context, l10n.noMemberDataToExport);
      return;
    }
    final surname = FamilyNameResolver.resolveSurname(state.members);
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: FamilyBookConfigPage(
          members: state.members,
          initialFamilyName: surname,
        ),
      ),
    );
  }

  void _reloadTree() {
    if (!mounted) return;
    final authState = context.read<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;
    context.read<FamilyTreeBloc>().add(FamilyTreeLoadEvent(familyId: familyId));
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
        titleWidget: TreeSearchBarWidget(
          isSearching: _isSearching,
          searchController: _searchController,
          searchFocusNode: _searchFocusNode,
          searchQuery: _searchQuery,
          appBarTitle: appBarTitle,
        ),
        actions: appBarActions,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: TreeActionFabWidget(
        fabKey: _fabKey,
        showGenerationBadges: _showGenerationBadges,
        onExportBook: _openFamilyBookStudio,
        onGoToMyLocation: _goToMyPosition,
        onFitOverview: _fitTreeOverview,
        onToggleGenerationBadges: () {
          setState(() {
            _showGenerationBadges = !_showGenerationBadges;
          });
        },
      ),
      body: AppBackgroundBody(
        enableMaxWidth: false,
        child: Stack(
          children: [
            BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
              builder: (context, state) {
                if (state is FamilyTreeLoading) {
                  _hasFitTree = false;
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

                  double maxX = TreeLayoutMetrics.padding * 2;
                  double maxY = TreeLayoutMetrics.padding * 2;
                  for (final entry in positions.entries) {
                    final right =
                        entry.value.dx + TreeLayoutMetrics.nodeWidth / 2;
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

                      _lastPositions = positions;
                      _lastViewportSize =
                          Size(constraints.maxWidth, constraints.maxHeight);
                      _lastTreeSize = treeSize;

                      final userMemberId = authState is Authenticated
                          ? authState.user.memberId
                          : null;

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
                          TreeCanvasView(
                            transformationController: _transformationController,
                            treeSize: treeSize,
                            viewportSize:
                                Size(constraints.maxWidth, constraints.maxHeight),
                            nodeHeight: _nodeHeight,
                            members: state.members,
                            positions: positions,
                            coupleEdges: coupleEdges,
                            orphanEdges: orphanEdges,
                            spouseEdges: spouseEdges,
                            generationLevels: generationLevels,
                            selectedMemberId: state.selectedMemberId,
                            userMemberId: userMemberId,
                            canEdit: canEdit,
                            onSelectMember: (member) async {
                              context.read<FamilyTreeBloc>().add(
                                    FamilyTreeSelectMemberEvent(member.id),
                                  );
                              final result = await Navigator.push(
                                context,
                                SereneFadeSlidePageRoute(
                                  page: FamilyMemberDetailPage(
                                    member: member,
                                    allMembers: state.members,
                                  ),
                                ),
                              );
                              if (result == true && mounted) {
                                _reloadTree();
                              }
                            },
                            onAddChild: (member) =>
                                _onAddChild(member, state.members),
                            onAddSpouse: (member) =>
                                _onAddSpouse(member, state.members),
                          ),
                          if (_showGenerationBadges)
                            TreeGenerationBadgesWidget(
                              transformationController:
                                  _transformationController,
                              generationLevels: generationLevels,
                              viewportHeight: constraints.maxHeight,
                            ),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            TreeSearchDropdownOverlay(
              isSearching: _isSearching,
              searchQuery: _searchQuery,
              members: treeState is FamilyTreeLoaded ? treeState.members : [],
              onSelectMember: (m) {
                _centerOnNode(m.id);
                context
                    .read<FamilyTreeBloc>()
                    .add(FamilyTreeSelectMemberEvent(m.id));
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
                _searchFocusNode.unfocus();
              },
            ),
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
      // Không phải vợ/chồng của parentMember
      if (parentMember.spouseId != null && m.id == parentMember.spouseId) {
        return false;
      }
      if (m.spouseId != null && m.spouseId == parentMember.id) {
        return false;
      }
      // Phải là thành viên tự do / chưa liên kết vào cây
      final isUnlinked = m.parentId == null &&
          m.motherId == null &&
          m.spouseId == null &&
          m.generation != 1;
      if (!isUnlinked) return false;

      // Ràng buộc thế hệ: con không thể có đời <= đời cha mẹ
      if (parentMember.generation != null && m.generation != null) {
        if (m.generation! <= parentMember.generation!) return false;
      }

      return true;
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
        final otherParentId = parentMember.spouseId;
        final updatedMember = selectedMember.copyWith(
          parentId: isMother
              ? (otherParentId ?? selectedMember.parentId)
              : parentMember.id,
          motherId: isMother
              ? parentMember.id
              : (otherParentId ?? selectedMember.motherId),
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
      // Phải là thành viên tự do / chưa liên kết vào cây
      final isUnlinked = m.parentId == null &&
          m.motherId == null &&
          m.spouseId == null &&
          (spouseMember.generation == 1 || m.generation != 1);
      if (!isUnlinked) return false;

      // Cùng thế hệ (nếu cả 2 đã có thông tin đời)
      if (spouseMember.generation != null && m.generation != null) {
        if (m.generation != spouseMember.generation) return false;
      }

      return true;
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

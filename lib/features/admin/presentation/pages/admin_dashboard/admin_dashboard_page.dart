import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';
import '../../../../auth/auth.dart';
import '../../../../family_tree/family_tree.dart';
import 'pages/admin_member_form_page.dart';
import 'pages/admin_branch_form_page.dart';
import 'pages/admin_branch_detail_page.dart';
import '../../../../family_tree/presentation/widgets/add_member_option_dialog.dart';
import '../../../../family_tree/presentation/widgets/select_unlinked_member_sheet.dart';
import '../../bloc/admin_member_form/admin_member_form_bloc.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';
import '../../bloc/admin_branch_form/admin_branch_form_bloc.dart';
import '../../widgets/admin_dashboard/quick_stats_row.dart';
import '../../widgets/admin_dashboard/member_item_widget.dart';
import '../../widgets/admin_dashboard/branch_item_widget.dart';
import '../../widgets/admin_dashboard/pending_request_item_widget.dart';
import '../../widgets/admin_dashboard/family_dashboard_header_widget.dart';

enum AdminDashboardTab { members, branches, pending }

class AdminDashboardPage extends StatefulWidget {
  final bool isActive;

  const AdminDashboardPage({
    super.key,
    this.isActive = false,
  });

  /// Role label & color helper
  static String roleLabel(String role, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return l10n.roleOwner;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return l10n.roleEditor;
      case 'VIEWER':
        return l10n.roleViewer;
      default:
        return l10n.roleViewer;
    }
  }

  static Color roleColor(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return AppColors.crimson;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return Colors.indigo.shade600;
      default:
        return Colors.teal;
    }
  }

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  AdminDashboardTab _selectedTab = AdminDashboardTab.members;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 15;
  int _memberLimit = _pageSize;
  int _branchLimit = _pageSize;
  int _pendingLimit = _pageSize;

  String? _genderFilter;
  bool? _isAliveFilter;
  AppLocalizations? _l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context);
  }

  void _updateFAB() {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.isActive) return;

    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final role = user?.role ?? 'VIEWER';
    final roleUpper = role.toUpperCase();
    final canEdit =
        roleUpper == 'OWNER' || roleUpper == 'EDITOR' || roleUpper == 'CREATOR';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!canEdit) {
        UserMainNavigationPage.fabNotifier.value = null;
        return;
      }

      if (_selectedTab == AdminDashboardTab.members) {
        UserMainNavigationPage.fabNotifier.value = FABConfig(
          icon: LucideIcons.userPlus,
          label: l10n.addMemberFabLabel,
          onTap: () async {
            final treeState = context.read<FamilyTreeBloc>().state;
            List<MemberEntity> unlinkedMembers = [];
            if (treeState is FamilyTreeLoaded) {
              unlinkedMembers = treeState.members
                  .where((m) =>
                      m.parentId == null &&
                      m.motherId == null &&
                      m.spouseId == null)
                  .toList();
            }

            AddMemberOption? option;
            if (unlinkedMembers.isNotEmpty) {
              option = await AddMemberOptionDialog.show(
                context,
                title: l10n.addMemberTitle,
                availableCount: unlinkedMembers.length,
              );
              if (option == null) return;
            } else {
              option = AddMemberOption.createNew;
            }

            if (!mounted) return;

            if (option == AddMemberOption.createNew) {
              Navigator.push(
                context,
                SereneFadeSlidePageRoute(
                  page: const AdminMemberFormPage(),
                ),
              ).then((_) => _loadTree());
            } else if (option == AddMemberOption.selectExisting) {
              final selected = await SelectUnlinkedMemberSheet.show(
                context,
                candidateMembers: unlinkedMembers,
                title: l10n.selectUnlinkedMemberTitle,
                subtitle: l10n.selectUnlinkedMemberSubtitle,
              );
              if (selected != null && mounted) {
                final selectedMemberId = selected.id;
                Navigator.push(
                  context,
                  SereneFadeSlidePageRoute(
                    page: AdminMemberFormPage(memberId: selectedMemberId),
                  ),
                ).then((_) => _loadTree());
              }
            }
          },
        );
      } else if (_selectedTab == AdminDashboardTab.branches) {
        UserMainNavigationPage.fabNotifier.value = FABConfig(
          icon: LucideIcons.gitBranch,
          label: l10n.addBranchFabLabel,
          onTap: () => _openBranchForm(context),
        );
      } else {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
  }

  @override
  void didUpdateWidget(covariant AdminDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _updateFAB();
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

    // Dispatch events to fetch latest data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTree();
      _loadPendingRequests();
      if (widget.isActive) {
        _updateFAB();
      }
    });
  }

  @override
  void dispose() {
    final l10n = _l10n;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserMainNavigationPage.fabNotifier.value?.label ==
              l10n?.addMemberFabLabel ||
          UserMainNavigationPage.fabNotifier.value?.label ==
              l10n?.addBranchFabLabel) {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
      _memberLimit = _pageSize;
      _branchLimit = _pageSize;
      _pendingLimit = _pageSize;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_selectedTab == AdminDashboardTab.members) {
        setState(() {
          _memberLimit += _pageSize;
        });
      } else if (_selectedTab == AdminDashboardTab.branches) {
        setState(() {
          _branchLimit += _pageSize;
        });
      } else if (_selectedTab == AdminDashboardTab.pending) {
        setState(() {
          _pendingLimit += _pageSize;
        });
      }
    }
  }

  int? _familyId() {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.familyId : null;
  }

  void _loadTree() {
    final familyId = _familyId();
    if (familyId != null) {
      context
          .read<FamilyTreeBloc>()
          .add(FamilyTreeLoadEvent(familyId: familyId));
    }
  }

  void _loadPendingRequests() {
    final familyId = _familyId();
    final authState = context.read<AuthBloc>().state;
    final role = authState is Authenticated
        ? authState.user.role.toUpperCase()
        : 'VIEWER';
    // Mọi vai trò admin đều cần dữ liệu gia tộc (tên + mã mời), không chỉ Owner.
    final canSeeFamily =
        role == 'OWNER' || role == 'CREATOR' || role == 'EDITOR';
    if (familyId != null && canSeeFamily) {
      context.read<AdminPendingRequestsBloc>().add(
            LoadAdminPendingRequestsEvent(familyId: familyId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final l10n = AppLocalizations.of(context)!;
    final pendingState = context.watch<AdminPendingRequestsBloc>().state;

    // Resolve family name & invite code dynamically
    String familyName = l10n.appTitle;
    String inviteCode = '';
    if (pendingState is AdminPendingRequestsLoaded &&
        pendingState.family != null) {
      familyName = pendingState.family!.name;
      inviteCode = pendingState.family!.inviteCode;
    } else if (user != null) {
      final userTreeState = context.watch<FamilyTreeBloc>().state;
      if (userTreeState is FamilyTreeLoaded &&
          userTreeState.members.isNotEmpty) {
        final rootMembers = userTreeState.members.where(
          (m) => m.generation == 1 || m.parentId == null,
        );
        final rootMember = rootMembers.isNotEmpty
            ? rootMembers.first
            : userTreeState.members.first;
        final parts = rootMember.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = l10n.familyNameFormat(parts.first);
        }
      } else {
        final parts = user.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = l10n.familyNameFormat(parts.first);
        }
      }
    }

    // Connect real data counts
    final userTreeState = context.watch<FamilyTreeBloc>().state;
    String memberCount = '--';
    String branchCount = '--';
    List<MemberEntity> allMembers = [];
    List<BranchEntity> allBranches = [];
    if (userTreeState is FamilyTreeLoaded) {
      memberCount = userTreeState.members.length.toString();
      branchCount = userTreeState.branches.length.toString();
      allMembers = userTreeState.members;
      allBranches = userTreeState.branches;
    }

    String pendingCount = '--';
    List<FamilyUserEntity> pendingRequests = [];
    if (pendingState is AdminPendingRequestsLoaded) {
      pendingCount = pendingState.requests.length.toString();
      pendingRequests = pendingState.requests;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AdminPendingRequestsBloc, AdminPendingRequestsState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            if (state is AdminRequestApprovedSuccess) {
              AppSnackBar.success(context, l10n.approveSuccess);
              _loadPendingRequests();
              _loadTree();
            } else if (state is AdminRequestRejectedSuccess) {
              AppSnackBar.success(context, l10n.rejectSuccess);
              _loadPendingRequests();
            } else if (state is AdminPendingRequestsFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
        BlocListener<AdminMemberFormBloc, AdminMemberFormState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            if (state is AdminMemberFormSuccess) {
              if (state.isDeleted) {
                AppSnackBar.success(context, l10n.deleteMemberSuccess);
              } else {
                AppSnackBar.success(context, l10n.saveMemberSuccess);
              }
              _loadTree();
            } else if (state is AdminMemberFormError) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
        BlocListener<AdminBranchFormBloc, AdminBranchFormState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            if (state is AdminBranchFormSuccess) {
              if (state.isDeleted) {
                AppSnackBar.success(context, l10n.deleteBranchSuccess);
              } else {
                AppSnackBar.success(context, l10n.saveBranchSuccess);
              }
              _loadTree();
            } else if (state is AdminBranchFormError) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackgroundBody(
          child: Column(
            children: [
              _buildHeader(
                context,
                user,
                familyName,
                inviteCode,
                userTreeState: userTreeState,
                pendingState: pendingState,
              ),
              QuickStatsRow(
                showPending: true,
                memberCount: memberCount,
                branchCount: branchCount,
                pendingCount: pendingCount,
                selectedTab: _selectedTab,
                onTabChanged: (tab) {
                  setState(() {
                    _selectedTab = tab;
                    _searchController.clear();
                    _memberLimit = 5;
                    _branchLimit = 5;
                    _pendingLimit = 5;
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0);
                    }
                    _updateFAB();
                  });
                },
              ),
              Expanded(
                child: _buildContentSection(
                  userTreeState: userTreeState,
                  pendingState: pendingState,
                  members: allMembers,
                  branches: allBranches,
                  requests: pendingRequests,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user, String familyName,
      String inviteCode,
      {required FamilyTreeState userTreeState,
      required AdminPendingRequestsState pendingState}) {
    final logoUrl = (pendingState is AdminPendingRequestsLoaded)
        ? pendingState.family?.logoUrl
        : (userTreeState is FamilyTreeLoaded
            ? userTreeState.family?.logoUrl
            : null);

    return FamilyDashboardHeaderWidget(
      user: user,
      familyName: familyName,
      inviteCode: inviteCode,
      logoUrl: logoUrl,
      isLoading: userTreeState is FamilyTreeLoading &&
          pendingState is AdminPendingRequestsLoading,
      showRoleTag: true, // Admin Dashboard luôn hiển thị Role Tag
    );
  }

  Widget _buildContentSection({
    required FamilyTreeState userTreeState,
    required AdminPendingRequestsState pendingState,
    required List<MemberEntity> members,
    required List<BranchEntity> branches,
    required List<FamilyUserEntity> requests,
  }) {
    final l10n = AppLocalizations.of(context)!;

    switch (_selectedTab) {
      case AdminDashboardTab.members:
        if (userTreeState is FamilyTreeLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: AdminDashboardSkeleton(),
          );
        }
        final filteredMembers = members.where((m) {
          final matchQuery = m.fullName.toLowerCase().contains(_searchQuery) ||
              (m.branchName != null &&
                  m.branchName!.toLowerCase().contains(_searchQuery));
          if (!matchQuery) {
            return false;
          }

          if (_genderFilter != null) {
            if (_genderFilter == 'MALE' && m.gender != Gender.male) {
              return false;
            }
            if (_genderFilter == 'FEMALE' && m.gender != Gender.female) {
              return false;
            }
          }

          if (_isAliveFilter != null) {
            if (m.isAlive != _isAliveFilter) {
              return false;
            }
          }

          return true;
        }).toList();

        final hasMoreMembers = filteredMembers.length > _memberLimit;
        final currentMemberCount =
            hasMoreMembers ? _memberLimit : filteredMembers.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(l10n.searchMembersHint, showFilter: true),
            if (filteredMembers.isEmpty)
              _buildEmptyWidget(l10n.emptyMembers)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: currentMemberCount + (hasMoreMembers ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= currentMemberCount) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                    }
                    final member = filteredMembers[index];
                    return MemberItemWidget(
                      member: member,
                      allMembers: members,
                      onEdit: () {
                        Navigator.push(
                          context,
                          SereneFadeSlidePageRoute(
                            page: AdminMemberFormPage(memberId: member.id),
                          ),
                        );
                      },
                      onDelete: () => _showDeleteConfirmation(context, member),
                    );
                  },
                ),
              ),
          ],
        );

      case AdminDashboardTab.branches:
        if (userTreeState is FamilyTreeLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: AdminDashboardSkeleton(),
          );
        }
        final filteredBranches = branches
            .where((b) =>
                b.name.toLowerCase().contains(_searchQuery) ||
                (b.founderName != null &&
                    b.founderName!.toLowerCase().contains(_searchQuery)))
            .toList();

        final hasMoreBranches = filteredBranches.length > _branchLimit;
        final currentBranchCount =
            hasMoreBranches ? _branchLimit : filteredBranches.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(l10n.searchBranchesHint),
            if (filteredBranches.isEmpty)
              _buildEmptyWidget(l10n.emptyBranches)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: currentBranchCount + (hasMoreBranches ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= currentBranchCount) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                    }
                    final branch = filteredBranches[index];
                    return BranchItemWidget(
                      branch: branch,
                      memberCount:
                          members.where((m) => m.branchId == branch.id).length,
                      onTap: () {
                        Navigator.push(
                          context,
                          SereneFadeSlidePageRoute(
                            page: AdminBranchDetailPage(
                              branch: branch,
                              members: members,
                            ),
                          ),
                        ).then((result) {
                          if (result == true) {
                            _loadTree();
                          }
                        });
                      },
                      onEdit: () => _openBranchForm(context, branch: branch),
                      onDelete: () =>
                          _showDeleteBranchConfirmation(context, branch),
                    );
                  },
                ),
              ),
          ],
        );

      case AdminDashboardTab.pending:
        if (pendingState is AdminPendingRequestsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: AdminDashboardSkeleton(),
          );
        }
        final filteredRequests = requests
            .where((r) => (r.userFullName ?? r.memberData?.fullName ?? '')
                .toLowerCase()
                .contains(_searchQuery))
            .toList();

        final hasMorePending = filteredRequests.length > _pendingLimit;
        final currentPendingCount =
            hasMorePending ? _pendingLimit : filteredRequests.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(l10n.searchHint),
            if (filteredRequests.isEmpty)
              _buildEmptyWidget(l10n.emptyPendingRequests)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: currentPendingCount + (hasMorePending ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= currentPendingCount) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                    }
                    return PendingRequestItemWidget(
                      request: filteredRequests[index],
                    );
                  },
                ),
              ),
          ],
        );
    }
  }



  void _showDeleteConfirmation(
      BuildContext context, MemberEntity member) async {
    final l10n = AppLocalizations.of(context)!;
    final treeState = context.read<FamilyTreeBloc>().state;
    final allMembers =
        treeState is FamilyTreeLoaded ? treeState.members : <MemberEntity>[];
    final hasChildren = allMembers.any((m) => m.parentId == member.id);

    if (!hasChildren) {
      final confirmed = await AppDialog.confirm(
        context,
        title: l10n.deleteMemberTitle,
        message: l10n.deleteMemberMessage(member.fullName),
        confirmLabel: l10n.deleteLabel,
        type: AppDialogType.danger,
        showIcon: false,
        confirmColor: context.primary,
        messageSpan: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 13,
            color: context.textPrimary,
            height: 1.5,
          ),
          children: [
            TextSpan(text: l10n.deleteMemberConfirmStart),
            TextSpan(
              text: member.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: l10n.deleteMemberConfirmEnd),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        context
            .read<AdminMemberFormBloc>()
            .add(DeleteAdminMemberFormEvent(member.id));
      }
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ctx.surface,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: ctx.textSecondary.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Title (Seamless: Xoá thành viên + member.fullName)
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 17,
                      color: ctx.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: l10n.deleteMemberTitlePrefix,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: member.fullName,
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          color: ctx.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.deleteMemberWithDescendantsMessage,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: ctx.textPrimary, height: 1.4),
                ),
                const SizedBox(height: 16),

                // Option 1: Đôn con lên (Recommended Option Card)
                InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<AdminMemberFormBloc>().add(
                        DeleteAdminMemberFormEvent(member.id,
                            reassignChildrenToParent: true));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ctx.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ctx.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.gitMerge,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    l10n.promoteChildrenOption,
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: ctx.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:
                                          ctx.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      l10n.recommendedLabel,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: ctx.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.promoteChildrenDesc,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: ctx.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Option 2: Xoá & Tách nhánh (Danger / Secondary Action)
                InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<AdminMemberFormBloc>().add(
                        DeleteAdminMemberFormEvent(member.id,
                            reassignChildrenToParent: false));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.gitBranch,
                              color: Colors.redAccent, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.deleteAndDetachOption,
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.deleteAndDetachDesc,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: ctx.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cancel Button (Default Text / Ghost Variant)
                AppButton(
                  label: l10n.cancelLabel,
                  onPressed: () => Navigator.pop(ctx),
                  variant: AppButtonVariant.ghost,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openBranchForm(BuildContext context, {BranchEntity? branch}) async {
    final result = await Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: AdminBranchFormPage(branch: branch),
      ),
    );
    if (result == true && context.mounted) {
      _loadTree();
    }
  }

  void _showDeleteBranchConfirmation(
      BuildContext context, BranchEntity branch) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: ctx.surface,
          title: Text(
            l10n.deleteBranchTitle,
            style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold, color: ctx.textPrimary),
          ),
          content: Text(
            l10n.deleteBranchMessage(branch.name),
            style: GoogleFonts.beVietnamPro(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelLabel,
                  style: GoogleFonts.beVietnamPro(color: ctx.textSecondary)),
            ),
            AppButton(
              label: l10n.deleteLabel,
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .read<AdminBranchFormBloc>()
                    .add(DeleteAdminBranchFormEvent(branch.id));
              },
              variant: AppButtonVariant.danger,
              size: AppButtonSize.small,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(String hintText, {bool showFilter = false}) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AppSearchBar(
        controller: _searchController,
        hintText: hintText,
        trailing: [
          if (showFilter)
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: context.surface,
              elevation: 4,
              offset: const Offset(0, 40),
              icon: Icon(
                LucideIcons.listFilter,
                size: 20,
                color: (_genderFilter != null || _isAliveFilter != null)
                    ? context.primary
                    : context.textSecondary,
              ),
              onSelected: (value) {
                if (value == 'clear_all') {
                  setState(() {
                    _genderFilter = null;
                    _isAliveFilter = null;
                    _memberLimit = 5;
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0);
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'clear_all',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(LucideIcons.filterX,
                            color: context.textPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(l10n.clearAllLabel,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: context.textPrimary)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    enabled: false,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: StatefulBuilder(
                      builder: (context, setPopupState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l10n.genderLabel,
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.textPrimary)),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoSlidingSegmentedControl<String>(
                                backgroundColor: context.isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200,
                                thumbColor: context.isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.white,
                                groupValue: _genderFilter,
                                children: {
                                  'MALE': Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(l10n.genderMale,
                                        style: GoogleFonts.beVietnamPro(
                                            fontSize: 12,
                                            color: context.textPrimary)),
                                  ),
                                  'FEMALE': Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(l10n.genderFemale,
                                        style: GoogleFonts.beVietnamPro(
                                            fontSize: 12,
                                            color: context.textPrimary)),
                                  ),
                                },
                                onValueChanged: (value) {
                                  if (value != null) {
                                    setPopupState(() {
                                      _genderFilter = value;
                                    });
                                    setState(() {
                                      _genderFilter = value;
                                      _memberLimit = 5;
                                      if (_scrollController.hasClients) {
                                        _scrollController.jumpTo(0);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.statusLabel,
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.textPrimary)),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoSlidingSegmentedControl<String>(
                                backgroundColor: context.isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200,
                                thumbColor: context.isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.white,
                                groupValue: _isAliveFilter == null
                                    ? null
                                    : (_isAliveFilter! ? 'ALIVE' : 'DECEASED'),
                                children: {
                                  'ALIVE': Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(l10n.aliveLabel,
                                        style: GoogleFonts.beVietnamPro(
                                            fontSize: 12,
                                            color: context.textPrimary)),
                                  ),
                                  'DECEASED': Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(l10n.deceasedLabel,
                                        style: GoogleFonts.beVietnamPro(
                                            fontSize: 12,
                                            color: context.textPrimary)),
                                  ),
                                },
                                onValueChanged: (value) {
                                  if (value != null) {
                                    final isAlive = value == 'ALIVE';
                                    setPopupState(() {
                                      _isAliveFilter = isAlive;
                                    });
                                    setState(() {
                                      _isAliveFilter = isAlive;
                                      _memberLimit = 5;
                                      if (_scrollController.hasClients) {
                                        _scrollController.jumpTo(0);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return AppEmptyState(
      icon: LucideIcons.folderOpen,
      iconSize: 40,
      message: message,
      useCardStyle: true,
    );
  }
}

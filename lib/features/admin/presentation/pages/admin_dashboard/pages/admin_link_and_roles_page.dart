import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/features/admin/domain/entities/member_account_link_entity.dart';
import 'package:giatocviet/resources/app_localizations.dart';
import 'package:giatocviet/features/auth/auth.dart';
import 'package:giatocviet/features/admin/presentation/bloc/member_account_links/member_account_links_bloc.dart';
import 'package:giatocviet/features/admin/presentation/bloc/admin_member_roles/admin_member_roles_bloc.dart';
import 'package:giatocviet/features/admin/presentation/bloc/admin_transfer_ownership_bloc/admin_transfer_ownership_bloc.dart';
import 'package:giatocviet/features/admin/presentation/pages/admin_dashboard/admin_dashboard_page.dart';
import 'package:giatocviet/features/admin/presentation/widgets/settings/link_account_email_sheet.dart';
import 'package:giatocviet/features/admin/presentation/widgets/settings/member_account_link_item_tile.dart';
import 'package:giatocviet/features/admin/presentation/widgets/settings/member_role_option_tiles.dart';

enum LinkStatusFilter { all, linked, unlinked }

class AdminLinkAndRolesPage extends StatefulWidget {
  const AdminLinkAndRolesPage({
    super.key,
    this.initialTabIndex = 0,
    this.memberId,
  });
  final int initialTabIndex;
  final int? memberId;

  @override
  State<AdminLinkAndRolesPage> createState() => _AdminLinkAndRolesPageState();
}

class _AdminLinkAndRolesPageState extends State<AdminLinkAndRolesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State Tab 1: Liên kết tài khoản
  final _linkSearchController = TextEditingController();
  LinkStatusFilter _statusFilter = LinkStatusFilter.all;

  // State Tab 2: Phân quyền thành viên
  final _roleSearchController = TextEditingController();
  String? _roleFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.familyId != null) {
      final familyId = authState.user.familyId!;
      context
          .read<MemberAccountLinksBloc>()
          .add(LoadMemberAccountLinksEvent(familyId: familyId));
      context
          .read<AdminMemberRolesBloc>()
          .add(LoadAdminMemberRolesEvent(familyId: familyId));
    }
  }

  void _reloadLinks() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.familyId != null) {
      context.read<MemberAccountLinksBloc>().add(
            LoadMemberAccountLinksEvent(familyId: authState.user.familyId!),
          );
      context.read<AdminMemberRolesBloc>().add(
            LoadAdminMemberRolesEvent(familyId: authState.user.familyId!),
          );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _linkSearchController.dispose();
    _roleSearchController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTIONS: LINK & UNLINK
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> _onLinkPressed(
    MemberAccountLinkEntity item,
    int familyId,
    AppLocalizations l10n,
  ) async {
    final email = await showLinkAccountEmailSheet(
      context,
      memberName: item.fullName,
    );

    if (email == null || email.trim().isEmpty || !mounted) return;

    context.read<MemberAccountLinksBloc>().add(LinkMemberEmailEvent(
          familyId: familyId,
          memberId: item.memberId,
          email: email,
        ));
  }

  Future<void> _onUnlinkPressed(
    MemberAccountLinkEntity item,
    int familyId,
    AppLocalizations l10n,
  ) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.confirmUnlinkTitle,
      message: l10n.confirmUnlinkMessage(item.fullName),
      confirmLabel: l10n.unlinkButton,
      type: AppDialogType.danger,
      confirmColor: context.error,
    );
    if (confirmed == true && mounted) {
      context.read<MemberAccountLinksBloc>().add(UnlinkMemberAccountEvent(
            familyId: familyId,
            memberId: item.memberId,
          ));
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTIONS: ROLES
  // ══════════════════════════════════════════════════════════════════════════
  void _showRoleSelector(FamilyUserEntity user, int familyId) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: context.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    l10n.roleOfUser(
                        user.userFullName ?? l10n.memberLabel.toLowerCase()),
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                RoleOptionTile(
                  user: user,
                  familyId: familyId,
                  roleValue: 'EDITOR',
                  roleTitle: l10n.roleEditorTitle,
                  roleDesc: l10n.roleEditorDesc,
                  onSelect: () {
                    Navigator.pop(context);
                    context.read<AdminMemberRolesBloc>().add(
                          UpdateAdminMemberRoleEvent(
                            familyId: familyId,
                            userId: user.userId,
                            role: 'EDITOR',
                          ),
                        );
                  },
                ),
                RoleOptionTile(
                  user: user,
                  familyId: familyId,
                  roleValue: 'VIEWER',
                  roleTitle: l10n.memberLabel,
                  roleDesc: l10n.roleViewerDesc,
                  onSelect: () {
                    Navigator.pop(context);
                    context.read<AdminMemberRolesBloc>().add(
                          UpdateAdminMemberRoleEvent(
                            familyId: familyId,
                            userId: user.userId,
                            role: 'VIEWER',
                          ),
                        );
                  },
                ),
                const Divider(),
                TransferOwnershipOptionTile(
                  user: user,
                  familyId: familyId,
                  l10n: l10n,
                  onTransfer: () {
                    Navigator.pop(context);
                    _confirmTransferOwnership(
                      familyId,
                      user.userId,
                      user.userFullName ?? user.userEmail ?? l10n.memberLabel,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmTransferOwnership(
    int familyId,
    int newOwnerUserId,
    String newOwnerName,
  ) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await AppDialog.confirmWithInput(
      context,
      title: l10n.warningDialogTitle,
      message: l10n.warningDialogConfirmMessage(newOwnerName),
      requiredWord: l10n.confirmWord,
      inputInstruction: l10n.typeConfirmToTransfer,
      confirmLabel: l10n.confirmTransferButton,
      cancelLabel: l10n.formCancel,
    );

    if (confirmed == true && mounted) {
      context.read<AdminTransferOwnershipBloc>().add(
            TransferOwnershipEvent(
              familyId: familyId,
              newOwnerUserId: newOwnerUserId,
            ),
          );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: widget.memberId != null
            ? l10n.linkAccountsNodeTitle
            : l10n.linkAndRolesTitle,
      ),
      body: AppBackgroundBody(
        child: SafeArea(
          child: Column(
            children: [
              // ── Tab Bar ──
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.resolve(
                        Colors.black.withValues(alpha: 0.04),
                        Colors.black.withValues(alpha: 0.2),
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: context.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: context.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: context.textSecondary,
                  labelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.link2, size: 15),
                          const SizedBox(width: 6),
                          Text(l10n.tabLinkAccounts),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.shieldCheck, size: 15),
                          const SizedBox(width: 6),
                          Text(l10n.tabMemberRoles),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Tab Views ──
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLinkAccountsTab(context, familyId, l10n),
                    _buildMemberRolesTab(context, familyId, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1: LIÊN KẾT TÀI KHOẢN
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildLinkAccountsTab(
      BuildContext context, int? familyId, AppLocalizations l10n) {
    return BlocConsumer<MemberAccountLinksBloc, MemberAccountLinksState>(
      listener: (context, state) {
        if (state is MemberAccountLinkedSuccess) {
          AppSnackBar.success(
            context,
            state.invited
                ? l10n.inviteSentSuccess(state.email)
                : l10n.linkSuccess(state.email),
          );
          _reloadLinks();
        } else if (state is MemberAccountUnlinkedSuccess) {
          AppSnackBar.success(context, l10n.unlinkSuccess);
          _reloadLinks();
          if (familyId != null) {
            context.read<AdminMemberRolesBloc>().add(
                  LoadAdminMemberRolesEvent(familyId: familyId),
                );
          }
        } else if (state is MemberAccountLinksFailure) {
          AppSnackBar.error(context, state.message);
          _reloadLinks();
        }
      },
      builder: (context, state) {
        if (state is MemberAccountLinksLoading ||
            state is MemberAccountLinksInitial) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: ListPageSkeleton(),
          );
        }

        if (state is MemberAccountLinksFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                state.message,
                style: GoogleFonts.beVietnamPro(color: context.error),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final items = state is MemberAccountLinksLoaded
            ? state.items
            : const <MemberAccountLinkEntity>[];

        var visibleItems = items;
        if (widget.memberId != null) {
          visibleItems =
              items.where((e) => e.memberId == widget.memberId).toList();
        }

        if (_statusFilter == LinkStatusFilter.linked) {
          visibleItems = visibleItems.where((e) => e.isLinked).toList();
        } else if (_statusFilter == LinkStatusFilter.unlinked) {
          visibleItems = visibleItems.where((e) => !e.isLinked).toList();
        }

        final query = _linkSearchController.text.trim().toLowerCase();
        if (query.isNotEmpty) {
          visibleItems = visibleItems
              .where((e) =>
                  e.fullName.toLowerCase().contains(query) ||
                  (e.linkedAccount?.email ?? '')
                      .toLowerCase()
                      .contains(query) ||
                  (e.pendingInvite?.email ?? '').toLowerCase().contains(query))
              .toList();
        }

        // Sắp xếp ưu tiên: Đã liên kết -> Đang chờ xác nhận -> Chưa liên kết
        visibleItems.sort((a, b) {
          int statusPriority(MemberAccountLinkEntity e) {
            if (e.isLinked) return 0;
            if (e.pendingInvite != null) return 1;
            return 2;
          }

          final pA = statusPriority(a);
          final pB = statusPriority(b);
          if (pA != pB) {
            return pA.compareTo(pB);
          }

          final genA = a.generation ?? 999;
          final genB = b.generation ?? 999;
          if (genA != genB) {
            return genA.compareTo(genB);
          }
          return a.fullName.compareTo(b.fullName);
        });

        if (items.isEmpty) {
          return Center(
            child: Text(
              l10n.noMembers,
              style: GoogleFonts.beVietnamPro(
                color: context.textSecondary,
                fontSize: 14,
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: AppSearchBar(
                controller: _linkSearchController,
                hintText: l10n.searchMemberHint,
                onChanged: (_) => setState(() {}),
                trailing: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: PopupMenuButton<LinkStatusFilter>(
                      icon: Icon(
                        LucideIcons.listFilter,
                        size: 20,
                        color: _statusFilter != LinkStatusFilter.all
                            ? context.primary
                            : context.textSecondary,
                      ),
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: context.surface,
                      elevation: 4,
                      onSelected: (val) {
                        setState(() {
                          _statusFilter = val;
                        });
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: LinkStatusFilter.all,
                          height: 38,
                          child: Row(
                            children: [
                              Icon(LucideIcons.filterX,
                                  color: context.textPrimary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                l10n.allLabel,
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 13, color: context.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: LinkStatusFilter.linked,
                          height: 38,
                          child: Text(
                            l10n.linkedLabel,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: _statusFilter == LinkStatusFilter.linked
                                  ? context.primary
                                  : context.textPrimary,
                              fontWeight:
                                  _statusFilter == LinkStatusFilter.linked
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: LinkStatusFilter.unlinked,
                          height: 38,
                          child: Text(
                            l10n.notLinkedLabel,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: _statusFilter == LinkStatusFilter.unlinked
                                  ? context.primary
                                  : context.textPrimary,
                              fontWeight:
                                  _statusFilter == LinkStatusFilter.unlinked
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: visibleItems.isEmpty
                  ? Center(
                      child: Text(
                        l10n.emptyMembers,
                        style: GoogleFonts.beVietnamPro(
                          color: context.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: visibleItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = visibleItems[index];
                        return MemberAccountLinkItemTile(
                          item: item,
                          familyId: familyId,
                          l10n: l10n,
                          onLinkPressed: familyId == null
                              ? null
                              : () => _onLinkPressed(item, familyId, l10n),
                          onUnlinkPressed: familyId == null
                              ? null
                              : () => _onUnlinkPressed(item, familyId, l10n),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // TAB 2: PHÂN QUYỀN THÀNH VIÊN
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildMemberRolesTab(
      BuildContext context, int? familyId, AppLocalizations l10n) {
    final authState = context.watch<AuthBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<AdminMemberRolesBloc, AdminMemberRolesState>(
          listener: (context, state) {
            if (state is AdminMemberRoleUpdatedSuccess) {
              AppSnackBar.success(context, l10n.updateRoleSuccess);
              if (familyId != null) {
                context.read<AdminMemberRolesBloc>().add(
                      LoadAdminMemberRolesEvent(familyId: familyId),
                    );
              }
            } else if (state is AdminMemberRolesFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
        BlocListener<AdminTransferOwnershipBloc, AdminTransferOwnershipState>(
          listener: (context, state) {
            if (state is AdminTransferOwnershipSuccess) {
              AppSnackBar.success(context, l10n.transferSuccess);
              context.read<AuthBloc>().add(AuthProfileRefreshSilent());
              if (familyId != null) {
                context.read<AdminMemberRolesBloc>().add(
                      LoadAdminMemberRolesEvent(familyId: familyId),
                    );
              }
            } else if (state is AdminTransferOwnershipFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<AdminMemberRolesBloc, AdminMemberRolesState>(
        builder: (context, state) {
          if (state is AdminMemberRolesLoading ||
              state is AdminMemberRolesInitial) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: ListPageSkeleton(),
            );
          }

          if (state is AdminMemberRolesFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  state.message,
                  style: GoogleFonts.beVietnamPro(color: context.error),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          List<FamilyUserEntity> members = [];
          if (state is AdminMemberRolesLoaded) {
            members = state.members;
          } else {
            final blocState = context.read<AdminMemberRolesBloc>().state;
            if (blocState is AdminMemberRolesLoaded) {
              members = blocState.members;
            }
          }

          final allMembers = members;
          final query = _roleSearchController.text.trim().toLowerCase();
          if (query.isNotEmpty) {
            members = members
                .where((m) =>
                    (m.userFullName ?? '').toLowerCase().contains(query) ||
                    (m.userEmail ?? '').toLowerCase().contains(query))
                .toList();
          }

          if (_roleFilter != null) {
            members = members.where((m) {
              final mappedRole = AdminDashboardPage.roleLabel(m.role, context);
              final filterRole =
                  AdminDashboardPage.roleLabel(_roleFilter!, context);
              return mappedRole == filterRole;
            }).toList();
          }

          if (allMembers.isEmpty) {
            return Center(
              child: Text(
                l10n.noMembers,
                style: GoogleFonts.beVietnamPro(
                  color: context.textSecondary,
                  fontSize: 14,
                ),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: AppSearchBar(
                  controller: _roleSearchController,
                  hintText: l10n.searchMemberHint,
                  onChanged: (_) => setState(() {}),
                  trailing: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          LucideIcons.listFilter,
                          size: 20,
                          color: _roleFilter != null
                              ? context.primary
                              : context.textSecondary,
                        ),
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: context.surface,
                        elevation: 4,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'clear_all',
                            height: 38,
                            child: Row(
                              children: [
                                Icon(LucideIcons.filterX,
                                    color: context.textPrimary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.allLabel,
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 13, color: context.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          ...['BRANCH_ADMIN', 'EDITOR', 'VIEWER'].map((role) {
                            return PopupMenuItem(
                              value: role,
                              height: 38,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AdminDashboardPage.roleColor(
                                          role, context),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AdminDashboardPage.roleLabel(role, context),
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 13,
                                      color: _roleFilter == role
                                          ? context.primary
                                          : context.textPrimary,
                                      fontWeight: _roleFilter == role
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onSelected: (value) {
                          if (value == 'clear_all') {
                            setState(() {
                              _roleFilter = null;
                            });
                          } else {
                            setState(() {
                              _roleFilter = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: members.isEmpty
                    ? Center(
                        child: Text(
                          l10n.emptyMembers,
                          style: GoogleFonts.beVietnamPro(
                            color: context.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: members.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final user = members[index];
                          final role = user.role;

                          return Container(
                            decoration: BoxDecoration(
                              color: context.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: context.accent.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: familyId == null
                                    ? null
                                    : () {
                                        final currentUserId =
                                            authState is Authenticated
                                                ? authState.user.id
                                                : null;
                                        if (user.userId == currentUserId) {
                                          AppSnackBar.warning(
                                            context,
                                            l10n.cannotSelfChange,
                                          );
                                        } else {
                                          _showRoleSelector(user, familyId);
                                        }
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      AppAvatar(
                                        avatarUrl: user.userAvatarUrl,
                                        fullName: user.userFullName,
                                        radius: 22,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.userFullName ??
                                                  l10n.memberLabel,
                                              style: GoogleFonts.beVietnamPro(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: context.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              user.userEmail ?? l10n.noEmail,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: context.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AdminDashboardPage.roleColor(
                                                  role, context)
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          AdminDashboardPage.roleLabel(
                                              role, context),
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AdminDashboardPage.roleColor(
                                                role, context),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        LucideIcons.chevronRight,
                                        color: context.textSecondary
                                            .withValues(alpha: 0.5),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

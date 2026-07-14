import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/domain/entity/member_entity.dart';
import '../../../../../core/domain/entity/branch_entity.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';
import '../../../../auth/auth.dart';
import '../../../../family_tree/family_tree.dart';
import 'pages/admin_member_form_page.dart';
import 'pages/admin_branch_form_page.dart';
import '../../bloc/admin_member_form/admin_member_form_bloc.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';
import '../../bloc/admin_branch_form/admin_branch_form_bloc.dart';
import '../../widgets/admin_dashboard/quick_stats_row.dart';
import '../../widgets/admin_dashboard/member_item_widget.dart';
import '../../widgets/admin_dashboard/branch_item_widget.dart';
import '../../widgets/admin_dashboard/pending_request_item_widget.dart';

enum AdminDashboardTab { members, branches, pending }

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  /// Role label & color helper
  static String roleLabel(String role, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (role.toUpperCase()) {
      case 'OWNER':
        return l10n.roleOwner;
      case 'BRANCH_ADMIN':
        return l10n.roleBranchAdmin;
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
        return AppColors.crimson;
      case 'BRANCH_ADMIN':
        return Colors.orange.shade800;
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
  int _memberLimit = 5;
  int _branchLimit = 5;
  int _pendingLimit = 5;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

    // Dispatch events to fetch latest data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTree();
      _loadPendingRequests();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
      _memberLimit = 5;
      _branchLimit = 5;
      _pendingLimit = 5;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      setState(() {
        if (_selectedTab == AdminDashboardTab.members) {
          _memberLimit += 5;
        } else if (_selectedTab == AdminDashboardTab.branches) {
          _branchLimit += 5;
        } else if (_selectedTab == AdminDashboardTab.pending) {
          _pendingLimit += 5;
        }
      });
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
    if (familyId != null) {
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
    final role = user?.role ?? 'VIEWER';
    final isEditor = role.toUpperCase() == 'EDITOR';
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = 190 + topPadding;

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
        backgroundColor: context.surface,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(
                  context, user, headerHeight, familyName, inviteCode),
            ),
            Positioned(
              top: headerHeight + 45,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
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
            Positioned(
              top: headerHeight - 45,
              left: 0,
              right: 0,
              child: QuickStatsRow(
                showPending: !isEditor,
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
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user, double height,
      String familyName, String inviteCode) {
    return Container(
      height: height,
      width: double.infinity,
      color: context.appBarBg,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wood_dragon.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: context.appBarBg),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            familyName.toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.accent,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      if (user != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.role == 'OWNER'
                                ? context.primary
                                : AdminDashboardPage.roleColor(user.role),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            AdminDashboardPage.roleLabel(user.role, context),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInviteCodeCard(context, inviteCode),
                ],
              ),
            ),
          ),
        ],
      ),
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
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final role = user?.role ?? 'VIEWER';
    final isEditor = role.toUpperCase() == 'EDITOR';

    switch (_selectedTab) {
      case AdminDashboardTab.members:
        if (userTreeState is FamilyTreeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: AppLoading(size: 80),
            ),
          );
        }
        final filteredMembers = members
            .where((m) =>
                m.fullName.toLowerCase().contains(_searchQuery) ||
                (m.branchName != null &&
                    m.branchName!.toLowerCase().contains(_searchQuery)))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              l10n.memberListTitle,
              addLabel: l10n.addMemberLabel,
              onAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminMemberFormPage(),
                  ),
                );
              },
            ),
            _buildSearchBar(l10n.searchMembersHint),
            if (filteredMembers.isEmpty)
              _buildEmptyWidget(l10n.emptyMembers)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: filteredMembers.length > _memberLimit
                      ? _memberLimit
                      : filteredMembers.length,
                  itemBuilder: (context, index) {
                    final member = filteredMembers[index];
                    return MemberItemWidget(
                      member: member,
                      allMembers: members,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminMemberFormPage(memberId: member.id),
                          ),
                        );
                      },
                      onDelete: isEditor
                          ? null
                          : () => _showDeleteConfirmation(context, member),
                    );
                  },
                ),
              ),
          ],
        );

      case AdminDashboardTab.branches:
        if (userTreeState is FamilyTreeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: AppLoading(size: 80),
            ),
          );
        }
        final filteredBranches = branches
            .where((b) =>
                b.name.toLowerCase().contains(_searchQuery) ||
                (b.founderName != null &&
                    b.founderName!.toLowerCase().contains(_searchQuery)))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              l10n.branchListTitle,
              addLabel: l10n.addBranchLabel,
              onAdd: () => _openBranchForm(context),
            ),
            _buildSearchBar(l10n.searchBranchesHint),
            if (filteredBranches.isEmpty)
              _buildEmptyWidget(l10n.emptyBranches)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: filteredBranches.length > _branchLimit
                      ? _branchLimit
                      : filteredBranches.length,
                  itemBuilder: (context, index) {
                    final branch = filteredBranches[index];
                    return BranchItemWidget(
                      branch: branch,
                      memberCount:
                          members.where((m) => m.branchId == branch.id).length,
                      onEdit: () => _openBranchForm(context, branch: branch),
                      onDelete: isEditor
                          ? null
                          : () =>
                              _showDeleteBranchConfirmation(context, branch),
                    );
                  },
                ),
              ),
          ],
        );

      case AdminDashboardTab.pending:
        if (isEditor) {
          return const SizedBox.shrink();
        }
        if (pendingState is AdminPendingRequestsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: AppLoading(size: 80),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(l10n.pendingRequestTitle),
            if (requests.isEmpty)
              _buildEmptyWidget(l10n.emptyPendingRequests)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: requests.length > _pendingLimit
                      ? _pendingLimit
                      : requests.length,
                  itemBuilder: (context, index) =>
                      PendingRequestItemWidget(request: requests[index]),
                ),
              ),
          ],
        );
    }
  }

  Widget _buildInviteCodeCard(BuildContext context, String inviteCode) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(LucideIcons.qrCode, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.inviteCodeSectionLabel,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  inviteCode,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.copy, size: 18, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: inviteCode));
              AppSnackBar.success(context, l10n.inviteCodeCopied(inviteCode));
            },
            tooltip: l10n.copyCodeTooltip,
          ),
          const SizedBox(width: 4),
          AppButton(
            label: l10n.qrCodeTooltip,
            onPressed: () => _showQrDialog(context, inviteCode),
            prefixIcon: const Icon(LucideIcons.maximize2, size: 10),
            variant: AppButtonVariant.outline,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _captureQr(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  void _showQrDialog(BuildContext context, String code) {
    final qrKey = GlobalKey();
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return Dialog(
          backgroundColor: ctx.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              Container(
                width: 340,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.qrDialogTitle,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        color: ctx.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RepaintBoundary(
                      key: qrKey,
                      child: Container(
                        width: 260,
                        height: 260,
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: QrImageView(
                          data: code,
                          version: QrVersions.auto,
                          size: 260.0,
                          gapless: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: l10n.downloadLabel,
                            onPressed: () async {
                              final bytes = await _captureQr(qrKey);
                              if (bytes == null) return;
                              try {
                                await Gal.putImageBytes(bytes,
                                    name: 'qr_$code');
                                if (ctx.mounted) {
                                  AppSnackBar.success(ctx, l10n.qrSaved);
                                }
                              } catch (e) {
                                if (ctx.mounted) {
                                  AppSnackBar.error(ctx, l10n.qrSaveError);
                                }
                              }
                            },
                            prefixIcon:
                                const Icon(LucideIcons.download, size: 16),
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.small,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            label: l10n.shareLabel,
                            onPressed: () async {
                              final bytes = await _captureQr(qrKey);
                              if (bytes == null) return;
                              final dir = await getTemporaryDirectory();
                              final file = File('${dir.path}/qr_$code.png');
                              await file.writeAsBytes(bytes);
                              await Share.shareXFiles(
                                [XFile(file.path, mimeType: 'image/png')],
                                text: '${l10n.inviteCodeSectionLabel}: $code',
                              );
                            },
                            prefixIcon:
                                const Icon(LucideIcons.share2, size: 16),
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.small,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                  icon: Icon(
                    LucideIcons.x,
                    size: 20,
                    color: ctx.textSecondary,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title,
      {VoidCallback? onAdd, String? addLabel}) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          if (onAdd != null)
            addLabel == l10n.addMemberLabel
                ? IconButton(
                    onPressed: onAdd,
                    icon: const Icon(LucideIcons.userPlus,
                        size: 16, color: Colors.black),
                    style: IconButton.styleFrom(
                      backgroundColor: context.accent,
                      padding: const EdgeInsets.all(8),
                    ),
                    tooltip: addLabel,
                  )
                : addLabel == l10n.addBranchLabel
                    ? IconButton(
                        onPressed: onAdd,
                        icon: const Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 3, bottom: 3),
                              child: Icon(LucideIcons.gitBranch,
                                  size: 14, color: Colors.black),
                            ),
                            Positioned(
                              bottom: -1,
                              right: -1,
                              child: Icon(Icons.add,
                                  size: 9,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: context.accent,
                          padding: const EdgeInsets.all(8),
                        ),
                        tooltip: addLabel,
                      )
                    : TextButton.icon(
                        onPressed: onAdd,
                        icon: Icon(
                          addLabel == l10n.viewAllLabel
                              ? LucideIcons.eye
                              : LucideIcons.plus,
                          size: 14,
                          color: Colors.black,
                        ),
                        label: Text(
                          addLabel ?? l10n.addNewLabel,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          backgroundColor: context.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MemberEntity member) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: ctx.surface,
          title: Text(
            l10n.deleteMemberTitle,
            style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold, color: ctx.textPrimary),
          ),
          content: Text(
            l10n.deleteMemberMessage(member.fullName),
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
                    .read<AdminMemberFormBloc>()
                    .add(DeleteAdminMemberFormEvent(member.id));
              },
              variant: AppButtonVariant.danger,
              size: AppButtonSize.small,
            ),
          ],
        );
      },
    );
  }

  void _openBranchForm(BuildContext context, {BranchEntity? branch}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminBranchFormPage(branch: branch),
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

  Widget _buildSearchBar(String hintText) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(fontSize: 13, color: context.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary.withValues(alpha: 0.6)),
          prefixIcon:
              Icon(LucideIcons.search, size: 18, color: context.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(LucideIcons.x,
                      size: 16, color: context.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
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

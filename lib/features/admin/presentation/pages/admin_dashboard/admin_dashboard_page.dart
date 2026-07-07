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
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/domain/entity/member_entity.dart';
import '../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../core/domain/entity/branch_entity.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';
import '../../../../auth/auth.dart';
import '../../../../user/user.dart';
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
  static String roleLabel(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
        return 'TRƯỞNG TỘC';
      case 'BRANCH_ADMIN':
        return 'TRƯỞNG CHI';
      case 'EDITOR':
        return 'BIÊN TẬP VIÊN';
      case 'VIEWER':
        return 'THÀNH VIÊN';
      default:
        return 'THÀNH VIÊN';
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
      context.read<UserTreeBloc>().add(UserTreeLoadEvent(familyId: familyId));
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
    final role = user?.role ?? 'VIEWER';
    final isEditor = role.toUpperCase() == 'EDITOR';
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = 180 + topPadding;

    final pendingState = context.watch<AdminPendingRequestsBloc>().state;

    // Resolve family name & invite code dynamically
    String familyName = 'Gia Tộc';
    String inviteCode = '';
    if (pendingState is AdminPendingRequestsLoaded &&
        pendingState.family != null) {
      familyName = pendingState.family!.name;
      inviteCode = pendingState.family!.inviteCode;
    } else if (user != null) {
      final userTreeState = context.watch<UserTreeBloc>().state;
      if (userTreeState is UserTreeLoaded && userTreeState.members.isNotEmpty) {
        final rootMembers = userTreeState.members.where(
          (m) => m.generation == 1 || m.parentId == null,
        );
        final rootMember = rootMembers.isNotEmpty
            ? rootMembers.first
            : userTreeState.members.first;
        final parts = rootMember.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = '${parts.first} Gia Tộc';
        }
      } else {
        final parts = user.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = '${parts.first} Gia Tộc';
        }
      }
    }

    // Connect real data counts
    final userTreeState = context.watch<UserTreeBloc>().state;
    String memberCount = '--';
    String branchCount = '--';
    List<MemberEntity> allMembers = [];
    List<BranchEntity> allBranches = [];
    if (userTreeState is UserTreeLoaded) {
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
            if (state is AdminRequestApprovedSuccess) {
              AppSnackBar.success(context, 'Đã phê duyệt yêu cầu thành công!');
              _loadPendingRequests();
              _loadTree();
            } else if (state is AdminRequestRejectedSuccess) {
              AppSnackBar.success(context, 'Đã từ chối yêu cầu thành công!');
              _loadPendingRequests();
            } else if (state is AdminPendingRequestsFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
        BlocListener<AdminMemberFormBloc, AdminMemberFormState>(
          listener: (context, state) {
            if (state is AdminMemberFormSuccess) {
              if (state.isDeleted) {
                AppSnackBar.success(context, 'Đã xoá thành viên thành công!');
              } else {
                AppSnackBar.success(context, 'Đã lưu thông tin thành viên!');
              }
              _loadTree();
            } else if (state is AdminMemberFormError) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
        BlocListener<AdminBranchFormBloc, AdminBranchFormState>(
          listener: (context, state) {
            if (state is AdminBranchFormSuccess) {
              if (state.isDeleted) {
                AppSnackBar.success(context, 'Đã xoá chi tộc thành công!');
              } else {
                AppSnackBar.success(context, 'Đã lưu thông tin chi tộc!');
              }
              _loadTree();
            } else if (state is AdminBranchFormError) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeader(context, user, headerHeight, familyName),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -45),
              child: _buildInviteCodeCard(
                context,
                inviteCode,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -25),
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
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user, double height,
      String familyName) {
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
                          Text(
                            'BẢNG QUẢN TRỊ',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      if (user != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AdminDashboardPage.roleColor(user.role),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: context.accent.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            AdminDashboardPage.roleLabel(user.role),
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
                  const SizedBox(height: 12),
                  Builder(builder: (context) {
                    final now = DateTime.now();
                    final weekdays = [
                      'Chủ Nhật',
                      'Thứ Hai',
                      'Thứ Ba',
                      'Thứ Tư',
                      'Thứ Năm',
                      'Thứ Sáu',
                      'Thứ Bảy'
                    ];
                    final weekday = weekdays[now.weekday % 7];
                    final day = now.day.toString().padLeft(2, '0');
                    final month = now.month.toString().padLeft(2, '0');
                    final year = now.year.toString();
                    final solarDateString = '$weekday, $day/$month/$year';
                    final lunarDateString =
                        LunarDateHelper.getLunarDateString(now);

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.calendar,
                              color: context.accent, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            solarDateString,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '|',
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.3),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            lunarDateString,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection({
    required UserTreeState userTreeState,
    required AdminPendingRequestsState pendingState,
    required List<MemberEntity> members,
    required List<BranchEntity> branches,
    required List<FamilyUserEntity> requests,
  }) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final role = user?.role ?? 'VIEWER';
    final isEditor = role.toUpperCase() == 'EDITOR';

    switch (_selectedTab) {
      case AdminDashboardTab.members:
        if (userTreeState is UserTreeLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: context.primary),
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
              'DANH SÁCH THÀNH VIÊN',
              addLabel: 'Thêm thành viên',
              onAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminMemberFormPage(),
                  ),
                );
              },
            ),
            _buildSearchBar('Tìm kiếm thành viên hoặc chi tộc...'),
            if (filteredMembers.isEmpty)
              _buildEmptyWidget('Không tìm thấy thành viên phù hợp')
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
        if (userTreeState is UserTreeLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: context.primary),
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
              'DANH SÁCH CHI TỘC',
              addLabel: 'Thêm chi tộc',
              onAdd: () => _openBranchForm(context),
            ),
            _buildSearchBar('Tìm kiếm chi tộc...'),
            if (filteredBranches.isEmpty)
              _buildEmptyWidget('Không tìm thấy chi tộc phù hợp')
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: context.primary),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('YÊU CẦU CHỜ DUYỆT'),
            if (requests.isEmpty)
              _buildEmptyWidget('Không có yêu cầu tham gia nào đang chờ duyệt')
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accent.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.02),
              Colors.transparent,
            ),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.textPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Icon(LucideIcons.qrCode, color: context.textPrimary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MÃ THAM GIA GIA TỘC',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: context.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  inviteCode,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.copy, size: 18, color: context.textPrimary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: inviteCode));
              AppSnackBar.success(context, 'Đã sao chép mã mời: $inviteCode');
            },
            tooltip: 'Sao chép mã',
          ),
          const SizedBox(width: 4),
          ElevatedButton.icon(
            onPressed: () => _showQrDialog(context, inviteCode),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: context.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: const Icon(LucideIcons.maximize2, size: 10),
            label: Text(
              'Mã QR',
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
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
      builder: (ctx) => Dialog(
        backgroundColor: ctx.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Container(
              width: 280,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mã QR Gia Tộc',
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
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: QrImageView(
                        data: code,
                        version: QrVersions.auto,
                        size: 200.0,
                        gapless: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final bytes = await _captureQr(qrKey);
                            if (bytes == null) return;
                            try {
                              await Gal.putImageBytes(bytes, name: 'qr_$code');
                              if (ctx.mounted) {
                                AppSnackBar.success(
                                    ctx, 'Đã lưu QR vào thư viện ảnh!');
                              }
                            } catch (e) {
                              if (ctx.mounted) {
                                AppSnackBar.error(ctx,
                                    'Không thể lưu ảnh. Vui lòng cấp quyền thư viện ảnh.');
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ctx.textPrimary,
                            side: BorderSide(color: ctx.textPrimary),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(LucideIcons.download, size: 16),
                          label: Text('Tải xuống',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final bytes = await _captureQr(qrKey);
                            if (bytes == null) return;
                            final dir = await getTemporaryDirectory();
                            final file = File('${dir.path}/qr_$code.png');
                            await file.writeAsBytes(bytes);
                            await Share.shareXFiles(
                              [XFile(file.path, mimeType: 'image/png')],
                              text: 'Mã tham gia gia tộc: $code',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctx.primary,
                            foregroundColor: ctx.textOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(LucideIcons.share2, size: 16),
                          label: Text('Chia sẻ',
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
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
      ),
    );
  }

  Widget _buildSectionHeader(String title,
      {VoidCallback? onAdd, String? addLabel}) {
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
            TextButton.icon(
              onPressed: onAdd,
              icon: Icon(
                addLabel == 'Xem tất cả' ? LucideIcons.eye : LucideIcons.plus,
                size: 14,
                color: context.accent,
              ),
              label: Text(
                addLabel ?? 'Thêm mới',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.accent,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                backgroundColor: context.accent.withValues(alpha: 0.85),
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
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(
          'Xác nhận xoá',
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: ctx.textPrimary),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xoá thành viên ${member.fullName} khỏi gia phả không?',
          style: GoogleFonts.beVietnamPro(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy',
                style:
                    GoogleFonts.beVietnamPro(color: ctx.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<AdminMemberFormBloc>()
                  .add(DeleteAdminMemberFormEvent(member.id));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            child: const Text('Xoá'),
          ),
        ],
      ),
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
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(
          'Xác nhận xoá chi tộc',
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: ctx.textPrimary),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xoá chi tộc ${branch.name}? Tất cả thành viên thuộc chi này sẽ mất liên kết chi tộc.',
          style: GoogleFonts.beVietnamPro(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy',
                style:
                    GoogleFonts.beVietnamPro(color: ctx.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<AdminBranchFormBloc>()
                  .add(DeleteAdminBranchFormEvent(branch.id));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(String hintText) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.02),
              Colors.transparent,
            ),
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
          hintStyle:
              GoogleFonts.inter(fontSize: 13, color: context.textSecondary.withValues(alpha: 0.6)),
          prefixIcon:
              Icon(LucideIcons.search, size: 18, color: context.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(LucideIcons.x, size: 16, color: context.textSecondary),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.accent.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.folderOpen, size: 40, color: context.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

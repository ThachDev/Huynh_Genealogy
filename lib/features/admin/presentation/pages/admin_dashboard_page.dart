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

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/domain/entity/member_entity.dart';
import '../../../../core/domain/entity/branch_entity.dart';
import '../../../../core/domain/entity/family_user_entity.dart';
import '../../../auth/auth.dart';
import '../../../user/user.dart';
import 'admin_member_form_page.dart';
import '../bloc/admin_member_form/admin_member_form_bloc.dart';
import '../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';

enum _DashboardTab { members, branches, pending }

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  /// Role label & color helper
  static String roleLabel(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
        return 'TRƯỞNG TỘC';
      case 'BRANCH_ADMIN':
        return 'QUẢN TRỊ CHI';
      case 'EDITOR':
        return 'BIÊN SOẠN';
      default:
        return 'QUẢN TRỊ';
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
  _DashboardTab _selectedTab = _DashboardTab.members;
  bool _isEditMode = false;
  bool _isDeleteMode = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Dispatch events to fetch latest data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserTreeBloc>().add(UserTreeLoadEvent());
      _loadPendingRequests();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  void _loadPendingRequests() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.familyId != null) {
      context.read<AdminPendingRequestsBloc>().add(
            LoadAdminPendingRequestsEvent(familyId: authState.user.familyId!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = 180 + topPadding;

    // Resolve family name dynamically
    String familyName = 'Gia Tộc';
    if (user != null) {
      final userTreeState = context.watch<UserTreeBloc>().state;
      if (userTreeState is UserTreeLoaded && userTreeState.members.isNotEmpty) {
        final rootMembers = userTreeState.members.where(
          (m) => m.generation == 1 || m.parentId == null,
        );
        final rootMember = rootMembers.isNotEmpty ? rootMembers.first : userTreeState.members.first;
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

    final pendingState = context.watch<AdminPendingRequestsBloc>().state;
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
              context.read<UserTreeBloc>().add(UserTreeLoadEvent());
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
              context.read<UserTreeBloc>().add(UserTreeLoadEvent());
            } else if (state is AdminMemberFormError) {
              AppSnackBar.error(context, state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        body: SingleChildScrollView(
          child: Column(
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
                  user != null ? 'HGT-${user.familyId ?? 2026}' : 'HGT-2026',
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -25),
                child: _QuickStatsRow(
                  memberCount: memberCount,
                  branchCount: branchCount,
                  pendingCount: pendingCount,
                  selectedTab: _selectedTab,
                  onTabChanged: (tab) {
                    setState(() {
                      _selectedTab = tab;
                      _searchController.clear();
                      _isEditMode = false;
                      _isDeleteMode = false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildContentSection(
                userTreeState: userTreeState,
                pendingState: pendingState,
                members: allMembers,
                branches: allBranches,
                requests: pendingRequests,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user, double height,
      String familyName) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.wood,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wood_dragon.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.wood),
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
                              color: AppColors.gold,
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
                                color: AppColors.gold.withValues(alpha: 0.4)),
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
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar,
                          color: AppColors.gold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Thứ Sáu, 26/06/2026 • 12/05 Âm Lịch',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '“Cây có gốc mới nở cành xanh lá, nước có nguồn mới bể rộng sông sâu”',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.white54,
                    ),
                  ),
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
    switch (_selectedTab) {
      case _DashboardTab.members:
        if (userTreeState is UserTreeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.wood),
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
              onAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminMemberFormPage(),
                  ),
                );
              },
              onEdit: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                  if (_isEditMode) _isDeleteMode = false;
                });
              },
              onDelete: () {
                setState(() {
                  _isDeleteMode = !_isDeleteMode;
                  if (_isDeleteMode) _isEditMode = false;
                });
              },
            ),
            _buildSearchBar('Tìm kiếm thành viên hoặc chi tộc...'),
            if (filteredMembers.isEmpty)
              _buildEmptyWidget('Không tìm thấy thành viên phù hợp')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) =>
                    _buildMemberItem(filteredMembers[index]),
              ),
          ],
        );

      case _DashboardTab.branches:
        if (userTreeState is UserTreeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.wood),
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
              onAdd: () => _showBranchDialog(context),
              onEdit: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                  if (_isEditMode) _isDeleteMode = false;
                });
              },
              onDelete: () {
                setState(() {
                  _isDeleteMode = !_isDeleteMode;
                  if (_isDeleteMode) _isEditMode = false;
                });
              },
            ),
            _buildSearchBar('Tìm kiếm chi tộc...'),
            if (filteredBranches.isEmpty)
              _buildEmptyWidget('Không tìm thấy chi tộc phù hợp')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredBranches.length,
                itemBuilder: (context, index) =>
                    _buildBranchItem(filteredBranches[index], members),
              ),
          ],
        );

      case _DashboardTab.pending:
        if (pendingState is AdminPendingRequestsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.wood),
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                itemBuilder: (context, index) =>
                    _buildPendingRequestItem(requests[index]),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              color: AppColors.wood.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(LucideIcons.qrCode, color: AppColors.wood, size: 22),
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
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  inviteCode,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.wood,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.copy, size: 18, color: AppColors.wood),
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
              backgroundColor: AppColors.wood,
              foregroundColor: Colors.white,
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
        backgroundColor: AppColors.parchment,
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
                      color: AppColors.wood,
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
                            foregroundColor: AppColors.wood,
                            side: const BorderSide(color: AppColors.wood),
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
                            backgroundColor: AppColors.wood,
                            foregroundColor: Colors.white,
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
                icon: const Icon(
                  LucideIcons.x,
                  size: 20,
                  color: AppColors.textSecondary,
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
      {VoidCallback? onAdd, VoidCallback? onEdit, VoidCallback? onDelete}) {
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
              color: AppColors.wood,
              letterSpacing: 0.5,
            ),
          ),
          if (onAdd != null || onEdit != null || onDelete != null)
            Row(
              children: [
                if (onAdd != null)
                  IconButton(
                    icon: const Icon(LucideIcons.plusCircle,
                        color: AppColors.wood, size: 20),
                    onPressed: onAdd,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Thêm',
                  ),
                if (onEdit != null) ...[
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      _isEditMode ? LucideIcons.check : LucideIcons.edit3,
                      color: _isEditMode ? Colors.green : AppColors.wood,
                      size: 20,
                    ),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Sửa',
                  ),
                ],
                if (onDelete != null) ...[
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      _isDeleteMode ? LucideIcons.check : LucideIcons.trash2,
                      color: _isDeleteMode ? Colors.red : AppColors.error,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Xoá',
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MemberEntity member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          'Xác nhận xoá',
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: AppColors.wood),
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
                    GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
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

  void _showBranchDialog(BuildContext context, {BranchEntity? branch}) {
    final nameController = TextEditingController(text: branch?.name ?? '');
    final founderController =
        TextEditingController(text: branch?.founderName ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          branch == null ? 'Thêm Chi Tộc' : 'Chỉnh Sửa Chi Tộc',
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: AppColors.wood),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên chi tộc'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: founderController,
              decoration:
                  const InputDecoration(labelText: 'Tên tổ chi / Sáng lập'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy',
                style:
                    GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                AppSnackBar.error(ctx, 'Vui lòng nhập tên chi tộc');
                return;
              }
              Navigator.pop(ctx);
              AppSnackBar.success(
                  context,
                  branch == null
                      ? 'Đã thêm chi tộc mới thành công!'
                      : 'Đã cập nhật thông tin chi tộc!');
              context.read<UserTreeBloc>().add(UserTreeLoadEvent());
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wood, foregroundColor: Colors.white),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteBranchConfirmation(
      BuildContext context, BranchEntity branch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          'Xác nhận xoá chi tộc',
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: AppColors.wood),
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
                    GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AppSnackBar.success(context, 'Đã xoá chi tộc thành công!');
              context.read<UserTreeBloc>().add(UserTreeLoadEvent());
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
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade400),
          prefixIcon:
              const Icon(LucideIcons.search, size: 18, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.folderOpen, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(MemberEntity member) {
    final String genderText = member.gender == Gender.male ? 'Nam' : 'Nữ';
    final String aliveText = member.isAlive ? 'Còn sống' : 'Đã mất';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: member.gender == Gender.male
                ? Colors.blue.shade50
                : Colors.pink.shade50,
            backgroundImage: member.avatarUrl != null
                ? NetworkImage(member.avatarUrl!)
                : null,
            child: member.avatarUrl == null
                ? Icon(
                    member.gender == Gender.male
                        ? LucideIcons.user
                        : LucideIcons.user2,
                    color: member.gender == Gender.male
                        ? Colors.blue
                        : Colors.pink,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Đời thứ ${member.generation ?? "?"} • $genderText • $aliveText',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (member.branchName != null &&
                    member.branchName!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Chi tộc: ${member.branchName}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.wood,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isEditMode)
            IconButton(
              icon: const Icon(LucideIcons.edit, color: Colors.green, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminMemberFormPage(memberId: member.id),
                  ),
                );
              },
            ),
          if (_isDeleteMode)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
              onPressed: () {
                _showDeleteConfirmation(context, member);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBranchItem(BranchEntity branch, List<MemberEntity> members) {
    final memberCount = members.where((m) => m.branchId == branch.id).length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.wood.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.gitBranch,
                color: AppColors.wood, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (branch.founderName != null &&
                    branch.founderName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Đời tổ/Sáng lập: ${branch.founderName}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.users,
                        size: 12, color: Colors.blueGrey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      '$memberCount thành viên',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isEditMode)
            IconButton(
              icon: const Icon(LucideIcons.edit, color: Colors.green, size: 20),
              onPressed: () {
                _showBranchDialog(context, branch: branch);
              },
            ),
          if (_isDeleteMode)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
              onPressed: () {
                _showDeleteBranchConfirmation(context, branch);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestItem(FamilyUserEntity request) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.wood.withValues(alpha: 0.12),
                backgroundImage: request.userAvatarUrl != null
                    ? NetworkImage(request.userAvatarUrl!)
                    : null,
                child: request.userAvatarUrl == null
                    ? const Icon(LucideIcons.user, color: AppColors.wood)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.userFullName ?? 'Người dùng ẩn danh',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      request.userEmail ?? 'Không có email',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.shieldAlert,
                    size: 12,
                    color: AppColors.gold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Vai trò: ',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppColors.wood.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      request.role.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.wood,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AdminPendingRequestsBloc>().add(
                        ApproveAdminRequestEvent(requestId: request.id),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.crimson,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Phê duyệt',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick Stats Row ────────────────────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  final String memberCount;
  final String branchCount;
  final String pendingCount;
  final _DashboardTab selectedTab;
  final ValueChanged<_DashboardTab> onTabChanged;

  const _QuickStatsRow({
    required this.memberCount,
    required this.branchCount,
    required this.pendingCount,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.wood,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: LucideIcons.users,
              label: 'Thành viên',
              value: memberCount,
              isSelected: selectedTab == _DashboardTab.members,
              onTap: () => onTabChanged(_DashboardTab.members),
            ),
          ),
          Container(width: 1, height: 32, color: Colors.white24),
          Expanded(
            child: _StatItem(
              icon: LucideIcons.gitBranch,
              label: 'Chi tộc',
              value: branchCount,
              isSelected: selectedTab == _DashboardTab.branches,
              onTap: () => onTabChanged(_DashboardTab.branches),
            ),
          ),
          Container(width: 1, height: 32, color: Colors.white24),
          Expanded(
            child: _StatItem(
              icon: LucideIcons.clock,
              label: 'Chờ duyệt',
              value: pendingCount,
              valueColor: Colors.orange.shade300,
              isSelected: selectedTab == _DashboardTab.pending,
              onTap: () => onTabChanged(_DashboardTab.pending),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.gold.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      color: isSelected ? AppColors.gold : Colors.white70,
                      size: 14),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.gold
                      : (valueColor ?? Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

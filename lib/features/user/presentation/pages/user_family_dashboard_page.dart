import 'dart:io';
import 'dart:ui' as ui;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../family_tree/family_tree.dart';
import '../../../auth/auth.dart';
import '../../../events/events.dart';
import '../../../../core/widgets/widgets.dart';

import '../widgets/user_notifications_widget.dart';
import '../widgets/user_quick_actions_widget.dart';
import 'user_branch_list_page.dart';
import '../../../admin/presentation/widgets/admin_dashboard/member_item_widget.dart';
import 'user_anniversary_list_page.dart';
import '../../domain/services/anniversary_calculator.dart';
import '../../domain/services/member_filter.dart';
import '../../domain/services/announcement_service.dart';

class UserFamilyDashboardPage extends StatefulWidget {
  const UserFamilyDashboardPage({super.key});

  @override
  State<UserFamilyDashboardPage> createState() =>
      _UserFamilyDashboardPageState();
}

class _UserFamilyDashboardPageState extends State<UserFamilyDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _memberLimit = 50;
  MemberFilter _filter = const MemberFilter();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    _loadEventsData();
  }

  void _loadEventsData() {
    final familyId = _familyId();
    if (familyId != null) {
      context.read<EventsBloc>().add(LoadEventsEvent(familyId: familyId));
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filter = _filter.copyWith(
          searchQuery: _searchController.text.trim().toLowerCase());
      _memberLimit = 50;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _memberLimit += 50;
      });
    }
  }

  int? _familyId() {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.familyId : null;
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
        final l10n = AppLocalizations.of(ctx);
        return Dialog(
          backgroundColor: ctx.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Container(
                width: 340,
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.qrDialogTitle,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        color: ctx.textPrimary,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RepaintBoundary(
                      key: qrKey,
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QrImageView(
                              data: code,
                              size: 228.0,
                              gapless: false,
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${l10n.clanCodeLabel} ',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                  TextSpan(
                                    text: code,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E1E1E),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: l10n.downloadLabel,
                            fontSize: 12.5,
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
                                const Icon(LucideIcons.download, size: 15),
                            variant: AppButtonVariant.secondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppButton(
                            label: l10n.shareLabel,
                            fontSize: 12.5,
                            onPressed: () async {
                              final bytes = await _captureQr(qrKey);
                              if (bytes == null) return;
                              try {
                                final tempDir = await getTemporaryDirectory();
                                final file = await File(
                                  '${tempDir.path}/qr_${code}_${DateTime.now().millisecondsSinceEpoch}.png',
                                ).create();
                                await file.writeAsBytes(bytes);
                                await Share.shareXFiles(
                                  [XFile(file.path, mimeType: 'image/png')],
                                );
                              } catch (_) {
                                if (ctx.mounted) {
                                  AppSnackBar.error(ctx, l10n.qrSaveError);
                                }
                              }
                            },
                            prefixIcon: const Icon(LucideIcons.share2,
                                size: 15, color: Colors.white),
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
                  icon: Icon(LucideIcons.x, color: ctx.textSecondary, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
        builder: (context, state) {
          return AppBackgroundBody(
            child: Column(
              children: [
                // Header đồng bộ với Admin Dashboard (Cố định)
                _buildHeader(context, state),

                if (state is FamilyTreeLoading)
                  const Expanded(
                    child: UserFamilyDashboardSkeleton(),
                  ),

                if (state is FamilyTreeError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.alertCircle,
                            size: 64,
                            color: context.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(state.message, style: GoogleFonts.inter()),
                          AppButton(
                            label: l10n.retryButton,
                            onPressed: () => context
                                .read<FamilyTreeBloc>()
                                .add(FamilyTreeLoadEvent(
                                    familyId: _familyId())),
                            size: AppButtonSize.small,
                          ),
                        ],
                      ),
                    ),
                  ),

                if (state is FamilyTreeLoaded) ...[
                  const SizedBox(height: 6),

                  // ── 1. Lối tắt hành động nhanh (Quick Actions Hub - Cố định) ──
                  UserQuickActionsWidget(
                    onOpenBranches: () {
                      Navigator.push(
                        context,
                        SereneFadeSlidePageRoute(
                          page: UserBranchListPage(
                            branches: state.branches,
                            members: state.members,
                          ),
                        ),
                      );
                    },
                    onGoToAnniversaries: () =>
                        _openAnniversaryList(state.members),
                    onOpenInviteCode: () {
                      final inviteCode = state.family?.inviteCode ?? '';
                      if (inviteCode.isNotEmpty) {
                        _showQrDialog(context, inviteCode);
                      } else {
                        AppSnackBar.warning(
                            context, l10n.noClanCode);
                      }
                    },
                  ),

                  const SizedBox(height: 8),

                  // ── 2. Tiêu đề Thành viên & Thanh tìm kiếm + Bộ lọc (Cố định) ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Tiêu đề + Badge đếm số lượng
                        Row(
                          children: [
                            Container(
                              width: 3.5,
                              height: 16,
                              decoration: BoxDecoration(
                                color: context.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.statMembers.toUpperCase(),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_filter.apply(state.members).length}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Thanh tìm kiếm + Bộ lọc hệ thống
                        AppSearchBar(
                          controller: _searchController,
                          hintText: l10n.searchMembersHint,
                          trailing: [
                            _buildFilterMenuButton(
                                context, l10n, state.branches),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── 3. Chỉ cuộn danh sách thành viên (Scrollable List) ──
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final filteredMembers = _filter.apply(state.members);

                        if (filteredMembers.isEmpty) {
                          return AppEmptyState(
                            icon: LucideIcons.search,
                            message: l10n.emptyMembers,
                            padding: const EdgeInsets.symmetric(
                                vertical: 36, horizontal: 16),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredMembers.length > _memberLimit
                              ? _memberLimit
                              : filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            return MemberItemWidget(
                              member: member,
                              allMembers: state.members,
                              showMenu: false,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterMenuButton(BuildContext context, AppLocalizations l10n,
      [List<BranchEntity> branches = const []]) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<void>(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              LucideIcons.listFilter,
              size: 17,
              color: _filter.hasActiveFilters
                  ? context.primary
                  : context.textSecondary,
            ),
            if (_filter.hasActiveFilters)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        offset: const Offset(0, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: context.accent.withValues(alpha: 0.12),
          ),
        ),
        color: context.surface,
        elevation: 6,
        itemBuilder: (context) => [
          // ── 1. Bỏ chọn tất cả ──
          PopupMenuItem<void>(
            height: 38,
            child: Row(
              children: [
                Icon(LucideIcons.filterX, color: context.textPrimary, size: 18),
                const SizedBox(width: 8),
                Text(
                  l10n.clearAllLabel,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 13, color: context.textPrimary),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _filter = const MemberFilter();
              });
            },
          ),
          const PopupMenuDivider(),

          // ── 2. Nội dung bộ lọc với Segmented Controls & Dropdown ──
          PopupMenuItem<void>(
            enabled: false,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: StatefulBuilder(
              builder: (context, setMenuState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Chi tộc (AppDropdown) ──
                    if (branches.isNotEmpty) ...[
                      Text(
                        l10n.branchLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AppDropdown<int?>(
                        value: _filter.branchId,
                        buttonHeight: 36,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 8),
                        items: [
                          DropdownItem<int?>(
                            child: Text(
                              '${l10n.allLabel} ${l10n.branchTabLabel.toLowerCase()}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          ...branches.map((b) => DropdownItem<int?>(
                                value: b.id,
                                child: Text(
                                  b.name,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 12,
                                    color: context.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _filter = _filter.copyWith(branchId: val);
                          });
                          setMenuState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    // ── Tình trạng ──
                    Text(
                      l10n.statusLabel,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child:
                          CupertinoSlidingSegmentedControl<MemberStatusFilter>(
                        backgroundColor: context.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.grey.shade200,
                        thumbColor: context.isDarkMode
                            ? Colors.grey.shade700
                            : Colors.white,
                        groupValue: _filter.status == MemberStatusFilter.all
                            ? null
                            : _filter.status,
                        children: {
                          MemberStatusFilter.alive: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Text(
                              l10n.aliveLabel,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          MemberStatusFilter.deceased: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Text(
                              l10n.deceasedLabel,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filter = _filter.copyWith(
                                status: _filter.status == value
                                    ? MemberStatusFilter.all
                                    : value,
                              );
                            });
                            setMenuState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Giới tính ──
                    Text(
                      l10n.genderLabel,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child:
                          CupertinoSlidingSegmentedControl<MemberGenderFilter>(
                        backgroundColor: context.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.grey.shade200,
                        thumbColor: context.isDarkMode
                            ? Colors.grey.shade700
                            : Colors.white,
                        groupValue: _filter.gender == MemberGenderFilter.all
                            ? null
                            : _filter.gender,
                        children: {
                          MemberGenderFilter.male: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Text(
                              l10n.genderMale,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          MemberGenderFilter.female: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: Text(
                              l10n.genderFemale,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filter = _filter.copyWith(
                                gender: _filter.gender == value
                                    ? MemberGenderFilter.all
                                    : value,
                              );
                            });
                            setMenuState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FamilyTreeState state) {
    final authState = context.watch<AuthBloc>().state;
    final user = (authState is Authenticated) ? authState.user : null;
    final l10n = AppLocalizations.of(context);

    String familyName = l10n.familyTreeTitle;
    String? origin;
    if (state is FamilyTreeLoaded) {
      if (state.family != null) {
        if (state.family!.name.isNotEmpty) {
          familyName = state.family!.name;
        }
        origin = state.family!.origin;
      } else if (state.members.isNotEmpty) {
        final surname = FamilyNameResolver.resolveSurname(state.members);
        if (surname != null) {
          familyName = l10n.familyTreeNameFormat(surname.toUpperCase());
        }
      }
    }

    final rawFamilyName = familyName.trim();
    final displayFamilyName = rawFamilyName.toLowerCase().startsWith('họ')
        ? rawFamilyName.toUpperCase()
        : l10n.familyNamePrefix(rawFamilyName).toUpperCase();

    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, eventsState) {
        List<EventEntity> allEvents = [];
        if (eventsState is EventsLoaded) {
          allEvents = eventsState.events;
        }

        final headerData = AnnouncementService.buildHeaderData(
          allEvents,
          NotificationReadController.instance,
        );

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.appBarBg,
            image: DecorationImage(
              image: AssetImage(
                context.isDarkMode
                    ? 'assets/images/background_appbar_dark.png'
                    : 'assets/images/background_appbar_light.png',
              ),
              fit: BoxFit.cover,
              onError: (_, __) {},
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: context.appBarOverlay),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Avatar ──
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.accent,
                            width: 1.8,
                          ),
                        ),
                        child: ClipOval(
                          child: AppAvatar(
                            avatarUrl: user?.avatarUrl,
                            fullName: user?.fullName,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ── Center: Column (Greeting + Họ & Clan origin) ──
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Greeting + Tên user
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${l10n.helloLabel} ',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 14,
                                      color: context.textSecondary,
                                      height: 1.25,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${user?.fullName ?? l10n.youLabel}!',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: context.textPrimary,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 5),

                            // Dòng họ + Clan origin
                            if (state is FamilyTreeLoading)
                              const AppShimmer(
                                child:
                                    SkeletonBox(height: 20, borderRadius: 10),
                              )
                            else
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon + Tên họ tộc (Họ + Clan)
                                    Icon(
                                      LucideIcons.landmark,
                                      size: 13,
                                      color: context.accent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      displayFamilyName,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: context.textPrimary,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    // Quê quán / Clan origin
                                    if (origin != null &&
                                        origin.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Text(
                                          '|',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: context.textSecondary
                                                .withValues(alpha: 0.4),
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        LucideIcons.mapPin,
                                        size: 12,
                                        color: context.accent,
                                      ),
                                      const SizedBox(width: 3.5),
                                      Text(
                                        origin,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          color: context.textPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ── Bell icon ──
                      GestureDetector(
                        onTap: () async {
                          final famId = _familyId();
                          if (famId != null) {
                            await Navigator.push(
                              context,
                              SereneFadeSlidePageRoute(
                                page: UserNotificationsPage(
                                  familyId: famId,
                                  announcements: headerData.announcements,
                                ),
                              ),
                            );
                            if (mounted) setState(() {});
                          }
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: context.resolve(
                              Colors.black.withValues(alpha: 0.05),
                              Colors.white.withValues(alpha: 0.1),
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.resolve(
                                Colors.black.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                LucideIcons.bell,
                                color: context.textPrimary,
                                size: 19,
                              ),
                              if (headerData.hasUnread)
                                Positioned(
                                  top: 7,
                                  right: 7,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: context.error,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAnniversaryList(
    List<MemberEntity> members, {
    int initialTabIndex = 0,
  }) {
    final authState = context.read<AuthBloc>().state;
    final userMemberId =
        authState is Authenticated ? authState.user.memberId : null;
    final anniversaries = AnniversaryCalculator.calculateDeathAnniversaries(
      members,
      userMemberId: userMemberId,
    );
    final birthdays = AnniversaryCalculator.calculateBirthdays(
      members,
      userMemberId: userMemberId,
    );
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: UserAnniversaryListPage(
          deathAnniversaries: anniversaries,
          birthdays: birthdays,
          initialTabIndex: initialTabIndex,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../models/upcoming_anniversary.dart';
import '../models/wish_message.dart';
import '../widgets/wish_letter_dialog.dart';
import '../widgets/incense_offering_dialog.dart';
import '../../data/source/wish_api_service.dart';

class WishWallPage extends StatefulWidget {

  const WishWallPage({
    super.key,
    required this.data,
    required this.apiService,
  });
  final UpcomingAnniversary data;
  final WishApiService apiService;

  @override
  State<WishWallPage> createState() => _WishWallPageState();
}

class _WishWallPageState extends State<WishWallPage> {
  bool _isLoading = true;
  List<WishMessage> _wishes = [];
  final ScrollController _scrollController = ScrollController();
  int _wishLimit = 5;

  // Trạng thái tim theo wishId
  final Map<int, int> _reactionCounts = {};
  final Map<int, bool> _reacted = {};

  @override
  void initState() {
    super.initState();
    _loadWishes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _wishLimit += 5;
      });
    }
  }

  Future<void> _loadWishes() async {
    setState(() => _isLoading = true);
    final wishes =
        await widget.apiService.getWishesByMember(widget.data.member.id);
    if (mounted) {
      setState(() {
        _wishes = wishes;
        _isLoading = false;
        // Khởi tạo trạng thái tim từ server
        for (final w in wishes) {
          _reactionCounts[w.id] = w.reactionCount;
          _reacted[w.id] = w.isReacted;
        }
      });
    }
  }

  Future<void> _sendWish() async {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthBloc>().state;
    UserEntity? userProfile;

    if (authState is Authenticated) {
      userProfile = authState.user;
    }

    if (userProfile == null) {
      AppSnackBar.show(
        context,
        message: l10n.wishLoginRequired,
        type: SnackBarType.error,
      );
      return;
    }

    final solar = widget.data.solarDateLabel;
    final lunar = widget.data.lunarDateLabel;
    final subtitle = lunar == null ? solar : '$solar · $lunar';

    final String? message;
    if (widget.data.isBirthday) {
      message = await showWishLetterDialog(
        context,
        title: widget.data.title,
        subtitle: subtitle,
        isBirthday: true,
      );
    } else {
      message = await showIncenseDialog(
        context,
        targetName: widget.data.title,
        subtitle: subtitle,
      );
    }

    if (message != null && mounted) {
      final defaultContent = widget.data.isBirthday
          ? l10n.happyBirthdayTitle
          : l10n.incenseDefaultPrayer;
      final prayerContent =
          message.trim().isNotEmpty ? message.trim() : defaultContent;

      final newWish = WishMessage(
        id: 0,
        familyId: userProfile.familyId ?? 0,
        memberId: widget.data.member.id,
        senderId: userProfile.id,
        content: prayerContent,
        eventType: widget.data.isBirthday ? 'birthday' : 'anniversary',
        createdAt: DateTime.now(),
        senderName: userProfile.fullName,
        senderAvatar: userProfile.avatarUrl,
      );

      setState(() {
        _wishes.insert(0, newWish);
        _reactionCounts[newWish.id] = 0;
        _reacted[newWish.id] = false;
      });

      final created = await widget.apiService.createWish(newWish);
      if (created != null && mounted) {
        setState(() {
          _wishes[0] = created;
          _reactionCounts[created.id] = 0;
          _reacted[created.id] = false;
        });

        AppSnackBar.show(
          context,
          message: widget.data.isBirthday
              ? l10n.wishSentMessage
              : l10n.incenseLitFor(widget.data.title),
          type: SnackBarType.success,
        );
      }
    }
  }

  Future<void> _toggleReact(int wishId) async {
    HapticFeedback.lightImpact();
    // Optimistic update
    setState(() {
      final prev = _reacted[wishId] ?? false;
      _reacted[wishId] = !prev;
      _reactionCounts[wishId] =
          (_reactionCounts[wishId] ?? 0) + (prev ? -1 : 1);
    });

    final result = await widget.apiService.reactToWish(wishId);
    if (result != null && mounted) {
      setState(() {
        _reacted[wishId] = result['reacted'] as bool? ?? _reacted[wishId]!;
        _reactionCounts[wishId] =
            result['reactionCount'] as int? ?? _reactionCounts[wishId]!;
      });
    }
  }

  Future<void> _reportWish(int wishId) async {
    final l10n = AppLocalizations.of(context);
    final reasons = [
      l10n.reportReasonInappropriate,
      l10n.reportReasonAbusive,
      l10n.reportReasonFalseInfo,
      l10n.reportReasonSpam,
      l10n.reportReasonOther,
    ];

    final selectedReason = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: context.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.reportContentTitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.selectReportReason,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ...reasons.map((reason) => InkWell(
                    onTap: () => Navigator.pop(ctx, reason),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.flag,
                            size: 18,
                            color: context.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reason,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );

    if (selectedReason == null || !mounted) return;

    final success = await widget.apiService.reportWish(wishId, selectedReason);
    if (mounted) {
      if (success) {
        AppSnackBar.show(
          context,
          message: l10n.reportSuccessMessage,
          type: SnackBarType.success,
        );
      } else {
        AppSnackBar.show(
          context,
          message: l10n.reportFailedMessage,
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isBirthday = widget.data.isBirthday;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppAppBar(
        title: isBirthday ? l10n.wishDialogTitle : l10n.anniversaryDialogTitle,
      ),
      body: AppBackgroundBody(
        child: Stack(
          children: [
            if (_isLoading)
              const WishWallSkeleton()
            else if (_wishes.isEmpty)
              Center(
                child: AppEmptyState(
                  icon: isBirthday ? LucideIcons.mail : LucideIcons.flame,
                  message: isBirthday
                      ? l10n.noWishesMessage
                      : l10n.noIncenseWishesMessage,
                  subMessage: isBirthday
                      ? l10n.beFirstWisher
                      : l10n.beFirstIncenseMessage,
                ),
              )
            else
              ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                itemCount:
                    _wishes.length > _wishLimit ? _wishLimit : _wishes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final wish = _wishes[index];
                  return _WishCard(
                    wish: wish,
                    isBirthday: isBirthday,
                    reactionCount: _reactionCounts[wish.id] ?? 0,
                    isReacted: _reacted[wish.id] ?? false,
                    onReact: () => _toggleReact(wish.id),
                    onReport: () => _reportWish(wish.id),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendWish,
        backgroundColor: context.primary,
        foregroundColor: context.textOnPrimary,
        elevation: 4,
        icon: Icon(isBirthday ? LucideIcons.gift : LucideIcons.flame),
        label: Text(
          isBirthday ? l10n.sendWishButton : l10n.lightIncenseLabel,
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _WishCard extends StatelessWidget {

  const _WishCard({
    required this.wish,
    required this.isBirthday,
    required this.reactionCount,
    required this.isReacted,
    required this.onReact,
    required this.onReport,
  });
  final WishMessage wish;
  final bool isBirthday;
  final int reactionCount;
  final bool isReacted;
  final VoidCallback onReact;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final senderName =
        (wish.senderName != null && wish.senderName!.trim().isNotEmpty)
            ? wish.senderName!.trim()
            : l10n.memberLabel;

    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Header Crimson gọn gàng, vừa vặn ──
          Container(
            color: context.primary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              children: [
                // Avatar tròn nhỏ gọn
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: wish.senderAvatar != null &&
                          wish.senderAvatar!.trim().isNotEmpty
                      ? ClipOval(
                          child: AppNetworkImage(
                            url: wish.senderAvatar!.trim(),
                            width: 28,
                            height: 28,
                          ),
                        )
                      : Text(
                          senderName.isNotEmpty
                              ? senderName[0].toUpperCase()
                              : 'M',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                // Tên người gửi & Ngày gửi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${wish.createdAt.day.toString().padLeft(2, '0')}/${wish.createdAt.month.toString().padLeft(2, '0')}/${wish.createdAt.year}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu 3 chấm – Báo cáo vi phạm
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: context.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 4,
                  offset: const Offset(0, 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    LucideIcons.moreVertical,
                    size: 16,
                    color: Colors.white,
                  ),
                  itemBuilder: (ctx) => [
                    PopupMenuItem<String>(
                      value: 'report',
                      height: 38,
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.flag,
                            size: 18,
                            color: context.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.reportContentTitle,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'report') onReport();
                  },
                ),
              ],
            ),
          ),

          // ── 2. Nội dung lời chúc (Không background, không icon quote) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Text(
              wish.content,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                height: 1.45,
                color: context.textPrimary,
              ),
            ),
          ),

          // ── 3. Thanh yêu thích đồng bộ như Card sự kiện ──
          Divider(
            height: 1,
            thickness: 0.5,
            color: context.textSecondary.withValues(alpha: 0.12),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              children: [
                InkWell(
                  onTap: onReact,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isReacted ? LucideIcons.heart : LucideIcons.heart,
                          size: 17,
                          color: isReacted
                              ? context.primary
                              : context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          reactionCount > 0
                              ? l10n.likeCountLabel(reactionCount)
                              : l10n.likeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight:
                                isReacted ? FontWeight.w600 : FontWeight.normal,
                            color: isReacted
                                ? context.primary
                                : context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

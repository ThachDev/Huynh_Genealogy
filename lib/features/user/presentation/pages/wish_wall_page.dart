import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../models/upcoming_anniversary.dart';
import '../models/wish_message.dart';
import '../widgets/wish_letter_dialog.dart';
import '../../data/source/wish_api_service.dart';

class WishWallPage extends StatefulWidget {
  final UpcomingAnniversary data;
  final WishApiService apiService;

  const WishWallPage({
    super.key,
    required this.data,
    required this.apiService,
  });

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
        // Khởi tạo trạng thái tim mặc định
        for (final w in wishes) {
          _reactionCounts[w.id] = 0;
          _reacted[w.id] = false;
        }
      });
    }
  }

  Future<void> _sendWish() async {
    final l10n = AppLocalizations.of(context)!;
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

    final message = await showWishLetterDialog(
      context,
      title: widget.data.title,
      subtitle: subtitle,
      isBirthday: widget.data.isBirthday,
    );

    if (message != null && message.trim().isNotEmpty && mounted) {
      final newWish = WishMessage(
        id: 0,
        familyId: userProfile.familyId ?? 0,
        memberId: widget.data.member.id,
        senderId: userProfile.id,
        content: message,
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
      }
    }
  }

  Future<void> _toggleReact(int wishId) async {
    HapticFeedback.lightImpact();
    // Optimistic update
    setState(() {
      final prev = _reacted[wishId] ?? false;
      _reacted[wishId] = !prev;
      _reactionCounts[wishId] = (_reactionCounts[wishId] ?? 0) + (prev ? -1 : 1);
    });

    final result = await widget.apiService.reactToWish(wishId);
    if (result != null && mounted) {
      setState(() {
        _reacted[wishId] = result['reacted'] as bool? ?? _reacted[wishId]!;
        _reactionCounts[wishId] = result['reactionCount'] as int? ?? _reactionCounts[wishId]!;
      });
    }
  }

  Future<void> _reportWish(int wishId) async {
    final l10n = AppLocalizations.of(context)!;
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reportContentTitle,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            Text(
              l10n.selectReportReason,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ...reasons.map((reason) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(LucideIcons.flag, size: 18, color: context.accent),
                  title: Text(
                    reason,
                    style: GoogleFonts.beVietnamPro(fontSize: 14),
                  ),
                  onTap: () => Navigator.pop(ctx, reason),
                )),
          ],
        ),
      ),
    );

    if (selectedReason == null || !mounted) return;

    final success = await widget.apiService.reportWish(wishId, selectedReason);
    if (mounted) {
      if (success) {
        AppSnackBar.success(context, l10n.reportSuccessMessage);
      } else {
        AppSnackBar.error(context, l10n.reportFailedMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  icon: LucideIcons.mail,
                  message: l10n.noWishesMessage,
                  subMessage: l10n.beFirstWisher,
                ),
              )
            else
              ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                itemCount: _wishes.length > _wishLimit
                    ? _wishLimit
                    : _wishes.length,
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
        icon: Icon(isBirthday ? LucideIcons.gift : LucideIcons.mailPlus),
        label: Text(
          isBirthday ? l10n.sendWishButton : l10n.sendRemembranceButton,
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final WishMessage wish;
  final bool isBirthday;
  final int reactionCount;
  final bool isReacted;
  final VoidCallback onReact;
  final VoidCallback onReport;

  const _WishCard({
    required this.wish,
    required this.isBirthday,
    required this.reactionCount,
    required this.isReacted,
    required this.onReact,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                avatarUrl: wish.senderAvatar,
                fullName: wish.senderName ?? l10n.memberLabel,
                radius: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wish.senderName ?? l10n.memberLabel,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${wish.createdAt.day}/${wish.createdAt.month}/${wish.createdAt.year}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu 3 chấm – Báo cáo vi phạm (CH Play UGC Policy)
              PopupMenuButton<String>(
                icon: Icon(
                  LucideIcons.moreVertical,
                  size: 18,
                  color: context.textSecondary.withValues(alpha: 0.6),
                ),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(LucideIcons.flag, size: 16, color: context.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.reportContentTitle,
                          style: GoogleFonts.beVietnamPro(fontSize: 14),
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
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      LucideIcons.quote,
                      size: 16,
                      color: context.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  wish.content,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: context.textPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
          // ─── Reaction row ──────────────────────────────────────────────
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 36 + 8), // align với nội dung
              GestureDetector(
                onTap: onReact,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: child,
                  ),
                  child: Icon(
                    isReacted ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isReacted),
                    size: 20,
                    color: isReacted
                        ? AppColors.error
                        : context.textSecondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (reactionCount > 0)
                Text(
                  '$reactionCount',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isReacted
                        ? AppColors.error
                        : context.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

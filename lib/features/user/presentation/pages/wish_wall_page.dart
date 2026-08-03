import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/app_appbar.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_common_widgets.dart';
import '../../../../core/widgets/app_snackbar.dart';
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

  @override
  void initState() {
    super.initState();
    _loadWishes();
  }

  Future<void> _loadWishes() async {
    setState(() => _isLoading = true);
    final wishes =
        await widget.apiService.getWishesByMember(widget.data.member.id);
    if (mounted) {
      setState(() {
        _wishes = wishes;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendWish() async {
    final authState = context.read<AuthBloc>().state;
    UserEntity? userProfile;

    if (authState is Authenticated) {
      userProfile = authState.user;
    }

    if (userProfile == null) {
      AppSnackBar.show(
        context,
        message:
            'Vui lòng chờ tải thông tin hoặc đăng nhập lại để gửi lời chúc',
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
      });

      final created = await widget.apiService.createWish(newWish);
      if (created != null && mounted) {
        setState(() {
          _wishes[0] = created;
        });
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
              const Center(child: CircularProgressIndicator())
            else if (_wishes.isEmpty)
              const Center(
                child: AppEmptyState(
                  icon: LucideIcons.mail,
                  message: 'Chưa có lời chúc nào.',
                  subMessage: 'Hãy là người đầu tiên gửi lời chúc!',
                ),
              )
            else
              ListView.separated(
                padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                itemCount: _wishes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _WishCard(
                    wish: _wishes[index],
                    isBirthday: isBirthday,
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
          isBirthday ? 'Gửi lời chúc' : 'Gửi lời tưởng nhớ',
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final WishMessage wish;
  final bool isBirthday;

  const _WishCard({required this.wish, required this.isBirthday});

  @override
  Widget build(BuildContext context) {
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
                fullName: wish.senderName ?? 'Thành viên',
                radius: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wish.senderName ?? 'Thành viên',
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
              // Leaf/cake icon removed as requested
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36, // Diameter of radius: 18 avatar
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
        ],
      ),
    );
  }
}

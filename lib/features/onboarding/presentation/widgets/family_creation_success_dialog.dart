import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entity/family_entity.dart';

class FamilyCreationSuccessDialog extends StatefulWidget {
  final FamilyEntity family;
  final VoidCallback onProceed;

  const FamilyCreationSuccessDialog({
    super.key,
    required this.family,
    required this.onProceed,
  });

  @override
  State<FamilyCreationSuccessDialog> createState() =>
      _FamilyCreationSuccessDialogState();
}

class _FamilyCreationSuccessDialogState
    extends State<FamilyCreationSuccessDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.family.inviteCode));
    AppSnackBar.success(
      context,
      'Đã sao chép mã mời: ${widget.family.inviteCode}',
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    const double lineLength = 16.0;
    const double thickness = 2.0;
    const Color cornerColor = AppColors.gold;

    return SizedBox(
      width: lineLength,
      height: lineLength,
      child: Stack(
        children: [
          Positioned(
            top: isTop ? 0 : null,
            bottom: !isTop ? 0 : null,
            left: 0,
            right: 0,
            child: Container(
              height: thickness,
              color: cornerColor,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: isLeft ? 0 : null,
            right: !isLeft ? 0 : null,
            child: Container(
              width: thickness,
              color: cornerColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Fine-art traditional corners
                Positioned(top: 8, left: 8, child: _buildCorner(isTop: true, isLeft: true)),
                Positioned(top: 8, right: 8, child: _buildCorner(isTop: true, isLeft: false)),
                Positioned(bottom: 8, left: 8, child: _buildCorner(isTop: false, isLeft: true)),
                Positioned(bottom: 8, right: 8, child: _buildCorner(isTop: false, isLeft: false)),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Celebration Badge
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.crimson.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gold,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.sparkles,
                          color: AppColors.gold,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Success Title
                      Text(
                        'KHỞI TẠO THÀNH CÔNG',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Family Name
                      Text(
                        widget.family.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.crimson,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description / Message
                      Text(
                        'Dòng họ của bạn đã được khởi tạo thành công trên hệ thống Gia Tộc Việt. Hãy dùng mã mời dưới đây để kết nối người thân.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Invite Code Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.parchment,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MÃ MỜI GIA TỘC',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.family.inviteCode,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.crimson,
                                    letterSpacing: 3.0,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.copy, color: AppColors.gold),
                              tooltip: 'Sao chép mã',
                              onPressed: () => _copyToClipboard(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons
                      AppButton(
                        label: 'BẮT ĐẦU KHÁM PHÁ',
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onProceed();
                        },
                        fullWidth: true,
                        size: AppButtonSize.large,
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: 'Tham gia gia phả "${widget.family.name}" trên ứng dụng Gia Tộc Việt. Mã mời của dòng họ là: ${widget.family.inviteCode}',
                            ),
                          );
                          AppSnackBar.success(context, 'Đã sao chép nội dung chia sẻ!');
                        },
                        icon: const Icon(LucideIcons.share2, size: 16, color: AppColors.crimson),
                        label: Text(
                          'CHIA SẺ CHO GIA ĐÌNH',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.crimson,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

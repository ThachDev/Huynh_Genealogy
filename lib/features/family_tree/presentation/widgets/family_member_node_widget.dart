import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/domain/entity/member_entity.dart';
import '../../../../core/widgets/widgets.dart';

class FamilyMemberNodeWidget extends StatefulWidget {
  final MemberEntity member;
  final bool isSelected;
  final bool isCurrentUser;
  final VoidCallback? onTap;
  final VoidCallback? onAddChildTap;
  final VoidCallback? onAddSpouseTap;

  const FamilyMemberNodeWidget({
    super.key,
    required this.member,
    this.isSelected = false,
    this.isCurrentUser = false,
    this.onTap,
    this.onAddChildTap,
    this.onAddSpouseTap,
  });

  @override
  State<FamilyMemberNodeWidget> createState() => _FamilyMemberNodeWidgetState();
}

class _FamilyMemberNodeWidgetState extends State<FamilyMemberNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _genderColor {
    switch (widget.member.gender) {
      case Gender.male:
        return context.genderMale;
      case Gender.female:
        return context.genderFemale;
      case Gender.unknown:
        return context.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final genderText = widget.member.gender == Gender.male
        ? 'Nam'
        : widget.member.gender == Gender.female
            ? l10n.genderFemale
            : l10n.genderUnknown;

    final hasActions =
        widget.onAddChildTap != null || widget.onAddSpouseTap != null;

    final bgCardPath = context.isDarkMode
        ? 'assets/images/bgcard_dark.png'
        : 'assets/images/bgcard_light.png';

    return RepaintBoundary(
      child: Semantics(
        label:
            l10n.memberAccessibilityFormat(genderText, widget.member.fullName),
        button: true,
        selected: widget.isSelected,
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            widget.onTap?.call();
          },
          onTapCancel: () => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              width: 140,
              height: hasActions ? 160 : 125,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── THÂN CARD CHÍNH CÓ NỀN HOẠ TIẾT VÀ KHUNG VIỀN ──
                  Container(
                    width: 140,
                    height: hasActions ? 160 : 125,
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: context.isDarkMode ? 0.35 : 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.isSelected
                            ? context.primary
                            : context.accent.withValues(
                                alpha: context.isDarkMode ? 0.75 : 0.65),
                        width: widget.isSelected ? 2.0 : 1.2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Nền ảnh hoa sen truyền thống Light/Dark
                        Positioned.fill(
                          child: Image.asset(
                            bgCardPath,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Lớp phủ màu mềm chuẩn Theme hệ thống
                        Positioned.fill(
                          child: Container(
                            color: context.isDarkMode
                                ? Colors.black.withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),

                        // Nội dung chính
                        Padding(
                          padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
                          child: Column(
                            children: [
                              // ── 1. AVATAR ──
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.accent.withValues(
                                        alpha:
                                            context.isDarkMode ? 0.45 : 0.35),
                                    width: 1.0,
                                  ),
                                ),
                                child: AppAvatar(
                                  avatarUrl: widget.member.avatarUrl,
                                  fullName: widget.member.fullName,
                                  radius: 20,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),

                              // ── 2. HỌ VÀ TÊN ──
                              Text(
                                widget.member.fullName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: context.textPrimary,
                                  height: 1.15,
                                ),
                              ),

                              // ── 3. HOA VĂN PHÂN CÁCH VỚI BIỂU TƯỢNG GIỚI TÍNH ──
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 0.8,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              context.accent
                                                  .withValues(alpha: 0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Icon(
                                        widget.member.gender == Gender.female
                                            ? Icons.female
                                            : Icons.male,
                                        size: 11,
                                        color: _genderColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 0.8,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              context.accent
                                                  .withValues(alpha: 0.7),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ── 4. NGÀY SINH / NGÀY MẤT ──
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(1.5),
                                            decoration: BoxDecoration(
                                              color: context.primary
                                                  .withValues(alpha: 0.85),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              LucideIcons.activity,
                                              size: 7,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Sinh: ${DateFormatter.formatForDisplay(widget.member.dateOfBirth) ?? l10n.unknownLabel}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.w600,
                                                color: context.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (!widget.member.isAlive) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(1.5),
                                              decoration: BoxDecoration(
                                                color: context.primary
                                                    .withValues(alpha: 0.85),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                LucideIcons.cross,
                                                size: 7,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                'Mất: ${DateFormatter.formatForDisplay(widget.member.dateOfDeath) ?? l10n.unknownLabel}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: context.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),

                              // ── 5. NÚT HÀNH ĐỘNG (THÊM CON, THÊM PHỐI NGẪU) ──
                              if (hasActions) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (widget.onAddChildTap != null)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: widget.onAddChildTap,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: context.surface
                                                  .withValues(alpha: 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: context.accent
                                                    .withValues(alpha: 0.4),
                                                width: 0.7,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  LucideIcons.baby,
                                                  size: 10,
                                                  color: context.primary,
                                                ),
                                                const SizedBox(width: 2),
                                                Flexible(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'Thêm con',
                                                      style: GoogleFonts
                                                          .beVietnamPro(
                                                        fontSize: 8.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            context.textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (widget.onAddChildTap != null &&
                                        widget.onAddSpouseTap != null)
                                      const SizedBox(width: 3),
                                    if (widget.onAddSpouseTap != null)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: widget.onAddSpouseTap,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: context.surface
                                                  .withValues(alpha: 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: context.accent
                                                    .withValues(alpha: 0.4),
                                                width: 0.7,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  LucideIcons.heart,
                                                  size: 9.5,
                                                  color: context.resolve(
                                                      Colors.redAccent,
                                                      Colors.red.shade300),
                                                ),
                                                const SizedBox(width: 2),
                                                Flexible(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      widget.member.gender ==
                                                              Gender.female
                                                          ? 'Thêm chồng'
                                                          : 'Thêm vợ',
                                                      style: GoogleFonts
                                                          .beVietnamPro(
                                                        fontSize: 8.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            context.textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── 6. THẺ RUY BĂNG "TÔI" GẮN GÓC TRÊN BÊN PHẢI ──
                  if (widget.isCurrentUser)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ClipPath(
                        clipper: const _RibbonClipper(topRightRadius: 12),
                        child: Container(
                          width: 22,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                context.accent,
                                context.accent.withValues(alpha: 0.85),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 3,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(top: 3),
                          child: Column(
                            children: [
                              const Icon(
                                LucideIcons.userCheck,
                                size: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                l10n.meLabel,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Clipper tạo hình ruy băng thẻ bài phong cách cổ truyền có đuôi vát nhọn chữ V
/// và bo góc trên bên phải khớp với góc của thẻ card
class _RibbonClipper extends CustomClipper<Path> {
  final double topRightRadius;
  const _RibbonClipper({this.topRightRadius = 0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height - 4);
    path.lineTo(size.width, size.height);
    if (topRightRadius > 0) {
      path.lineTo(size.width, topRightRadius);
      path.quadraticBezierTo(size.width, 0, size.width - topRightRadius, 0);
    } else {
      path.lineTo(size.width, 0);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _RibbonClipper oldClipper) =>
      oldClipper.topRightRadius != topRightRadius;
}

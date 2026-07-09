import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';

class FamilyMemberNodeWidget extends StatefulWidget {
  final MemberEntity member;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onAddChildTap;
  final VoidCallback? onAddSpouseTap;

  const FamilyMemberNodeWidget({
    super.key,
    required this.member,
    this.isSelected = false,
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
        return context.resolve(Colors.grey.shade400, Colors.grey.shade600);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 140,
          height: 160,
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.resolve(
                  Colors.black.withValues(alpha: 0.08),
                  Colors.transparent,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    // TOP: Avatar, Name, DOB
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: widget.member.isAlive
                                ? _genderColor.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.3),
                            width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: widget.member.isAlive
                            ? _genderColor.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.2),
                        backgroundImage: widget.member.avatarUrl != null
                            ? NetworkImage(widget.member.avatarUrl!)
                            : null,
                        child: widget.member.avatarUrl == null
                            ? Icon(
                                LucideIcons.user,
                                color: widget.member.isAlive
                                    ? _genderColor
                                    : Colors.grey,
                                size: 22,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.member.fullName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TIMELINE ICONS
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 14,
                              alignment: Alignment.center,
                              child: Icon(
                                LucideIcons.activity,
                                size: 8,
                                color: context.textSecondary,
                              ),
                            ),
                            if (!widget.member.isAlive) ...[
                              Container(
                                width: 1,
                                height: 4,
                                color: context.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              Container(
                                height: 14,
                                alignment: Alignment.center,
                                child: Icon(
                                  LucideIcons.cross,
                                  size: 8,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(width: 6),
                        // DATES TEXT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                DateFormatter.formatForDisplay(
                                        widget.member.dateOfBirth) ??
                                    l10n.unknownLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: context.textSecondary,
                                  height: 1.0,
                                ),
                              ),
                            ),
                            if (!widget.member.isAlive) ...[
                              const SizedBox(height: 4),
                              Container(
                                height: 14,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  DateFormatter.formatForDisplay(
                                          widget.member.dateOfDeath) ??
                                      l10n.unknownLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: context.textSecondary,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),

                    // DIVIDER
                    Divider(
                      height: 1,
                      thickness: 1,
                      color:
                          context.resolve(Colors.grey[300]!, Colors.grey[800]!),
                    ),

                    const Spacer(),
                    // BOTTOM ICONS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.onAddChildTap != null)
                          GestureDetector(
                            onTap: widget.onAddChildTap,
                            child: Tooltip(
                              message: 'Thêm Con',
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                child: Icon(
                                  LucideIcons.baby,
                                  size: 18,
                                  color: context.primary,
                                ),
                              ),
                            ),
                          ),
                        if (widget.onAddSpouseTap != null)
                          GestureDetector(
                            onTap: widget.onAddSpouseTap,
                            child: Tooltip(
                              message: 'Thêm Vợ/Chồng',
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                child: Icon(
                                  LucideIcons.heart,
                                  size: 16,
                                  color: context.resolve(
                                      Colors.redAccent, Colors.red.shade300),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              // BOTTOM COLORED BAR
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _genderColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              // BOTTOM CIRCLE MARKER
              Positioned(
                bottom: -2,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: _genderColor, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

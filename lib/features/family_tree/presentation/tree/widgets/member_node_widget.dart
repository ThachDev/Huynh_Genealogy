import 'package:app_family_tree/core/utils/member_utils.dart'
    show MemberImageExtension;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';

class MemberNodeWidget extends StatefulWidget {
  final MemberEntity member;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const MemberNodeWidget({
    super.key,
    required this.member,
    this.isSelected = false,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  State<MemberNodeWidget> createState() => _MemberNodeWidgetState();
}

class _MemberNodeWidgetState extends State<MemberNodeWidget>
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Avatar Circle with Border
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: widget.member.gender == Gender.female
                          ? AppColors.femaleBorder
                          : AppColors.maleBorder,
                      width: 3.5,
                    ),
                    boxShadow: [
                      if (widget.isHighlighted)
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 4,
                        ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      2,
                    ), // Space between border and image
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.member.avatarUrl == null
                            ? (widget.member.gender == Gender.female
                                  ? AppColors.nodeFemale
                                  : AppColors.nodeMale)
                            : Colors.white,
                        image: widget.member.fullAvatarUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.member.fullAvatarUrl!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.member.fullAvatarUrl == null
                          ? Center(
                              child: Icon(
                                widget.member.gender == Gender.female
                                    ? Icons.woman
                                    : Icons.man,
                                color: widget.member.gender == Gender.female
                                    ? AppColors.femaleBorder
                                    : AppColors.maleBorder,
                                size: 40,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                // Status Badge (Green/Gray Dot)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.member.isAlive
                          ? const Color(0xFF2ECC71)
                          : AppColors.nodeDeceased,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                // Connector Point (Small circle at the bottom)
                Positioned(
                  bottom: -6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: widget.member.gender == Gender.female
                              ? AppColors.femaleBorder
                              : AppColors.maleBorder,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Member Name
            SizedBox(
              width: 140, // Expanded slightly for single line
              child: Text(
                widget.member.fullName,
                textAlign: TextAlign.center,
                maxLines: 1, // Single line only
                overflow: TextOverflow.ellipsis, // Use ellipsis if too long
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w900, // Extra bold like in the image
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

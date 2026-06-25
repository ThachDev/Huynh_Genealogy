import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entity/member_entity.dart';

class MemberNodeWidget extends StatefulWidget {
  final MemberEntity member;
  final bool isSelected;
  final VoidCallback? onTap;

  const MemberNodeWidget({
    super.key,
    required this.member,
    this.isSelected = false,
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

  Color get _nodeColor {
    if (!widget.member.isAlive) return AppColors.nodeDeceased;
    switch (widget.member.gender) {
      case Gender.male:
        return AppColors.nodeMale;
      case Gender.female:
        return AppColors.nodeFemale;
      case Gender.unknown:
        return AppColors.parchment;
    }
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 140,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _nodeColor,
            border: Border.all(
              color: widget.isSelected ? AppColors.crimson : AppColors.gold,
              width: widget.isSelected ? 2.5 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.parchment,
                  backgroundImage: widget.member.avatarUrl != null
                      ? NetworkImage(widget.member.avatarUrl!)
                      : null,
                  child: widget.member.avatarUrl == null
                      ? const Icon(
                          LucideIcons.user,
                          color: AppColors.crimson,
                          size: 36,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              // Name
              Text(
                widget.member.fullName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              // Generation label
              if (widget.member.generation != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.crimson,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Đời thứ ${widget.member.generation}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!widget.member.isAlive)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '✝ Đã mất',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';

class UserMemberNodeWidget extends StatefulWidget {
  final MemberEntity member;
  final bool isSelected;
  final VoidCallback? onTap;

  const UserMemberNodeWidget({
    super.key,
    required this.member,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<UserMemberNodeWidget> createState() => _UserMemberNodeWidgetState();
}

class _UserMemberNodeWidgetState extends State<UserMemberNodeWidget>
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
    if (!widget.member.isAlive) return context.nodeDeceased;
    switch (widget.member.gender) {
      case Gender.male:
        return context.nodeMale;
      case Gender.female:
        return context.nodeFemale;
      case Gender.unknown:
        return context.background;
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 140,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _nodeColor,
            border: Border.all(
              color: widget.isSelected ? context.primary : context.accent,
              width: widget.isSelected ? 2.5 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.resolve(Colors.black.withValues(alpha: 0.1), Colors.transparent),
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
                  border: Border.all(color: context.accent, width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: context.background,
                  backgroundImage: widget.member.avatarUrl != null
                      ? NetworkImage(widget.member.avatarUrl!)
                      : null,
                  child: widget.member.avatarUrl == null
                      ? Icon(
                          LucideIcons.user,
                          color: context.primary,
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
                  color: context.textPrimary,
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
                    color: context.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.generationBadge('${widget.member.generation}'),
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
                    '✝ ${l10n.deceasedLabel}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: context.textSecondary,
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

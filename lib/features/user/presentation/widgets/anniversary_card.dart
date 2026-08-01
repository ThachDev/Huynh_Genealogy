import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../models/upcoming_anniversary.dart';

/// Card dùng chung cho cả Ngày Giỗ (isBirthday: false) và Sinh Nhật (isBirthday: true).
class AnniversaryCard extends StatelessWidget {
  final UpcomingAnniversary data;
  final bool fullWidth;

  const AnniversaryCard({
    super.key,
    required this.data,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isBirthday = data.isBirthday;
    final icon = isBirthday ? LucideIcons.cake : LucideIcons.flame;

    return Container(
      width: fullWidth ? double.infinity : 230,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Header: icon + tên + đời ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: context.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (data.member.generation != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context)!
                            .generationLabel(data.member.generation!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 6),
          // ── Footer: ngày + countdown ──
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 20, color: context.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.solarDateLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (data.lunarDateLabel != null)
                      Text(
                        data.lunarDateLabel!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: context.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              CountdownBadge(days: data.daysRemaining, isBirthday: isBirthday),
            ],
          ),
        ],
      ),
    );
  }
}

class CountdownBadge extends StatelessWidget {
  final int days;
  final bool isBirthday;

  const CountdownBadge({
    super.key,
    required this.days,
    required this.isBirthday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        days == 0
            ? AppLocalizations.of(context)!.todayLabel
            : AppLocalizations.of(context)!.eventCountdown(days),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.textOnPrimary,
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';

class EventFilterBar extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onSelectType;
  final Map<String, int> counts;

  const EventFilterBar({
    super.key,
    required this.selectedType,
    required this.onSelectType,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = [
      {
        'key': 'all',
        'label': l10n.allLabel,
        'count': counts['all'] ?? 0,
        'icon': LucideIcons.layers,
      },
      {
        'key': 'event',
        'label': l10n.eventTypeEvent,
        'count': counts['event'] ?? 0,
        'icon': LucideIcons.calendar,
      },
      {
        'key': 'announcement',
        'label': l10n.eventTypeAnnouncement,
        'count': counts['announcement'] ?? 0,
        'icon': LucideIcons.bell,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final key = filter['key'] as String;
          final label = filter['label'] as String;
          final count = filter['count'] as int;
          final icon = filter['icon'] as IconData;
          final isSelected = selectedType == key;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: key != 'announcement' ? 8.0 : 0.0,
              ),
              child: StatFilterCardItem(
                icon: icon,
                label: label,
                value: '$count',
                isSelected: isSelected,
                onTap: () => onSelectType(key),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class StatFilterCardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const StatFilterCardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBg = isSelected ? context.primary : context.surface;

    final Color borderColor = isSelected
        ? context.primary
        : context.textSecondary.withValues(alpha: 0.15);

    final Color numberColor = isSelected ? Colors.white : context.textPrimary;

    final Color labelColor = isSelected ? Colors.white : context.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? null
                : Border.all(
                    color: borderColor,
                    width: 1.0,
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: numberColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: labelColor,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: labelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

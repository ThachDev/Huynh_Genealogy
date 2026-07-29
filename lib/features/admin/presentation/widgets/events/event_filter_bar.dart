import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';

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
    final filters = [
      {
        'key': 'all',
        'label': 'Tất cả',
        'icon': LucideIcons.layers,
      },
      {
        'key': 'event',
        'label': 'Sự kiện',
        'icon': LucideIcons.calendar,
      },
      {
        'key': 'article',
        'label': 'Tin tức',
        'icon': LucideIcons.fileText,
      },
      {
        'key': 'announcement',
        'label': 'Thông báo',
        'icon': LucideIcons.megaphone,
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final key = filter['key'] as String;
          final label = filter['label'] as String;
          final icon = filter['icon'] as IconData;
          final count = counts[key] ?? 0;
          final isSelected = selectedType == key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelectType(key),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.primary
                        : context.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? context.primary
                          : context.textSecondary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: context.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 15,
                        color: isSelected
                            ? Colors.white
                            : context.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : context.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : context.textSecondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : context.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

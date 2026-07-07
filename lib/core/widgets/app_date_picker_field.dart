import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vnlunar/vnlunar.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
import 'app_lunar_calendar_picker.dart';

class AppDatePickerField extends StatelessWidget {
  final String? dateString;
  final String label;
  final String hintText;
  final ValueChanged<DateTime> onDateSelected;

  const AppDatePickerField({
    super.key,
    required this.dateString,
    required this.label,
    required this.hintText,
    required this.onDateSelected,
  });

  /// Returns {solar, lunar} or null if can't parse
  Map<String, String>? _parseDateParts() {
    if (dateString == null) return null;
    final parts = dateString!.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    try {
      final lunar =
          Lunar(createdFromSolar: true, date: DateTime(year, month, day));
      final sd = day.toString().padLeft(2, '0');
      final sm = month.toString().padLeft(2, '0');
      final ld = lunar.day.toString().padLeft(2, '0');
      final lm = lunar.month.toString().padLeft(2, '0');
      final leap = lunar.leapMonth == true ? ' Nhuận' : '';
      return {
        'solar': '$sd/$sm/$year',
        'lunar': '$ld/$lm$leap ÂL',
      };
    } catch (_) {
      return null;
    }
  }

  Widget _buildDisplayText(BuildContext context) {
    final parsed = _parseDateParts();
    if (parsed == null) {
      return Text(
        dateString ?? hintText,
        style: GoogleFonts.beVietnamPro(
          fontSize: 14,
          color: dateString != null
              ? context.textPrimary
              : context.textSecondary,
        ),
      );
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: parsed['solar'],
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          TextSpan(
            text: '  •  ${parsed['lunar']}',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: context.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final now = DateTime.now();
        DateTime? parsedDate;
        if (dateString != null) {
          final parts = dateString!.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            if (day != null && month != null && year != null) {
              parsedDate = DateTime(year, month, day);
            }
          }
          parsedDate ??= DateTime.tryParse(dateString!);
        }
        final initialDate =
            parsedDate != null && !parsedDate.isAfter(now) ? parsedDate : now;
        final picked = await showLunarCalendarPicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1800, 1, 1),
          lastDate: now,
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          fillColor: context.resolve(const Color(0xFFFCFAF8), AppColors.surfaceDark),
          filled: true,
          labelText: label.toUpperCase(),
          labelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: context.textSecondary,
            letterSpacing: 0.5,
          ),
          floatingLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: context.textSecondary,
            letterSpacing: 0.5,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.textSecondary.withValues(alpha: 0.2),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.primary, width: 1.2),
          ),
          suffixIcon: Icon(
            LucideIcons.calendar,
            size: 18,
            color: context.textSecondary,
          ),
        ),
        child: _buildDisplayText(context),
      ),
    );
  }
}

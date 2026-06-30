import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B6661),
              letterSpacing: 0.5,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            final now = DateTime.now();
            final initialDate = dateString != null
                ? (DateTime.tryParse(dateString!) ?? now)
                : now;
            picker.DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1800, 1, 1),
              maxTime: now,
              onConfirm: onDateSelected,
              currentTime: initialDate,
              locale: picker.LocaleType.vi,
              theme: picker.DatePickerTheme(
                headerColor: Colors.white,
                backgroundColor: Colors.white,
                itemStyle: GoogleFonts.beVietnamPro(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
                cancelStyle: GoogleFonts.beVietnamPro(
                  color: const Color(0xFF7A7571),
                  fontSize: 16,
                ),
                doneStyle: GoogleFonts.beVietnamPro(
                  color: AppColors.crimson,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          child: InputDecorator(
            decoration: InputDecoration(
              fillColor: const Color(0xFFFCFAF8),
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFEFEBE7), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.crimson, width: 1.2),
              ),
              suffixIcon: const Icon(
                LucideIcons.calendar,
                size: 18,
                color: Color(0xFF7A7571),
              ),
            ),
            child: Text(
              dateString ?? hintText,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: dateString != null
                    ? AppColors.textPrimary
                    : const Color(0xFFA5A09A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

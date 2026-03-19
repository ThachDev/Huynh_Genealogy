import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';

Future<bool?> showDeleteConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmLabel = 'Xóa ngay',
  String cancelLabel = 'Hủy',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.parchment,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Center(
        child: Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
            fontSize: 20,
          ),
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.inter(color: AppColors.textPrimary, height: 1.5),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelLabel,
            style: GoogleFonts.inter(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.crimson,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmLabel,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

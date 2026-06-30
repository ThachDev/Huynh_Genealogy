import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../theme/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      valueListenable: ValueNotifier<T?>(value),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      buttonStyleData: const FormFieldButtonStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 48,
        width: double.infinity,
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF7A7571)),
        openMenuIcon:
            Icon(LucideIcons.chevronUp, size: 18, color: Color(0xFF7A7571)),
      ),
      dropdownStyleData: DropdownStyleData(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        elevation: 8,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        selectedMenuItemBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2ECE7),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            child: child,
          );
        },
      ),
      style:
          GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        fillColor: const Color(0xFFFCFAF8),
        filled: true,
        contentPadding: EdgeInsets.zero,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEFEBE7), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.crimson, width: 1.2),
        ),
      ),
    );
  }
}

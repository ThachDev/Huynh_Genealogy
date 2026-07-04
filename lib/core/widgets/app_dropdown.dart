import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../theme/app_theme.dart';

class AppDropdown<T> extends StatefulWidget {
  final T value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool showSearchBox;
  final String searchHint;
  final String? label;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.showSearchBox = false,
    this.searchHint = 'Tìm kiếm...',
    this.label,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      valueListenable: ValueNotifier<T?>(widget.value),
      items: widget.items,
      onChanged: widget.onChanged,
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
        maxHeight: 250, // Khoảng 5 phần tử (48 * 5 = 240) + padding
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
      dropdownSearchData: widget.showSearchBox
          ? DropdownSearchData(
              searchController: textEditingController,
              searchBarWidgetHeight: 50,
              searchBarWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: widget.searchHint,
                    hintStyle: GoogleFonts.beVietnamPro(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFEFEBE7)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.crimson),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                final child = item.child;
                String itemText = '';
                if (child is Text) {
                  itemText = child.data ?? '';
                }
                return itemText
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            )
          : null,
      onMenuStateChange: (isOpen) {
        if (!isOpen && widget.showSearchBox) {
          textEditingController.clear();
        }
      },
      style:
          GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        fillColor: const Color(0xFFFCFAF8),
        filled: true,
        contentPadding: EdgeInsets.zero,
        labelText: widget.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B6661),
          letterSpacing: 0.5,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B6661),
          letterSpacing: 0.5,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
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

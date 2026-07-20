import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../resources/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';

class AppDropdown<T> extends StatefulWidget {
  final T value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool showSearchBox;
  final String? searchHint;
  final String? label;
  final double? buttonHeight;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.showSearchBox = false,
    this.searchHint,
    this.label,
    this.buttonHeight,
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
      buttonStyleData: FormFieldButtonStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: widget.buttonHeight ?? 48,
        width: double.infinity,
      ),
      iconStyleData: IconStyleData(
        icon: Icon(LucideIcons.chevronDown, size: 18, color: context.textSecondary),
        openMenuIcon:
            Icon(LucideIcons.chevronUp, size: 18, color: context.textSecondary),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.surface,
        ),
        elevation: 8,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        selectedMenuItemBuilder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.08),
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
                    hintText: widget.searchHint ?? AppLocalizations.of(context)!.searchHint,
                    hintStyle: GoogleFonts.beVietnamPro(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: context.textSecondary.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.primary),
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
          GoogleFonts.beVietnamPro(fontSize: 14, color: context.textPrimary),
      decoration: InputDecoration(
        fillColor: context.resolve(const Color(0xFFFCFAF8), AppColors.surfaceDark),
        filled: true,
        contentPadding: EdgeInsets.zero,
        labelText: widget.label,
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
      ),
    );
  }
}

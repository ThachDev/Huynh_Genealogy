import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Widget? flexibleSpace;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Widget? leading;

  // Search props
  final bool isSearching;
  final TextEditingController? searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchToggle;
  final VoidCallback? onSearchClear;

  // New: Filter while searching
  final VoidCallback? onFilterToggle;
  final bool isFilterActive;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.flexibleSpace,
    this.backgroundColor,
    this.bottom,
    this.leading,
    this.isSearching = false,
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchToggle,
    this.onSearchClear,
    this.onFilterToggle,
    this.isFilterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.wood,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ?? _buildDefaultLeading(context),
      title: _buildTitle(context),
      actions: isSearching ? [] : _buildActions(context),
      flexibleSpace: flexibleSpace ?? _buildDefaultFlexibleSpace(),
      bottom: bottom,
    );
  }

  Widget? _buildDefaultLeading(BuildContext context) {
    if (ModalRoute.of(context)?.canPop ?? false) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.gold,
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      );
    }
    return null;
  }

  Widget _buildTitle(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.2, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: isSearching
          ? Container(
              key: const ValueKey('appbar_search_bar'),
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: AppColors.gold, size: 18),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      onChanged: onSearchChanged,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: searchHint ?? 'Tìm kiếm...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ),
                  if (onFilterToggle != null) ...[
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: isFilterActive
                                ? Colors.redAccent
                                : AppColors.gold,
                            size: 18,
                          ),
                          if (isFilterActive)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: onFilterToggle,
                    ),
                  ],
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                    onPressed: () {
                      searchController?.clear();
                      onSearchClear?.call();
                    },
                  ),
                ],
              ),
            )
          : (title ??
                Text(
                  (titleText ?? '').toUpperCase(),
                  key: const ValueKey('appbar_title'),
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                )),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final list = <Widget>[];
    if (onSearchToggle != null) {
      list.add(
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.gold),
          onPressed: onSearchToggle,
        ),
      );
    }
    if (actions != null) {
      list.addAll(actions!);
    }
    if (list.isNotEmpty) {
      list.add(const SizedBox(width: 8));
    }
    return list;
  }

  Widget _buildDefaultFlexibleSpace() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/wood_dragon.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: AppColors.wood),
        ),
        Container(color: Colors.black.withValues(alpha: 0.3)),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

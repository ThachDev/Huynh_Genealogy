import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/services/geocoding_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Thanh tìm kiếm trên cùng của trang Bản đồ di tích
///
/// Hỗ trợ cả 2 chế độ:
/// - Overview Mode: Tìm kiếm địa điểm dòng họ trong gia phả
/// - Pinning Mode: Tìm kiếm địa danh OpenStreetMap kèm dropdown gợi ý
class HeritageMapSearchBar extends StatelessWidget {
  const HeritageMapSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onBack,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.isSearching = false,
    this.geocodingResults = const [],
    this.onSelectGeocodeResult,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final VoidCallback onBack;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool isSearching;
  final List<GeocodingResult> geocodingResults;
  final ValueChanged<GeocodingResult>? onSelectGeocodeResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 1. Nút Back
            Semantics(
              label: l10n.heritageMapBack,
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    LucideIcons.arrowLeft,
                    color: context.textPrimary,
                    size: 20,
                  ),
                  tooltip: l10n.heritageMapBack,
                  onPressed: onBack,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 2. Ô nhập tìm kiếm
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: context.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: 18,
                      color: context.primary,
                    ),
                    suffixIcon: isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : (controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(LucideIcons.x, size: 16),
                                onPressed: onClear,
                              )
                            : null),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                  ),
                  onTap: onTap,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
          ],
        ),

        // 3. Dropdown gợi ý kết quả tìm kiếm địa danh (khi có kết quả)
        if (geocodingResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: geocodingResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final item = geocodingResults[idx];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    LucideIcons.mapPin,
                    size: 16,
                    color: context.primary,
                  ),
                  title: Text(
                    item.name,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: context.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => onSelectGeocodeResult?.call(item),
                );
              },
            ),
          ),
      ],
    );
  }
}

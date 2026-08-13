import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../models/upcoming_anniversary.dart';
import '../widgets/anniversary_card.dart';

/// Trang hiển thị danh sách đầy đủ Ngày Giỗ / Sinh Nhật.
class UserAnniversaryListPage extends StatefulWidget {
  final String title;
  final List<UpcomingAnniversary> anniversaries;
  final bool isBirthday;

  const UserAnniversaryListPage({
    super.key,
    required this.title,
    required this.anniversaries,
    this.isBirthday = false,
  });

  @override
  State<UserAnniversaryListPage> createState() =>
      _UserAnniversaryListPageState();
}

class _UserAnniversaryListPageState extends State<UserAnniversaryListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedSort = 'nearest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UpcomingAnniversary> get _filteredList {
    final q = _query.trim().toLowerCase();
    var list = widget.anniversaries;
    if (q.isNotEmpty) {
      list = list
          .where((a) =>
              a.title.toLowerCase().contains(q) || a.solarDateLabel.contains(q))
          .toList();
    }

    if (_selectedSort == 'nearest') {
      list.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    } else {
      list.sort((a, b) => b.daysRemaining.compareTo(a.daysRemaining));
    }

    return list;
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 4),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: AppSearchBar(
            controller: _searchController,
            hintText: l10n.searchHint,
            onChanged: (value) => setState(() => _query = value),
            trailing: [
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    LucideIcons.listFilter,
                    size: 20,
                    color: context.textSecondary,
                  ),
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: context.surface,
                  elevation: 4,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'clear_all',
                      height: 38,
                      child: Row(
                        children: [
                          Icon(LucideIcons.filterX,
                              color: context.textPrimary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Bỏ chọn tất cả',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: context.textPrimary),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedSort = 'nearest';
                        });
                      },
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      enabled: false,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: StatefulBuilder(
                        builder: (context, setPopupState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Sắp xếp',
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: context.textPrimary)),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: CupertinoSlidingSegmentedControl<String>(
                                  backgroundColor: context.isDarkMode
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade200,
                                  thumbColor: context.isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.white,
                                  groupValue: _selectedSort,
                                  children: {
                                    'nearest': Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Gần nhất',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                    'furthest': Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Xa nhất',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                  },
                                  onValueChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedSort = value);
                                      setPopupState(() {});
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = _filteredList;

    return Scaffold(
      appBar: AppAppBar(title: widget.title),
      body: AppBackgroundBody(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: AppEmptyState(
                        icon: widget.anniversaries.isEmpty
                            ? (widget.isBirthday
                                ? LucideIcons.cake
                                : LucideIcons.flame)
                            : LucideIcons.searchX,
                        message: widget.anniversaries.isEmpty
                            ? (widget.isBirthday
                                ? l10n.noBirthdaysMessage
                                : l10n.noDeathAnniversariesMessage)
                            : l10n.noSearchResultsMessage,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final data = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnniversaryCard(data: data, fullWidth: true),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

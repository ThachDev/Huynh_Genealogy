import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../events/events.dart';
import '../widgets/user_event_card.dart';

/// Trang hiển thị danh sách đầy đủ Sự Kiện Dòng Tộc.
class UserEventListPage extends StatefulWidget {
  final int familyId;
  final bool isAdminMode;
  final List<EventEntity> events;

  const UserEventListPage({
    super.key,
    required this.familyId,
    required this.isAdminMode,
    required this.events,
  });

  @override
  State<UserEventListPage> createState() => _UserEventListPageState();
}

class _UserEventListPageState extends State<UserEventListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedSort = 'newest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EventEntity> get _filteredList {
    final q = _query.trim().toLowerCase();
    var list = widget.events;
    if (q.isNotEmpty) {
      list = list.where((e) =>
          e.title.toLowerCase().contains(q) ||
          (e.description?.toLowerCase().contains(q) ?? false) ||
          e.eventDate.contains(q))
          .toList();
    }
    
    if (_selectedSort == 'newest') {
      list.sort((a, b) => b.eventDate.compareTo(a.eventDate));
    } else {
      list.sort((a, b) => a.eventDate.compareTo(b.eventDate));
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
                                fontSize: 13,
                                color: context.textPrimary),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedSort = 'newest';
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                    'newest': Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Mới nhất',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                    'oldest': Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Cũ nhất',
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
      appBar: AppAppBar(title: l10n.eventsListTitle),
      body: AppBackgroundBody(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: AppEmptyState(
                        icon: widget.events.isEmpty
                            ? LucideIcons.calendarDays
                            : LucideIcons.searchX,
                        message: widget.events.isEmpty
                            ? l10n.noEventsMessage
                            : l10n.noSearchResultsMessage,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final event = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: UserEventCard(
                            familyId: widget.familyId,
                            isAdminMode: widget.isAdminMode,
                            event: event,
                          ),
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

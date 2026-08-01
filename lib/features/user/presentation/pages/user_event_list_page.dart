import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EventEntity> get _filteredList {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.events;
    return widget.events
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            (e.description?.toLowerCase().contains(q) ?? false) ||
            e.eventDate.contains(q))
        .toList();
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 25, 4),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              hintStyle: GoogleFonts.inter(
                fontSize: 13,
                color: context.textSecondary.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                LucideIcons.search,
                size: 18,
                color: context.textSecondary,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        LucideIcons.x,
                        size: 16,
                        color: context.textSecondary,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: context.accent.withValues(alpha: 0.6),
                    width: 1.2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: context.accent.withValues(alpha: 0.6),
                    width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.accent, width: 1.5),
              ),
            ),
            onChanged: (value) => setState(() => _query = value),
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

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../events/events.dart';
import '../widgets/user_event_card.dart';

/// Trang hiển thị danh sách đầy đủ Sự Kiện Dòng Tộc.
class UserEventListPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppAppBar(title: l10n.eventsListTitle),
      body: AppBackgroundBody(
        child: events.isEmpty
            ? Center(
                child: AppEmptyState(
                  icon: LucideIcons.calendarDays,
                  message: l10n.noEventsMessage,
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return UserEventCard(
                    familyId: familyId,
                    isAdminMode: isAdminMode,
                    event: event,
                  );
                },
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../models/upcoming_anniversary.dart';
import '../widgets/anniversary_card.dart';

/// Trang hiển thị danh sách đầy đủ Ngày Giỗ / Sinh Nhật.
class UserAnniversaryListPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppAppBar(title: title),
      body: AppBackgroundBody(
        child: anniversaries.isEmpty
            ? Center(
                child: AppEmptyState(
                  icon: isBirthday
                      ? LucideIcons.cake
                      : LucideIcons.flame,
                  message: isBirthday
                      ? l10n.noBirthdaysMessage
                      : l10n.noDeathAnniversariesMessage,
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                itemCount: anniversaries.length,
                itemBuilder: (context, index) {
                  final data = anniversaries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnniversaryCard(data: data, fullWidth: true),
                  );
                },
              ),
      ),
    );
  }
}

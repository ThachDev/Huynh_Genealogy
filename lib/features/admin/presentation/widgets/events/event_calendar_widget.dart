import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';

class EventCalendarWidget extends StatefulWidget {
  final String eventDate;
  final Color badgeColor;
  final AppLocalizations l10n;

  const EventCalendarWidget({
    super.key,
    required this.eventDate,
    required this.badgeColor,
    required this.l10n,
  });

  @override
  State<EventCalendarWidget> createState() => _EventCalendarWidgetState();
}

class _EventCalendarWidgetState extends State<EventCalendarWidget> {
  bool _showLunar = false;

  String _getDay(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return parts[2];
      }
    } catch (_) {}
    return '--';
  }

  String _getMonthYear(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final monthYearStr = _getMonthYear(widget.eventDate);
    final monthStr = monthYearStr.split('/').first;
    final monthInt = int.tryParse(monthStr) ?? monthStr;
    final solarDay = _getDay(widget.eventDate);
    final solarYear = monthYearStr.contains('/')
        ? monthYearStr.substring(monthYearStr.indexOf('/') + 1)
        : monthYearStr;

    String lunarDay = '--';
    String lunarMonthLabel = '--';
    String lunarYear = '';
    try {
      final parts = widget.eventDate.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);
        if (year != null && month != null && day != null) {
          final solarDate = DateTime(year, month, day);
          final lunar = Lunar(createdFromSolar: true, date: solarDate);
          final leap = lunar.leapMonth == true ? ' Nhuận' : '';
          lunarDay = '${lunar.day}';
          lunarMonthLabel = 'Tháng ${lunar.month}$leap';
          lunarYear = '${lunar.year}';
        }
      }
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        setState(() {
          _showLunar = !_showLunar;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.badgeColor.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<bool>(_showLunar),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: _showLunar ? context.accent : widget.badgeColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),
                ),
                child: Text(
                  _showLunar ? lunarMonthLabel : 'Tháng $monthInt',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: _showLunar
                    ? Column(
                        key: const ValueKey<String>('lunar'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lunarDay,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.accent,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            lunarYear,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            widget.l10n.lunarCalendar.toLowerCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 7.5,
                              color: context.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        key: const ValueKey<String>('solar'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            solarDay,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: widget.badgeColor,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            solarYear,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

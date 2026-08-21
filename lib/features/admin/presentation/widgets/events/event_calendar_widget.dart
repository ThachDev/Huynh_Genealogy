import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';

class EventCalendarWidget extends StatefulWidget {

  const EventCalendarWidget({
    super.key,
    required this.eventDate,
    this.isLunarDefault = false,
    this.l10n,
    this.primaryColor,
    this.lunarColor,
  });
  final String eventDate;
  final bool isLunarDefault;
  final AppLocalizations? l10n;
  final Color? primaryColor;
  final Color? lunarColor;

  @override
  State<EventCalendarWidget> createState() => _EventCalendarWidgetState();
}

class _EventCalendarWidgetState extends State<EventCalendarWidget> {
  late bool _showLunar;

  @override
  void initState() {
    super.initState();
    _showLunar = widget.isLunarDefault;
  }

  @override
  void didUpdateWidget(covariant EventCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLunarDefault != widget.isLunarDefault) {
      _showLunar = widget.isLunarDefault;
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          final year = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final day = int.tryParse(parts[2]);
          if (year != null && month != null && day != null) {
            return DateTime(year, month, day);
          }
        }
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length >= 2) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = parts.length >= 3
              ? (int.tryParse(parts[2]) ?? DateTime.now().year)
              : DateTime.now().year;
          if (day != null && month != null) {
            return DateTime(year, month, day);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  String _getDay(String dateStr) {
    final dt = _parseDate(dateStr);
    if (dt != null) return '${dt.day}';
    return '--';
  }

  String _getMonthYear(String dateStr) {
    final dt = _parseDate(dateStr);
    if (dt != null) return '${dt.month}/${dt.year}';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
      final solarDate = _parseDate(widget.eventDate);
      if (solarDate != null) {
        final lunar = Lunar(createdFromSolar: true, date: solarDate);
        final leap = lunar.leapMonth == true ? l10n.leapMonthInline : '';
        lunarDay = '${lunar.day}';
        lunarMonthLabel = l10n.lunarMonthLabelFormat(leap, lunar.month);
        lunarYear = '${lunar.year}';
      }
    } catch (_) {}

    final defaultPrimary = widget.primaryColor ?? context.primary;
    final defaultLunar = widget.lunarColor ?? context.accent;
    final activeColor = _showLunar ? defaultLunar : defaultPrimary;

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
            color: context.accent.withValues(alpha: 0.12),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),
                ),
                child: Text(
                  _showLunar ? lunarMonthLabel : l10n.monthLabelFormat(monthInt),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (child, animation) {
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: defaultLunar,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                lunarYear,
                                style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  color: context.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                (widget.l10n ?? l10n).lunarCalendar.toLowerCase(),
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 7,
                                  color: defaultLunar,
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: defaultPrimary,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                solarYear,
                                style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  color: context.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../resources/app_localizations.dart';
import '../theme/theme_extensions.dart';

Future<DateTime?> showLunarCalendarPicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final now = DateTime.now();
  return showDialog<DateTime>(
    context: context,
    barrierColor: context.isDarkMode
        ? Colors.black54
        : Colors.black.withValues(alpha: 0.3),
    builder: (_) => _LunarCalendarPickerDialog(
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1800, 1, 1),
      lastDate: lastDate ?? now,
    ),
  );
}

class _LunarCalendarPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _LunarCalendarPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_LunarCalendarPickerDialog> createState() =>
      _LunarCalendarPickerDialogState();
}

class _LunarCalendarPickerDialogState
    extends State<_LunarCalendarPickerDialog> {
  late DateTime _displayMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  void _prevMonth() {
    final prev = DateTime(_displayMonth.year, _displayMonth.month - 1);
    if (!prev
        .isBefore(DateTime(widget.firstDate.year, widget.firstDate.month))) {
      setState(() => _displayMonth = prev);
    }
  }

  void _nextMonth() {
    final next = DateTime(_displayMonth.year, _displayMonth.month + 1);
    if (!next.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month))) {
      setState(() => _displayMonth = next);
    }
  }

  String _lunarDay(DateTime solar) {
    try {
      final lunar = Lunar(createdFromSolar: true, date: solar);
      final day = lunar.day.toString();
      final month = lunar.month.toString();
      if (lunar.day == 1) return '1/$month';
      return day;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: context.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 14),
            _buildDayLabels(context),
            const SizedBox(height: 6),
            _buildCalendarGrid(context),
            const SizedBox(height: 16),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final monthName = DateFormat.MMMM(locale).format(
      DateTime(_displayMonth.year, _displayMonth.month),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _prevMonth,
          icon: const Icon(Icons.chevron_left_rounded),
          color: context.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        GestureDetector(
          onTap: _showYearMonthPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$monthName ${_displayMonth.year}',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: context.textSecondary),
            ],
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right_rounded),
          color: context.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildDayLabels(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final start = DateTime(2024, 1, 1);
    final labels = List.generate(7, (i) {
      return DateFormat.E(locale).format(start.add(Duration(days: i)));
    });
    return Row(
      children: labels.map((label) {
        final isSun = label == 'CN' || label == 'Sun';
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSun ? context.primary : context.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    int startWeekday = firstDay.weekday - 1;
    final daysInMonth =
        DateUtils.getDaysInMonth(_displayMonth.year, _displayMonth.month);

    final cells = <Widget>[];
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      cells.add(_buildDayCell(context, date));
    }

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final end = (i + 7 > cells.length) ? cells.length : i + 7;
      final rowCells = cells.sublist(i, end);
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox.shrink());
      }
      rows.add(Row(
        children: rowCells.map((c) => Expanded(child: c)).toList(),
      ));
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(date, now);
    final isSelected =
        _selectedDate != null && DateUtils.isSameDay(date, _selectedDate!);
    final isAfterLastDate = date.isAfter(widget.lastDate);
    final isBeforeFirstDate = date.isBefore(widget.firstDate);
    final isDisabled = isAfterLastDate || isBeforeFirstDate;
    final isSunday = date.weekday == DateTime.sunday;

    Color solarColor;
    if (isDisabled) {
      solarColor = context.textSecondary.withValues(alpha: 0.4);
    } else if (isSunday && !isSelected) {
      solarColor = context.primary;
    } else if (isSelected) {
      solarColor = context.textOnPrimary;
    } else {
      solarColor = context.textPrimary;
    }

    final lunarLabel = _lunarDay(date);

    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedDate = date),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primary
              : isToday && !isSelected
                  ? context.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isToday && !isSelected
              ? Border.all(color: context.primary, width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              date.day.toString(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                fontWeight:
                    isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                color: solarColor,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              lunarLabel,
              style: GoogleFonts.beVietnamPro(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? context.textOnPrimary.withValues(alpha: 0.85)
                    : isDisabled
                        ? context.textSecondary.withValues(alpha: 0.4)
                        : context.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: context.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              l10n.cancelLabel,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedDate != null
                ? () => Navigator.pop(context, _selectedDate)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: context.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n.selectDate,
              style: GoogleFonts.beVietnamPro(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _showYearMonthPicker() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        int pickerYear = _displayMonth.year;
        int pickerMonth = _displayMonth.month;
        return StatefulBuilder(builder: (ctx2, setInner) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.selectMonthYear,
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                              initialItem: pickerMonth - 1),
                          onSelectedItemChanged: (idx) =>
                              setInner(() => pickerMonth = idx + 1),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 12,
                            builder: (ctx3, idx) {
                              final locale =
                                  Localizations.localeOf(ctx3).languageCode;
                              final monthName =
                                  DateFormat.MMMM(locale).format(
                                DateTime(2024, idx + 1),
                              );
                              return Center(
                                child: Text(
                                  monthName,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 15,
                                    fontWeight: pickerMonth == idx + 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: pickerMonth == idx + 1
                                        ? context.primary
                                        : context.textPrimary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                              initialItem:
                                  pickerYear - widget.firstDate.year),
                          onSelectedItemChanged: (idx) => setInner(
                              () => pickerYear =
                                  idx + widget.firstDate.year),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: widget.lastDate.year -
                                widget.firstDate.year +
                                1,
                            builder: (ctx3, idx) {
                              final y = idx + widget.firstDate.year;
                              return Center(
                                child: Text(
                                  '$y',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 15,
                                    fontWeight: pickerYear == y
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: pickerYear == y
                                        ? context.primary
                                        : context.textPrimary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() =>
                          _displayMonth =
                              DateTime(pickerYear, pickerMonth));
                      Navigator.pop(ctx2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      foregroundColor: context.textOnPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      l10n.confirmLabel,
                      style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

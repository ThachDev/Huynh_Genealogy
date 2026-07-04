import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnlunar/vnlunar.dart';
import '../theme/app_theme.dart';

/// Shows the custom lunar-solar calendar picker dialog.
/// Returns the selected [DateTime] (solar) or null if dismissed.
Future<DateTime?> showLunarCalendarPicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final now = DateTime.now();
  return showDialog<DateTime>(
    context: context,
    barrierColor: Colors.black54,
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
  late DateTime _displayMonth; // Month being displayed in the grid
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  // Go to previous month
  void _prevMonth() {
    final prev = DateTime(_displayMonth.year, _displayMonth.month - 1);
    if (!prev
        .isBefore(DateTime(widget.firstDate.year, widget.firstDate.month))) {
      setState(() => _displayMonth = prev);
    }
  }

  // Go to next month
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
      // Show month label only on 1st lunar day or new month crossover
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
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildDayLabels(),
            const SizedBox(height: 6),
            _buildCalendarGrid(),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final monthNames = [
      '',
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _prevMonth,
          icon: const Icon(Icons.chevron_left_rounded),
          color: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        GestureDetector(
          onTap: _showYearMonthPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${monthNames[_displayMonth.month]} ${_displayMonth.year}',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: AppColors.textSecondary),
            ],
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right_rounded),
          color: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildDayLabels() {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Row(
      children: labels.map((label) {
        final isSun = label == 'CN';
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSun ? AppColors.crimson : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    // Calculate starting weekday (Mon=1, Sun=7)
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    // weekday: Mon=1..Sun=7, we need Mon as 0-indexed first col
    int startWeekday = firstDay.weekday - 1; // Mon=0, Sun=6

    final daysInMonth =
        DateUtils.getDaysInMonth(_displayMonth.year, _displayMonth.month);

    // Build list of day cells
    final cells = <Widget>[];
    // Leading empty cells
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      cells.add(_buildDayCell(date));
    }

    // Build rows (7 columns)
    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final end = (i + 7 > cells.length) ? cells.length : i + 7;
      final rowCells = cells.sublist(i, end);
      // Pad last row
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox.shrink());
      }
      rows.add(Row(
        children: rowCells.map((c) => Expanded(child: c)).toList(),
      ));
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(DateTime date) {
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
      solarColor = const Color(0xFFCCCCCC);
    } else if (isSunday && !isSelected) {
      solarColor = AppColors.crimson;
    } else if (isSelected) {
      solarColor = Colors.white;
    } else {
      solarColor = AppColors.textPrimary;
    }

    final lunarLabel = _lunarDay(date);

    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedDate = date),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.crimson
              : isToday && !isSelected
                  ? AppColors.crimson.withValues(alpha: 0.08)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.crimson, width: 1)
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
                    ? Colors.white.withValues(alpha: 0.85)
                    : isDisabled
                        ? const Color(0xFFCCCCCC)
                        : AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Huỷ',
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
              backgroundColor: AppColors.crimson,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Chọn ngày',
              style: GoogleFonts.beVietnamPro(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// Dropdown to jump year & month quickly
  void _showYearMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                  'Chọn tháng và năm',
                  style: GoogleFonts.beVietnamPro(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Month picker
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
                            builder: (ctx3, idx) => Center(
                              child: Text(
                                'Tháng ${idx + 1}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 15,
                                  fontWeight: pickerMonth == idx + 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: pickerMonth == idx + 1
                                      ? AppColors.crimson
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Year picker
                    Expanded(
                      child: SizedBox(
                        height: 180,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                              initialItem: pickerYear - widget.firstDate.year),
                          onSelectedItemChanged: (idx) => setInner(
                              () => pickerYear = idx + widget.firstDate.year),
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
                                        ? AppColors.crimson
                                        : AppColors.textPrimary,
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
                          _displayMonth = DateTime(pickerYear, pickerMonth));
                      Navigator.pop(ctx2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.crimson,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Xác nhận',
                      style:
                          GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
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

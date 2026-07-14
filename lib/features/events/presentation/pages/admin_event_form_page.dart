import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../events.dart';

class AdminEventFormPage extends StatefulWidget {
  final int familyId;
  final EventEntity? event;

  const AdminEventFormPage({super.key, required this.familyId, this.event});

  @override
  State<AdminEventFormPage> createState() => _AdminEventFormPageState();
}

class _AdminEventFormPageState extends State<AdminEventFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLunar = false;
  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description ?? '';
      _isLunar = widget.event!.isLunar;
      _selectedDate = widget.event!.eventDate;
      _dateController.text = _formatUIDate(widget.event!.eventDate);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatUIDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return dateStr;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isNotEmpty
          ? DateTime.tryParse(_selectedDate) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primary,
              onPrimary: Colors.white,
              onSurface: context.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        _selectedDate =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _dateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate.isEmpty) {
      AppSnackBar.error(context, l10n.selectEventDateError);
      return;
    }

    final event = EventEntity(
      id: widget.event?.id ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      eventDate: _selectedDate,
      isLunar: _isLunar,
      familyId: widget.familyId,
    );

    context.read<EventsBloc>().add(SaveEventEvent(event: event));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.event != null;
    final title = isEdit ? l10n.editEventTitle : l10n.addEventTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: title,
      ),
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsSubmitSuccess) {
            Navigator.pop(context, true);
          } else if (state is EventsError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is EventsSubmitting) {
            return const Center(child: AppLoading(size: 80));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Card(
                color: context.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: context.accent.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề sự kiện
                      AppOutlineTextField(
                        controller: _titleController,
                        label: l10n.eventNameLabel,
                        hintText: l10n.eventNameHint,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return l10n.eventNameRequired;
                          }
                          if (val.trim().length < 2) {
                            return l10n.eventNameMinLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Chọn ngày
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: AppOutlineTextField(
                            controller: _dateController,
                            label: l10n.eventDateFormLabel,
                            hintText: l10n.selectDateHint,
                            suffixIcon: const Icon(LucideIcons.calendar),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return l10n.selectDateRequired;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Toggle âm lịch
                      Row(
                        children: [
                          Text(
                            l10n.useLunarCalendar,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _isLunar,
                            activeTrackColor: context.primary,
                            onChanged: (val) => setState(() => _isLunar = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mô tả
                      AppOutlineTextField(
                        controller: _descriptionController,
                        label: l10n.eventDescriptionLabel,
                        hintText: l10n.eventDescriptionHint,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),

                      // Nút lưu
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: AppButton(
                          label: l10n.saveEventButton,
                          onPressed: _submitForm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

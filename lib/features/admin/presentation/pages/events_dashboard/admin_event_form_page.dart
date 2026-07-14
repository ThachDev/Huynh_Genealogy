import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../admin.dart';
import '../../../../../core/domain/entity/event_entity.dart';

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
  final _contentController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLunar = false;
  String _selectedDate = '';
  String _type = 'event';
  String? _localImagePath;

  final ImagePicker _picker = ImagePicker();

  // ── Type options ─────────────────────────────────────────────────────────────
  List<DropdownItem<String>> get _typeItems => const [
        DropdownItem(value: 'event', child: Text('Sự kiện')),
        DropdownItem(value: 'article', child: Text('Bài viết / Tin tức')),
        DropdownItem(value: 'announcement', child: Text('Thông báo dòng họ')),
        DropdownItem(
            value: 'anniversary', child: Text('Ngày giỗ chạp / Kỷ niệm')),
      ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description ?? '';
      _contentController.text = widget.event!.content ?? '';
      _locationController.text = widget.event!.location ?? '';
      _organizerController.text = widget.event!.organizer ?? '';
      _isLunar = widget.event!.isLunar;
      _selectedDate = widget.event!.eventDate;
      _type = widget.event!.type;
      _localImagePath = widget.event!.imageUrl;
      _dateController.text = _formatUIDate(widget.event!.eventDate);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String _formatUIDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {}
    return dateStr;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final tempDir = await getTemporaryDirectory();
        final ext = pickedFile.name.contains('.')
            ? pickedFile.name.substring(pickedFile.name.lastIndexOf('.'))
            : '.jpg';
        final fileName =
            'event_banner_${DateTime.now().millisecondsSinceEpoch}$ext';
        final savedFile =
            await File(pickedFile.path).copy('${tempDir.path}/$fileName');
        setState(() => _localImagePath = savedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking banner image: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isNotEmpty
          ? DateTime.tryParse(_selectedDate) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.primary,
            onPrimary: Colors.white,
            onSurface: context.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
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
      content: _contentController.text.trim().isEmpty
          ? null
          : _contentController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      organizer: _organizerController.text.trim().isEmpty
          ? null
          : _organizerController.text.trim(),
      imageUrl: _localImagePath,
      type: _type,
      eventDate: _selectedDate,
      isLunar: _isLunar,
      familyId: widget.familyId,
    );

    context.read<EventsBloc>().add(SaveEventEvent(event: event));
  }

  // ── Reusable field builders (same style as AdminMemberFormPage) ──────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return AppOutlineTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      suffixIcon: suffixIcon,
      validator: validator,
      enabled: enabled,
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? label,
  }) {
    return AppDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      label: label,
    );
  }

  Widget _buildSectionCard({
    IconData? icon,
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFF2ECE7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.02),
              Colors.transparent,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null && title != null) ...[
            Row(
              children: [
                Icon(icon, size: 20, color: context.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
          ...children,
        ],
      ),
    );
  }

  // ── Banner picker widget ─────────────────────────────────────────────────────

  Widget _buildBannerPicker() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.isDarkMode
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFF2ECE7),
            width: 1.2,
          ),
          image: _localImagePath != null
              ? DecorationImage(
                  image: FileImage(File(_localImagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _localImagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.image,
                      size: 40, color: context.textSecondary),
                  const SizedBox(height: 8),
                  Text(
                    'Chọn ảnh bìa sự kiện / bài viết',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.camera,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Thay đổi ảnh',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.event != null;
    final title = isEdit ? l10n.editEventTitle : l10n.addEventTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: title, automaticallyImplyLeading: false),
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

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── 1 card duy nhất ────────────────────────────────────
                        _buildSectionCard(
                          children: [
                            // Ảnh bìa
                            _buildBannerPicker(),
                            const SizedBox(height: 20),

                            // Phân loại
                            _buildDropdown<String>(
                              label: 'Phân loại',
                              value: _type,
                              items: _typeItems,
                              onChanged: (val) {
                                if (val != null) setState(() => _type = val);
                              },
                            ),
                            const SizedBox(height: 16),

                            // Tiêu đề
                            _buildTextField(
                              controller: _titleController,
                              label: _type == 'article'
                                  ? 'Tiêu đề bài viết'
                                  : l10n.eventNameLabel,
                              hintText: _type == 'article'
                                  ? 'Nhập tiêu đề bài viết...'
                                  : l10n.eventNameHint,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return _type == 'article'
                                      ? 'Vui lòng nhập tiêu đề bài viết'
                                      : l10n.eventNameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Người tổ chức / Tác giả
                            _buildTextField(
                              controller: _organizerController,
                              label: _type == 'article'
                                  ? 'Tác giả'
                                  : 'Người tổ chức / Đơn vị host',
                              hintText: _type == 'article'
                                  ? 'Nhập tên tác giả bài viết...'
                                  : 'Nhập người tổ chức (Ban trị sự...)',
                            ),
                            const SizedBox(height: 16),

                            // Ngày
                            GestureDetector(
                              onTap: _selectDate,
                              child: AbsorbPointer(
                                child: _buildTextField(
                                  controller: _dateController,
                                  label: _type == 'article'
                                      ? 'Ngày đăng bài'
                                      : l10n.eventDateFormLabel,
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
                            const SizedBox(height: 12),

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
                                  onChanged: (val) =>
                                      setState(() => _isLunar = val),
                                ),
                              ],
                            ),

                            // Địa điểm (chỉ cho event / anniversary)
                            if (_type == 'event' || _type == 'anniversary') ...[
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _locationController,
                                label: 'Địa điểm tổ chức',
                                hintText:
                                    'Nhập địa điểm (Nhà thờ tổ, Khách sạn...)',
                              ),
                            ],
                            const SizedBox(height: 16),

                            // Mô tả ngắn
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Mô tả ngắn',
                              hintText: 'Nhập mô tả ngắn gọn...',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),

                            // Nội dung chi tiết
                            _buildTextField(
                              controller: _contentController,
                              label: 'Nội dung chi tiết',
                              hintText:
                                  'Nhập nội dung đầy đủ bài viết hoặc chi tiết sự kiện...',
                              maxLines: 8,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Sticky bottom bar ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                decoration: BoxDecoration(
                  color: context.background,
                  boxShadow: [
                    BoxShadow(
                      color: context.resolve(
                        Colors.black.withValues(alpha: 0.06),
                        Colors.transparent,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppFormActionButtons(
                  saveLabel: l10n.saveEventButton,
                  onSave: _submitForm,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

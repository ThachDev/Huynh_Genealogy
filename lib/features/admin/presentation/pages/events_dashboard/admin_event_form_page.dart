import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  bool _isLunar = false;
  String _selectedDate = '';
  String _displayDate = '';
  String _type = 'event';
  String? _localImagePath;

  // Show/hide expanded fields
  bool _showOrganizerField = false;

  final ImagePicker _picker = ImagePicker();

  // ── Type config ───────────────────────────────────────────────────────────────
  static const _typeConfig = {
    'event': (
      label: 'Sự kiện',
      icon: LucideIcons.calendar,
      color: Color(0xFF1877F2),
    ),
    'article': (
      label: 'Bài viết / Tin tức',
      icon: LucideIcons.bookOpen,
      color: Color(0xFF2E7D32),
    ),
    'announcement': (
      label: 'Thông báo',
      icon: LucideIcons.megaphone,
      color: Color(0xFFE65100),
    ),
    'anniversary': (
      label: 'Giỗ chạp / Kỷ niệm',
      icon: LucideIcons.heart,
      color: Color(0xFF6A1B9A),
    ),
  };

  Color get _typeColor => _typeConfig[_type]?.color ?? const Color(0xFF1877F2);
  IconData get _typeIcon => _typeConfig[_type]?.icon ?? LucideIcons.calendar;
  String get _typeLabel => _typeConfig[_type]?.label ?? 'Sự kiện';
  bool get _showLocation => _type == 'event' || _type == 'anniversary';

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      final e = widget.event!;
      _titleController.text = e.title;
      _descriptionController.text = e.description ?? '';
      _contentController.text = e.content ?? '';
      _locationController.text = e.location ?? '';
      _organizerController.text = e.organizer ?? '';
      _isLunar = e.isLunar;
      _selectedDate = e.eventDate;
      _displayDate = _formatUIDate(e.eventDate);
      _type = e.type;
      _localImagePath = e.imageUrl;
      _showOrganizerField = e.organizer?.isNotEmpty == true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
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
        maxWidth: 1280,
        maxHeight: 960,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final tempDir = await getTemporaryDirectory();
        final ext = pickedFile.name.contains('.')
            ? pickedFile.name.substring(pickedFile.name.lastIndexOf('.'))
            : '.jpg';
        final savedFile = await File(pickedFile.path).copy(
            '${tempDir.path}/event_banner_${DateTime.now().millisecondsSinceEpoch}$ext');
        setState(() => _localImagePath = savedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
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
        _displayDate =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _showTypeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chọn loại bài đăng',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._typeConfig.entries.map((entry) {
              final isSelected = _type == entry.key;
              return ListTile(
                onTap: () {
                  setState(() => _type = entry.key);
                  Navigator.pop(ctx);
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: entry.value.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(entry.value.icon,
                      color: entry.value.color, size: 20),
                ),
                title: Text(
                  entry.value.label,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? entry.value.color : context.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? Icon(LucideIcons.checkCircle2,
                        color: entry.value.color, size: 20)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                tileColor: isSelected
                    ? entry.value.color.withValues(alpha: 0.06)
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate.isEmpty) {
      AppSnackBar.error(context, l10n.selectEventDateError);
      return;
    }
    context.read<EventsBloc>().add(SaveEventEvent(
          event: EventEntity(
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
          ),
        ));
  }

  // ── Widgets ──────────────────────────────────────────────────────────────────

  /// Type pill tapped → open sheet
  Widget _buildTypePill() {
    return GestureDetector(
      onTap: _showTypeSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _typeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _typeColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_typeIcon, size: 13, color: _typeColor),
            const SizedBox(width: 5),
            Text(
              _typeLabel,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _typeColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronsUpDown, size: 11, color: _typeColor),
          ],
        ),
      ),
    );
  }

  /// Tag chip (date, location, lunar)
  Widget _buildTag({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
    VoidCallback? onRemove,
  }) {
    final c = color ?? context.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: c),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: c,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onRemove,
                child: Icon(LucideIcons.x, size: 11, color: c),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Clean text area (no outline border — composer style)
  Widget _buildComposerField({
    required TextEditingController controller,
    required String hint,
    TextStyle? style,
    int? maxLines,
    int? minLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines ?? 1,
      validator: validator,
      style: style ??
          GoogleFonts.beVietnamPro(fontSize: 15, color: context.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.beVietnamPro(
            fontSize: 15, color: context.textSecondary.withValues(alpha: 0.55)),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );
  }

  /// Toolbar button (photo, location, etc.)
  Widget _buildToolbarBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: active ? color : context.textSecondary),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? color : context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.event != null;
    final pageTitle = isEdit ? l10n.editEventTitle : l10n.addEventTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: pageTitle, automaticallyImplyLeading: false),
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
              // ── Scrollable composer area ─────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header: avatar + type pill ──────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            children: [
                              // Admin avatar
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: _typeColor.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(_typeIcon,
                                    size: 20, color: _typeColor),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ban quản trị',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  _buildTypePill(),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ── Title (large, no border) ────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                          child: _buildComposerField(
                            controller: _titleController,
                            hint: _type == 'article'
                                ? 'Tiêu đề bài viết...'
                                : 'Tên sự kiện...',
                            minLines: 1,
                            maxLines: 3,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return _type == 'article'
                                    ? 'Vui lòng nhập tiêu đề'
                                    : l10n.eventNameRequired;
                              }
                              return null;
                            },
                          ),
                        ),

                        // ── Mô tả / tóm tắt ────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: _buildComposerField(
                            controller: _descriptionController,
                            hint: 'Thêm mô tả ngắn...',
                            minLines: 1,
                            maxLines: 4,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: context.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),

                        // ── Nội dung chi tiết ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: _buildComposerField(
                            controller: _contentController,
                            hint: 'Nội dung chi tiết (nếu có)...',
                            minLines: 2,
                            maxLines: 20,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: context.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ),

                        // ── Người tổ chức / tác giả ─────────────────────────────
                        if (_showOrganizerField) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                            child: Row(
                              children: [
                                Icon(
                                  _type == 'article'
                                      ? LucideIcons.user
                                      : LucideIcons.users,
                                  size: 14,
                                  color: context.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _buildComposerField(
                                    controller: _organizerController,
                                    hint: _type == 'article'
                                        ? 'Tên tác giả...'
                                        : 'Người / đơn vị tổ chức...',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: context.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ── Địa điểm ────────────────────────────────────────────
                        if (_showLocation &&
                                _locationController.text.isNotEmpty ||
                            (_showLocation && _showOrganizerField)) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                            child: Row(
                              children: [
                                Icon(LucideIcons.mapPin,
                                    size: 14, color: Colors.red.shade400),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _buildComposerField(
                                    controller: _locationController,
                                    hint: 'Địa điểm tổ chức...',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: context.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ── Active metadata tags ─────────────────────────────────
                        if (_displayDate.isNotEmpty ||
                            _isLunar ||
                            (_showLocation &&
                                _locationController.text.isNotEmpty &&
                                !_showOrganizerField)) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (_displayDate.isNotEmpty)
                                  _buildTag(
                                    icon: LucideIcons.calendar,
                                    label: _displayDate,
                                    color: const Color(0xFF1877F2),
                                    onTap: _selectDate,
                                    onRemove: () => setState(() {
                                      _selectedDate = '';
                                      _displayDate = '';
                                    }),
                                  ),
                                if (_isLunar)
                                  _buildTag(
                                    icon: LucideIcons.moon,
                                    label: 'Âm lịch',
                                    color: Colors.amber.shade800,
                                    onRemove: () =>
                                        setState(() => _isLunar = false),
                                  ),
                              ],
                            ),
                          ),
                        ],

                        // ── Image preview ────────────────────────────────────────
                        if (_localImagePath != null) ...[
                          const SizedBox(height: 12),
                          Stack(
                            children: [
                              Image.file(
                                File(_localImagePath!),
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                              // Remove button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _localImagePath = null),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.55),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(LucideIcons.x,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              // Change photo button
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.55),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(LucideIcons.camera,
                                            size: 13, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Thay ảnh',
                                          style: GoogleFonts.beVietnamPro(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),

                        // ── Divider ─────────────────────────────────────────────
                        Divider(
                          height: 1,
                          color: context.accent.withValues(alpha: 0.12),
                        ),

                        // ── Quick-action toolbar ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildToolbarBtn(
                                  icon: LucideIcons.image,
                                  label: 'Ảnh',
                                  color: Colors.green,
                                  active: _localImagePath != null,
                                  onTap: _pickImage,
                                ),
                                _buildToolbarBtn(
                                  icon: LucideIcons.calendarDays,
                                  label: _displayDate.isEmpty
                                      ? 'Ngày'
                                      : _displayDate,
                                  color: const Color(0xFF1877F2),
                                  active: _displayDate.isNotEmpty,
                                  onTap: _selectDate,
                                ),
                                if (_showLocation)
                                  _buildToolbarBtn(
                                    icon: LucideIcons.mapPin,
                                    label: 'Địa điểm',
                                    color: Colors.red,
                                    active: _locationController.text.isNotEmpty,
                                    onTap: () => setState(
                                        () => _showOrganizerField = true),
                                  ),
                                _buildToolbarBtn(
                                  icon: LucideIcons.user,
                                  label: _type == 'article'
                                      ? 'Tác giả'
                                      : 'Tổ chức',
                                  color: Colors.deepPurple,
                                  active: _showOrganizerField,
                                  onTap: () => setState(
                                      () => _showOrganizerField = true),
                                ),
                                _buildToolbarBtn(
                                  icon: LucideIcons.moon,
                                  label: 'Âm lịch',
                                  color: Colors.amber.shade800,
                                  active: _isLunar,
                                  onTap: () =>
                                      setState(() => _isLunar = !_isLunar),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Divider(
                          height: 1,
                          color: context.accent.withValues(alpha: 0.12),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Sticky bottom bar ─────────────────────────────────────────────
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

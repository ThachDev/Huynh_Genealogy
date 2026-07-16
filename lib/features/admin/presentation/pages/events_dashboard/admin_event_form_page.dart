import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/theme/app_theme.dart';
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

  final ImagePicker _picker = ImagePicker();

  // ── Type config ───────────────────────────────────────────────────────────────
  // Màu dùng AppColors của hệ thống: primary (crimson) và accent (gold)
  static const _typeIcons = {
    'event': LucideIcons.calendar,
    'article': LucideIcons.bookOpen,
    'announcement': LucideIcons.megaphone,
    'anniversary': LucideIcons.heart,
  };

  static const _typeLabels = {
    'event': 'Sự kiện',
    'article': 'Bài viết / Tin tức',
    'announcement': 'Thông báo',
    'anniversary': 'Giỗ chạp / Kỷ niệm',
  };

  IconData get _typeIcon => _typeIcons[_type] ?? LucideIcons.calendar;
  String get _typeLabel => _typeLabels[_type] ?? 'Sự kiện';
  // Tất cả loại dùng context.primary (crimson) — nhất quán với theme hệ thống
  // iconColor của row sẽ lấy từ context sẵn có trong build()
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
    DateTime? parsedDate;
    if (_displayDate.isNotEmpty) {
      final parts = _displayDate.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          parsedDate = DateTime(year, month, day);
        }
      }
    }
    final picked = await showLunarCalendarPicker(
      context: context,
      initialDate: parsedDate ?? DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2100),
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
                  color: ctx.textSecondary.withValues(alpha: 0.3),
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
                color: ctx.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._typeIcons.entries.map((entry) {
              final isSelected = _type == entry.key;
              final label = _typeLabels[entry.key] ?? entry.key;
              return ListTile(
                onTap: () {
                  setState(() => _type = entry.key);
                  Navigator.pop(ctx);
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ctx.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(entry.value, color: ctx.primary, size: 20),
                ),
                title: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? ctx.primary : ctx.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? Icon(LucideIcons.checkCircle2,
                        color: ctx.primary, size: 20)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                tileColor:
                    isSelected ? ctx.primary.withValues(alpha: 0.06) : null,
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

  // ── Build helpers ─────────────────────────────────────────────────────────────

  /// TikTok-style section row with leading icon, title, optional trailing widget
  Widget _buildRow({
    required IconData icon,
    required String label,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    final ic = iconColor ?? context.textSecondary;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: ic),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                trailing ??
                    Icon(LucideIcons.chevronRight,
                        size: 18,
                        color: context.textSecondary.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 50,
            endIndent: 0,
            color: context.textSecondary.withValues(alpha: 0.1),
          ),
      ],
    );
  }

  /// Composer top section: text fields + thumbnail
  Widget _buildComposerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: text fields
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        maxLines: 2,
                        minLines: 1,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return _type == 'article'
                                ? 'Vui lòng nhập tiêu đề'
                                : 'Vui lòng nhập tên sự kiện';
                          }
                          return null;
                        },
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          hintText: _type == 'article'
                              ? 'Tiêu đề bài viết...'
                              : 'Tên sự kiện...',
                          hintStyle: GoogleFonts.beVietnamPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color:
                                context.textSecondary.withValues(alpha: 0.45),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        minLines: 2,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textSecondary,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Thêm mô tả...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: context.textSecondary.withValues(alpha: 0.4),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right: thumbnail + "Chọn ảnh" button
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.textSecondary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: context.textSecondary.withValues(alpha: 0.15),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _localImagePath != null
                      ? Image.file(
                          File(_localImagePath!),
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        )
                      : Center(
                          child: Icon(
                            LucideIcons.image,
                            size: 28,
                            color:
                                context.textSecondary.withValues(alpha: 0.35),
                          ),
                        ),
                ),
                // "Chọn ảnh" label at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                    ),
                    child: Text(
                      _localImagePath != null ? 'Thay ảnh' : 'Chọn ảnh',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_localImagePath != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => setState(() => _localImagePath = null),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.x,
                            size: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
              // ── Scrollable body ────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // ── Composer: title + description + thumbnail ────────────
                      _buildComposerSection(),
                      const SizedBox(height: 12),
                      Divider(
                        height: 1,
                        color: context.textSecondary.withValues(alpha: 0.1),
                      ),

                      // ── Row: Loại bài đăng ───────────────────────────────────
                      _buildRow(
                        icon: _typeIcon,
                        label: _typeLabel,
                        iconColor: context.primary,
                        showDivider: false,
                        onTap: _showTypeSheet,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.chevronRight,
                                size: 16,
                                color: context.textSecondary
                                    .withValues(alpha: 0.5)),
                          ],
                        ),
                      ),

                      // ── Row: Ngày tổ chức ─────────────────────────────────
                      _buildRow(
                        icon: LucideIcons.calendarDays,
                        label: _displayDate.isEmpty
                            ? 'Chọn ngày tổ chức'
                            : _displayDate,
                        iconColor: context.accent,
                        showDivider: false,
                        onTap: _selectDate,
                        trailing: _displayDate.isNotEmpty
                            ? GestureDetector(
                                onTap: () => setState(() {
                                  _selectedDate = '';
                                  _displayDate = '';
                                }),
                                child: Icon(LucideIcons.x,
                                    size: 16,
                                    color: context.textSecondary
                                        .withValues(alpha: 0.5)),
                              )
                            : null,
                      ),

                      // ── Row: Địa điểm (chỉ hiện cho event/anniversary) ───────
                      if (_showLocation)
                        _buildRow(
                          icon: LucideIcons.mapPin,
                          label: _locationController.text.isEmpty
                              ? 'Thêm địa điểm'
                              : _locationController.text,
                          iconColor: AppColors.error,
                          showDivider: false,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: context.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (ctx) => Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom:
                                      MediaQuery.of(ctx).viewInsets.bottom + 24,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: ctx.textSecondary
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    AppOutlineTextField(
                                      controller: _locationController,
                                      label: 'Địa điểm',
                                      hintText: 'Nhập địa điểm...',
                                      prefixIcon: const Icon(LucideIcons.mapPin,
                                          color: AppColors.error, size: 18),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {});
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text('Xong'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      // ── Row: Người tổ chức / tác giả ────────────────────────
                      _buildRow(
                        icon: _type == 'article'
                            ? LucideIcons.user
                            : LucideIcons.users,
                        label: _organizerController.text.isEmpty
                            ? (_type == 'article'
                                ? 'Thêm tác giả'
                                : 'Người / đơn vị tổ chức')
                            : _organizerController.text,
                        iconColor: context.primary,
                        showDivider: false,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: context.surface,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (ctx) => Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                                bottom:
                                    MediaQuery.of(ctx).viewInsets.bottom + 24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: ctx.textSecondary
                                            .withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AppOutlineTextField(
                                    controller: _organizerController,
                                    label: _type == 'article'
                                        ? 'Tác giả'
                                        : 'Người / đơn vị tổ chức',
                                    hintText: _type == 'article'
                                        ? 'Tên tác giả...'
                                        : 'Tên người / đơn vị...',
                                    prefixIcon: Icon(
                                        _type == 'article'
                                            ? LucideIcons.user
                                            : LucideIcons.users,
                                        color: ctx.primary,
                                        size: 18),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {});
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Xong'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ── Sticky bottom bar ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                decoration: BoxDecoration(
                  color: context.background,
                  border: Border(
                    top: BorderSide(
                      color: context.textSecondary.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
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

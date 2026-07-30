import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../../../events/events.dart';

class AdminEventDetailPage extends StatefulWidget {
  final int familyId;
  final EventEntity event;

  const AdminEventDetailPage({
    super.key,
    required this.familyId,
    required this.event,
  });

  @override
  State<AdminEventDetailPage> createState() => _AdminEventDetailPageState();
}

class _AdminEventDetailPageState extends State<AdminEventDetailPage> {
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
  bool _isReadOnly = true;

  final ImagePicker _picker = ImagePicker();

  static const _typeIcons = {
    'event': LucideIcons.calendar,
    'article': LucideIcons.bookOpen,
    'announcement': LucideIcons.megaphone,
  };

  Map<String, String> _typeLabels(AppLocalizations l10n) => {
        'event': l10n.eventTypeEvent,
        'article': l10n.eventTypeArticle,
        'announcement': l10n.eventTypeAnnouncement,
      };

  IconData get _typeIcon => _typeIcons[_type] ?? LucideIcons.calendar;
  String _typeLabel(AppLocalizations l10n) =>
      _typeLabels(l10n)[_type] ?? l10n.eventTypeEvent;
  bool get _showLocation => _type == 'event';

  @override
  void initState() {
    super.initState();
    _isReadOnly = true;
    _initData();
  }

  void _initData() {
    final e = widget.event;
    _titleController.text = e.title;
    _descriptionController.text = e.description ?? '';
    _contentController.text = e.content ?? '';
    _locationController.text = e.location ?? '';
    _organizerController.text = e.organizer ?? '';
    _isLunar = e.isLunar;
    _selectedDate = e.eventDate;
    _displayDate = _formatUIDate(e.eventDate);
    _type = e.type == 'anniversary' ? 'event' : e.type;
    _localImagePath = e.imageUrl;
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

  String _formatUIDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {}
    return dateStr;
  }

  String _formatFullDateDisplay(AppLocalizations l10n) {
    if (_selectedDate.isEmpty) return '';
    try {
      final parts = _selectedDate.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        final dt = DateTime(year, month, day);
        final solarStr =
            'Ngày ${dt.day.toString().padLeft(2, '0')} tháng ${dt.month.toString().padLeft(2, '0')}, năm ${dt.year}';
        final lunarStr = LunarDateHelper.getLunarDateString(dt, l10n);
        return '$solarStr ($lunarStr)';
      }
    } catch (_) {}
    return _displayDate;
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
    final l10n = AppLocalizations.of(context)!;
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
              l10n.selectPostType,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ctx.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._typeIcons.entries.map((entry) {
              final isSelected = _type == entry.key;
              final label = _typeLabels(l10n)[entry.key] ?? entry.key;
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
            id: widget.event.id,
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

  Future<void> _onDeleteEvent() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(
          l10n.deleteEventTitle,
          style: GoogleFonts.beVietnamPro(color: ctx.textPrimary),
        ),
        content: Text(
          l10n.deleteEventConfirm(widget.event.title),
          style: GoogleFonts.inter(color: ctx.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelLabel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteLabel),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<EventsBloc>().add(
            DeleteEventEvent(
              id: widget.event.id,
              familyId: widget.familyId,
            ),
          );
    }
  }

  Widget _buildReaderView(AppLocalizations l10n) {
    final hasImage =
        _localImagePath != null && _localImagePath!.trim().isNotEmpty;
    final isNetwork = hasImage &&
        (_localImagePath!.startsWith('http://') ||
            _localImagePath!.startsWith('https://'));
    final isLocal =
        hasImage && !isNetwork && File(_localImagePath!).existsSync();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image
          if (hasImage)
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: context.surface,
              ),
              child: isNetwork
                  ? Image.network(
                      _localImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    )
                  : (isLocal
                      ? Image.file(
                          File(_localImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink()),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type & Date Tag
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_typeIcon, size: 14, color: context.primary),
                          const SizedBox(width: 6),
                          Text(
                            _typeLabel(l10n).toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isLunar) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Lịch Âm Gia Tộc',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: context.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),

                // Article Title
                Text(
                  _titleController.text,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),

                // Meta Info Box (Date, Location, Author)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.textSecondary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.calendar,
                              size: 15, color: context.accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _formatFullDateDisplay(l10n),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                color: context.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_locationController.text.isNotEmpty) ...[
                        const Divider(height: 16),
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin,
                                size: 15, color: AppColors.error),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _locationController.text,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13,
                                  color: context.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (_organizerController.text.isNotEmpty) ...[
                        const Divider(height: 16),
                        Row(
                          children: [
                            Icon(LucideIcons.user,
                                size: 15, color: context.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${_type == 'article' ? 'Tác giả' : 'Ban tổ chức'}: ${_organizerController.text}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13,
                                  color: context.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                if (_descriptionController.text.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    _descriptionController.text,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],

                if (_contentController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Divider(
                    color: context.textSecondary.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _contentController.text,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: context.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(AppLocalizations l10n) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker area
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: context.textSecondary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: _localImagePath != null &&
                              _localImagePath!.isNotEmpty
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: _localImagePath!.startsWith('http')
                                      ? Image.network(
                                          _localImagePath!,
                                          width: double.infinity,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(_localImagePath!),
                                          width: double.infinity,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _localImagePath = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(LucideIcons.x,
                                          size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.imagePlus,
                                    size: 32, color: context.primary),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.eventPickPhoto,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.primary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Post Type Selection Tile
                  ListTile(
                    onTap: _showTypeSheet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: context.textSecondary.withValues(alpha: 0.2),
                      ),
                    ),
                    tileColor: context.surface,
                    leading: Icon(_typeIcon, color: context.primary),
                    title: Text(
                      'Loại bài đăng: ${_typeLabel(l10n)}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  ),
                  const SizedBox(height: 16),

                  // Title Field
                  AppOutlineTextField(
                    controller: _titleController,
                    label: 'Tiêu đề bài viết *',
                    hintText: 'Nhập tiêu đề sự kiện hoặc tin tức',
                    prefixIcon: const Icon(LucideIcons.heading, size: 18),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Date Picker Tile
                  ListTile(
                    onTap: _selectDate,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: context.textSecondary.withValues(alpha: 0.2),
                      ),
                    ),
                    tileColor: context.surface,
                    leading: const Icon(LucideIcons.calendarDays,
                        color: Colors.blue),
                    title: Text(
                      _displayDate.isEmpty
                          ? 'Chọn ngày diễn ra / Ngày đăng *'
                          : 'Ngày: $_displayDate',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    trailing: Switch(
                      value: _isLunar,
                      activeThumbColor: context.accent,
                      onChanged: (val) {
                        setState(() {
                          _isLunar = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (_showLocation) ...[
                    AppOutlineTextField(
                      controller: _locationController,
                      label: l10n.eventLocationLabel,
                      hintText: l10n.eventLocationHint,
                      prefixIcon: const Icon(LucideIcons.mapPin,
                          color: AppColors.error, size: 18),
                    ),
                    const SizedBox(height: 14),
                  ],

                  AppOutlineTextField(
                    controller: _organizerController,
                    label: _type == 'article' ? 'Tác giả' : 'Ban tổ chức',
                    hintText: 'Nhập tên người tạo hoặc đơn vị tổ chức',
                    prefixIcon: const Icon(LucideIcons.user, size: 18),
                  ),
                  const SizedBox(height: 14),

                  AppOutlineTextField(
                    controller: _descriptionController,
                    label: 'Mô tả ngắn',
                    hintText: 'Tóm tắt nội dung chính bài viết',
                    maxLines: 3,
                    prefixIcon: const Icon(LucideIcons.alignLeft, size: 18),
                  ),
                  const SizedBox(height: 14),

                  AppOutlineTextField(
                    controller: _contentController,
                    label: 'Nội dung chi tiết',
                    hintText: 'Nhập nội dung đầy đủ bài viết...',
                    maxLines: 6,
                    prefixIcon: const Icon(LucideIcons.fileText, size: 18),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // Bottom Action Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: context.background,
            border: Border(
              top: BorderSide(
                color: context.textSecondary.withValues(alpha: 0.12),
              ),
            ),
          ),
          child: AppFormActionButtons(
            saveLabel: l10n.saveEventButton,
            onSave: _submitForm,
            onCancel: () {
              setState(() {
                _isReadOnly = true;
                _initData();
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');
    final pageTitle = _isReadOnly ? l10n.eventDetailTitle : l10n.editEventTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: pageTitle,
        automaticallyImplyLeading: true,
        actions: [
          if (_isReadOnly && canEdit) ...[
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.red),
              onPressed: _onDeleteEvent,
            ),
            IconButton(
              icon: Icon(LucideIcons.edit3, color: context.accent),
              onPressed: () {
                setState(() {
                  _isReadOnly = false;
                });
              },
            ),
          ],
        ],
      ),
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsSubmitSuccess) {
            AppSnackBar.success(context, state.message);
            Navigator.pop(context, true);
          } else if (state is EventsError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is EventsSubmitting) {
            return const Center(child: AppLoading(size: 80));
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isReadOnly ? _buildReaderView(l10n) : _buildEditForm(l10n),
          );
        },
      ),
    );
  }
}

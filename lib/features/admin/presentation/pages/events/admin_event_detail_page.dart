import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../core/theme/theme_extensions.dart';
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
  bool get _showBannerPicker => _type != 'announcement';
  bool get _showOrganizer => _type != 'announcement';

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
        final yearShort = dt.year.toString().substring(2);
        final solarStr =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/$yearShort';
        final lunar = Lunar(createdFromSolar: true, date: dt);
        final lunarDay = lunar.day.toString().padLeft(2, '0');
        final lunarMonth = lunar.month.toString().padLeft(2, '0');
        final leap = lunar.leapMonth == true ? ' Nhuận' : '';
        return '$solarStr ($lunarDay/$lunarMonth$leap AL)';
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

  String _formattedDateDisplayEdit(AppLocalizations l10n) {
    if (_displayDate.isEmpty) return l10n.eventSelectDate;
    final parts = _displayDate.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        final parsedDate = DateTime(year, month, day);
        if (_type == 'event') {
          final lunarStr = LunarDateHelper.getLunarDateString(parsedDate, l10n);
          return '$_displayDate ($lunarStr)';
        }
      }
    }
    return _displayDate;
  }

  Widget _buildSectionCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
        ),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: _typeIcons.entries.map((entry) {
        final key = entry.key;
        final icon = entry.value;
        final label = _typeLabels(l10n)[key] ?? key;
        final isSelected = _type == key;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _type = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? context.primary
                      : context.textSecondary.withValues(alpha: 0.15),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color:
                        isSelected ? context.primary : context.textSecondary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? context.primary
                          : context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageBannerPickerEdit(BuildContext context, AppLocalizations l10n) {
    final isNetwork = _localImagePath != null &&
        (_localImagePath!.startsWith('http://') ||
            _localImagePath!.startsWith('https://'));
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.textSecondary.withValues(alpha: 0.04),
          border: Border.all(
            color: context.textSecondary.withValues(alpha: 0.18),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _localImagePath != null && _localImagePath!.isNotEmpty
            ? Stack(
                children: [
                  Positioned.fill(
                    child: isNetwork
                        ? Image.network(
                            _localImagePath!,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            File(_localImagePath!),
                            fit: BoxFit.contain,
                          ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _localImagePath = null),
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
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.camera,
                              size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            l10n.eventChangePhoto,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.imagePlus,
                      size: 24,
                      color: context.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.eventPickPhoto,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Định dạng JPG, PNG (Tối đa 5MB)',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }


  bool get _hasChanges =>
      _titleController.text.trim() != widget.event.title ||
      _contentController.text.trim() != (widget.event.content ?? '') ||
      _locationController.text.trim() != (widget.event.location ?? '') ||
      _organizerController.text.trim() != (widget.event.organizer ?? '') ||
      _localImagePath != widget.event.imageUrl ||
      _selectedDate != widget.event.eventDate ||
      _type != (widget.event.type == 'anniversary' ? 'event' : widget.event.type);

  Future<void> _confirmCancel(AppLocalizations l10n) async {
    if (!_hasChanges) {
      setState(() {
        _isReadOnly = true;
        _initData();
      });
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(
          'Huỷ chỉnh sửa?',
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            color: ctx.textPrimary,
          ),
        ),
        content: Text(
          'Các thay đổi chưa lưu sẽ bị mất.',
          style: GoogleFonts.beVietnamPro(color: ctx.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelLabel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Huỷ chỉnh sửa'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() {
        _isReadOnly = true;
        _initData();
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
    context.read<EventsBloc>().add(SaveEventEvent(
          event: EventEntity(
            id: widget.event.id,
            title: _titleController.text.trim(),
            description: null,
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

    final mainContentText = _contentController.text.trim();
    final descriptionText = _descriptionController.text.trim();
    final displayBodyText =
        mainContentText.isNotEmpty ? mainContentText : descriptionText;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Banner Image framed neatly in card style
          if (hasImage)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ColoredBox(
                    color: context.surface,
                    child: isNetwork
                        ? Image.network(
                            _localImagePath!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          )
                        : (isLocal
                            ? Image.file(
                                File(_localImagePath!),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const SizedBox.shrink(),
                              )
                            : const SizedBox.shrink()),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Editorial Headline Title
                Text(
                  _titleController.text,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                // 3. Byline: "Bởi [Author]   •   📍 [Location]"
                Row(
                  children: [
                    Text(
                      'Bởi ',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: context.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      _organizerController.text.isNotEmpty
                          ? _organizerController.text
                          : 'Ban Quản Trị',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    if (_locationController.text.isNotEmpty) ...[
                      Text(
                        '  •  ',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      const Icon(LucideIcons.mapPin,
                          size: 13, color: AppColors.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _locationController.text,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: context.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),

                // 4. Meta Row: Type Chip / Date
                Row(
                  children: [
                    Text(
                      _typeLabel(l10n),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                    Text(
                      '  •  ',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _formatFullDateDisplay(l10n),
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12.5,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Divider(
                  color: context.textSecondary.withValues(alpha: 0.15),
                  height: 1,
                ),
                const SizedBox(height: 20),

                // Article Main Body Content
                if (displayBodyText.isNotEmpty)
                  Text(
                    displayBodyText,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14.5,
                      color: context.textPrimary,
                      height: 1.65,
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(AppLocalizations l10n) {
    final dateSectionTitle = _type == 'announcement'
        ? 'Ngày phát thông báo'
        : 'Thời gian & Địa điểm';

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
                  // Section 1: Loại bài đăng
                  _buildSectionCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(
                          context,
                          l10n.selectPostType,
                          LucideIcons.layers,
                        ),
                        _buildTypeSelector(context, l10n),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 2: Thông tin cơ bản
                  _buildSectionCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(
                          context,
                          'Thông tin cơ bản',
                          LucideIcons.fileText,
                        ),
                        if (_showBannerPicker) ...[
                          _buildImageBannerPickerEdit(context, l10n),
                          const SizedBox(height: 16),
                        ],
                        AppOutlineTextField(
                          controller: _titleController,
                          label: _type == 'announcement'
                              ? 'Tiêu đề thông báo'
                              : 'Tên sự kiện / Bài viết',
                          hintText: _type == 'announcement'
                              ? 'Nhập tiêu đề thông báo ngắn gọn...'
                              : l10n.eventTitleHint,
                          prefixIcon: Icon(_typeIcon, size: 18),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return _type == 'announcement'
                                  ? 'Vui lòng nhập tiêu đề thông báo'
                                  : l10n.eventTitleRequired;
                            }
                            return null;
                          },
                        ),
                        if (_showOrganizer) ...[
                          const SizedBox(height: 14),
                          AppOutlineTextField(
                            controller: _organizerController,
                            label: _type == 'article'
                                ? 'Tác giả'
                                : 'Ban tổ chức / Người chủ trì',
                            hintText:
                                'Nhập tên người chủ trì hoặc ban tổ chức...',
                            prefixIcon:
                                const Icon(LucideIcons.user, size: 18),
                          ),
                        ],
                        const SizedBox(height: 14),
                        AppOutlineTextField(
                          controller: _contentController,
                          label: _type == 'announcement'
                              ? 'Nội dung thông báo'
                              : 'Nội dung & Lịch trình',
                          hintText: _type == 'announcement'
                              ? 'Nhập nội dung chi tiết thông báo gửi đến gia tộc...'
                              : 'Nhập nội dung chi tiết bài viết, lịch trình sự kiện...',
                          minLines: 4,
                          maxLines: 10,
                          validator: (val) {
                            if (_type == 'announcement' &&
                                (val == null || val.trim().isEmpty)) {
                              return 'Vui lòng nhập nội dung thông báo';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section 3: Thời gian & Địa điểm
                  _buildSectionCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(
                          context,
                          dateSectionTitle,
                          LucideIcons.calendarClock,
                        ),
                        InkWell(
                          onTap: _selectDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.textSecondary
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.calendarDays,
                                  size: 18,
                                  color: context.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _formattedDateDisplayEdit(l10n),
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 14,
                                      fontWeight: _displayDate.isNotEmpty
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: _displayDate.isNotEmpty
                                          ? context.textPrimary
                                          : context.textSecondary,
                                    ),
                                  ),
                                ),
                                if (_displayDate.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _selectedDate = '';
                                      _displayDate = '';
                                    }),
                                    child: Icon(
                                      LucideIcons.x,
                                      size: 16,
                                      color: context.textSecondary,
                                    ),
                                  )
                                else
                                  Icon(
                                    LucideIcons.chevronRight,
                                    size: 18,
                                    color: context.textSecondary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_showLocation) ...[
                          const SizedBox(height: 14),
                          AppOutlineTextField(
                            controller: _locationController,
                            label: l10n.eventLocationLabel,
                            hintText: l10n.eventLocationHint,
                            prefixIcon: Icon(
                              LucideIcons.mapPin,
                              color: context.primary,
                              size: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // Bottom Action Bar
        Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          decoration: BoxDecoration(
            color: Colors.transparent,
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
            onCancel: () => _confirmCancel(l10n),
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
      backgroundColor: Colors.transparent,
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
      body: AppBackgroundBody(
        child: BlocConsumer<EventsBloc, EventsState>(
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
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.topCenter,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
              child:
                  _isReadOnly ? _buildReaderView(l10n) : _buildEditForm(l10n),
            );
          },
        ),
      ),
    );
  }
}

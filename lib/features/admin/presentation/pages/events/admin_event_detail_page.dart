import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/utils/file_size_guard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../../../events/events.dart';

class AdminEventDetailPage extends StatefulWidget {

  const AdminEventDetailPage({
    super.key,
    required this.familyId,
    required this.event,
    this.isUserView = false,
  });
  final int familyId;
  final EventEntity event;
  final bool isUserView;

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
    'announcement': LucideIcons.megaphone,
  };

  Map<String, String> _typeLabels(AppLocalizations l10n) => {
        'event': l10n.eventTypeEvent,
        'announcement': l10n.eventTypeAnnouncement,
      };

  IconData get _typeIcon => _typeIcons[_type] ?? LucideIcons.calendar;
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
        final leap = lunar.leapMonth == true ? l10n.leapMonthInline : '';
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
        if (await exceedsMaxFileSize(pickedFile, 10)) {
          if (!mounted) return;
          AppSnackBar.error(
              context, AppLocalizations.of(context).imageTooLargeFormat(10));
          return;
        }
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? context.primary : context.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? context.primary
                      : context.textSecondary.withValues(alpha: 0.2),
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isSelected ? Colors.white : context.textSecondary,
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
                      color: isSelected ? Colors.white : context.textSecondary,
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

  Widget _buildImageBannerPickerEdit(
      BuildContext context, AppLocalizations l10n) {
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
          color: context.surface,
          border: Border.all(
            color: context.textSecondary.withValues(alpha: 0.2),
            width: 1.2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _localImagePath != null && _localImagePath!.isNotEmpty
            ? Stack(
                children: [
                  Positioned.fill(
                    child: isNetwork
                        ? AppNetworkImage(
                            url: _localImagePath!,
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
                    l10n.eventImageFormatHint,
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
      _type !=
          (widget.event.type == 'anniversary' ? 'event' : widget.event.type);

  Future<void> _confirmCancel(AppLocalizations l10n) async {
    if (!_hasChanges) {
      setState(() {
        _isReadOnly = true;
        _initData();
      });
      return;
    }
    final confirm = await AppDialog.confirm(
      context,
      title: l10n.eventDiscardChangesTitle,
      message: l10n.eventDiscardChangesMessage,
      confirmLabel: l10n.eventDiscardChangesAction,
      cancelLabel: l10n.cancelLabel,
      type: AppDialogType.danger,
    );
    if (confirm == true && mounted) {
      setState(() {
        _isReadOnly = true;
        _initData();
      });
    }
  }

  void _submitForm() {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate.isEmpty) {
      AppSnackBar.error(context, l10n.selectEventDateError);
      return;
    }
    context.read<EventsBloc>().add(SaveEventEvent(
          event: EventEntity(
            id: widget.event.id,
            title: _titleController.text.trim(),
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
    final l10n = AppLocalizations.of(context);
    final confirm = await AppDialog.confirm(
      context,
      title: l10n.deleteEventTitle,
      message: l10n.deleteEventConfirm(widget.event.title),
      confirmLabel: l10n.deleteLabel,
      cancelLabel: l10n.cancelLabel,
      type: AppDialogType.danger,
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
    final authorName = _organizerController.text.trim().isNotEmpty
        ? _organizerController.text.trim()
        : l10n.adminBoard;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.resolve(
              const Color(0xFFE8D4C8),
              context.textSecondary.withValues(alpha: 0.2),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: context.resolve(
                Colors.black.withValues(alpha: 0.04),
                Colors.transparent,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Facebook-style Author Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  // Author Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.resolve(
                            Colors.grey.shade300, Colors.grey.shade700),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: context.primary.withValues(alpha: 0.1),
                      child: Text(
                        authorName.isNotEmpty
                            ? authorName.substring(0, 1).toUpperCase()
                            : 'G',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Name + Date metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorName,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatFullDateDisplay(l10n),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Location badge if available
                  if (_locationController.text.trim().isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.mapPin,
                              size: 12, color: context.primary),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: Text(
                              _locationController.text.trim(),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: context.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── 2. Post Title & Text Content ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _titleController.text.trim(),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                      height: 1.35,
                    ),
                  ),

                  // Body Content
                  if (displayBodyText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      displayBodyText,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14.5,
                        color: context.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── 3. Post Image/Banner (Facebook Feed Style) ──
            if (hasImage)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 380),
                    color: context.resolve(
                      Colors.grey.shade100,
                      const Color(0xFF1E1E1E),
                    ),
                    child: isNetwork
                        ? AppNetworkImage(
                            url: _localImagePath!,
                            errorBuilder: (_) => const SizedBox.shrink(),
                          )
                        : (isLocal
                            ? Image.file(
                                File(_localImagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const SizedBox.shrink(),
                              )
                            : const SizedBox.shrink()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(AppLocalizations l10n) {
    return SingleChildScrollView(
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

            // Section 2: Thông tin cơ bản (Bao gồm Ngày và Địa điểm)
            _buildSectionCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    context,
                    l10n.basicInfoSectionTitle,
                    LucideIcons.fileText,
                  ),
                  if (_showBannerPicker) ...[
                    _buildImageBannerPickerEdit(context, l10n),
                    const SizedBox(height: 16),
                  ],
                  AppOutlineTextField(
                    controller: _titleController,
                    label: _type == 'announcement'
                        ? l10n.eventTitleLabelAnnouncement
                        : l10n.eventTitleLabelEventArticle,
                    hintText: _type == 'announcement'
                        ? l10n.eventTitleHintAnnouncement
                        : l10n.eventTitleHint,
                    prefixIcon: Icon(_typeIcon, size: 18),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return _type == 'announcement'
                            ? l10n.eventTitleRequiredAnnouncement
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
                          ? l10n.eventAuthorLabel
                          : l10n.eventOrganizerLabelFull,
                      hintText: l10n.eventOrganizerHintFull,
                      prefixIcon: const Icon(LucideIcons.user, size: 18),
                    ),
                  ],
                  const SizedBox(height: 14),

                  // Thời gian diễn ra / đăng bài
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.textSecondary.withValues(alpha: 0.2),
                          width: 1.2,
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

                  // Địa điểm (nếu là sự kiện)
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

                  const SizedBox(height: 14),
                  AppOutlineTextField(
                    controller: _contentController,
                    label: _type == 'announcement'
                        ? l10n.eventContentLabelAnnouncement
                        : l10n.eventContentLabelEventArticle,
                    hintText: _type == 'announcement'
                        ? l10n.eventContentHintAnnouncement
                        : l10n.eventContentHintEventArticle,
                    minLines: 4,
                    maxLines: 10,
                    validator: (val) {
                      if (_type == 'announcement' &&
                          (val == null || val.trim().isEmpty)) {
                        return l10n.eventContentRequiredAnnouncement;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final canEdit = !widget.isUserView &&
        authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');
    final pageTitle = _isReadOnly ? l10n.eventDetailTitle : l10n.editEventTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: pageTitle,
        leading: !_isReadOnly
            ? IconButton(
                icon: const Icon(LucideIcons.arrowLeft),
                onPressed: () => _confirmCancel(l10n),
              )
            : null,
        actions: [
          if (_isReadOnly && canEdit) ...[
            IconButton(
              icon: Icon(LucideIcons.trash2, color: context.primary),
              tooltip: l10n.deleteLabel,
              onPressed: _onDeleteEvent,
            ),
            IconButton(
              icon: Icon(LucideIcons.edit3, color: context.textPrimary),
              tooltip: l10n.editLabel,
              onPressed: () {
                setState(() {
                  _isReadOnly = false;
                });
              },
            ),
          ] else if (!_isReadOnly) ...[
            IconButton(
              icon: Icon(LucideIcons.check, color: context.textPrimary),
              tooltip: l10n.formSave,
              onPressed: _submitForm,
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

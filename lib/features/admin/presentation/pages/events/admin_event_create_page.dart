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
import '../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../../../events/events.dart';

class AdminEventCreatePage extends StatefulWidget {
  final int familyId;

  const AdminEventCreatePage({super.key, required this.familyId});

  @override
  State<AdminEventCreatePage> createState() => _AdminEventCreatePageState();
}

class _AdminEventCreatePageState extends State<AdminEventCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();

  final bool _isLunar = false;
  String _selectedDate = '';
  String _displayDate = '';
  String _type = 'event';
  String? _localImagePath;

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
  bool get _showLocation => _type == 'event';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _organizerController.text = authState.user.fullName;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  String _formattedDateDisplay(AppLocalizations l10n) {
    if (_displayDate.isEmpty) return l10n.eventSelectDate;
    final parts = _displayDate.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        final parsedDate = DateTime(year, month, day);
        final lunarStr = LunarDateHelper.getLunarDateString(parsedDate, l10n);
        return '$_displayDate ($lunarStr)';
      }
    }
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

  void _submitForm() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate.isEmpty) {
      AppSnackBar.error(context, l10n.selectEventDateError);
      return;
    }

    final authState = context.read<AuthBloc>().state;
    final authorName = _organizerController.text.trim().isNotEmpty
        ? _organizerController.text.trim()
        : (authState is Authenticated ? authState.user.fullName : null);

    final contentText = _contentController.text.trim();

    context.read<EventsBloc>().add(SaveEventEvent(
          event: EventEntity(
            id: 0,
            title: _titleController.text.trim(),
            description: contentText.isEmpty ? null : contentText,
            content: contentText.isEmpty ? null : contentText,
            location: _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
            organizer: authorName,
            imageUrl: _localImagePath,
            type: _type,
            eventDate: _selectedDate,
            isLunar: _isLunar,
            familyId: widget.familyId,
          ),
        ));
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(AppLocalizations l10n) {
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
                color: isSelected
                    ? context.primary.withValues(alpha: 0.18)
                    : context.surface.withValues(alpha: 0.3),
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
                    color: isSelected ? context.primary : context.textSecondary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isSelected ? context.primary : context.textSecondary,
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

  Widget _buildImageBannerPicker(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.textSecondary.withValues(alpha: 0.06),
          border: Border.all(
            color: context.textSecondary.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _localImagePath != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(_localImagePath!),
                    fit: BoxFit.cover,
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
                      size: 28,
                      color: context.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.eventPickPhoto,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppAppBar(
        title: l10n.addEventTitle,
        automaticallyImplyLeading: false,
      ),
      body: AppBackgroundBody(
        child: BlocConsumer<EventsBloc, EventsState>(
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
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Khối 1: Chọn loại bài đăng
                          _buildSectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                  l10n.selectPostType,
                                  LucideIcons.layers,
                                ),
                                _buildTypeSelector(l10n),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Khối 2: Ảnh bìa & Thông tin bài viết
                          _buildSectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                  'Thông tin cơ bản',
                                  LucideIcons.fileText,
                                ),
                                _buildImageBannerPicker(l10n),
                                const SizedBox(height: 16),
                                AppOutlineTextField(
                                  controller: _titleController,
                                  label: _type == 'article'
                                      ? 'Tiêu đề bài viết'
                                      : (_type == 'announcement'
                                          ? 'Tiêu đề thông báo'
                                          : 'Tên sự kiện'),
                                  hintText: _type == 'article'
                                      ? l10n.eventTitleHintArticle
                                      : l10n.eventTitleHint,
                                  prefixIcon: Icon(_typeIcon, size: 18),
                                  fillColor:
                                      context.surface.withValues(alpha: 0.3),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return _type == 'article'
                                          ? l10n.eventTitleRequiredArticle
                                          : l10n.eventTitleRequired;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                AppOutlineTextField(
                                  controller: _contentController,
                                  label: 'Nội dung chi tiết',
                                  hintText:
                                      'Nhập nội dung chi tiết bài viết, lịch trình sự kiện hoặc thông báo...',
                                  minLines: 4,
                                  maxLines: 10,
                                  fillColor:
                                      context.surface.withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Khối 3: Thời gian & Địa điểm (nếu có)
                          _buildSectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                  'Thời gian & Địa điểm',
                                  LucideIcons.calendarClock,
                                ),
                                InkWell(
                                  onTap: _selectDate,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: context.surface
                                          .withValues(alpha: 0.3),
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
                                          color: context.accent,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _formattedDateDisplay(l10n),
                                            style: GoogleFonts.beVietnamPro(
                                              fontSize: 14,
                                              fontWeight:
                                                  _displayDate.isNotEmpty
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
                                    fillColor:
                                        context.surface.withValues(alpha: 0.3),
                                    prefixIcon: const Icon(
                                      LucideIcons.mapPin,
                                      color: AppColors.error,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // Fixed Action Bar ở dưới
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  decoration: BoxDecoration(
                    color: context.surface.withValues(alpha: 0.7),
                    border: Border(
                      top: BorderSide(
                        color: context.textSecondary.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
      ),
    );
  }
}

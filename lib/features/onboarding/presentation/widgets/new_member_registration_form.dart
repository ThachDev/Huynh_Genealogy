import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/domain/entity/user_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';

class MemberRegistrationForm extends StatefulWidget {
  final UserEntity user;
  final TextEditingController fullNameController;
  final TextEditingController placeOfBirthController;
  final TextEditingController educationController;
  final TextEditingController notesController;
  final Gender gender;
  final ValueChanged<Gender> onGenderChanged;
  final MaritalStatus maritalStatus;
  final ValueChanged<MaritalStatus> onMaritalStatusChanged;
  final String? dateOfBirth;
  final ValueChanged<String?> onDateOfBirthChanged;
  final String? avatarPath;
  final ValueChanged<String?> onAvatarPathChanged;
  final String? selectedEducationOption;
  final ValueChanged<String?> onEducationOptionChanged;

  const MemberRegistrationForm({
    super.key,
    required this.user,
    required this.fullNameController,
    required this.placeOfBirthController,
    required this.educationController,
    required this.notesController,
    required this.gender,
    required this.onGenderChanged,
    required this.maritalStatus,
    required this.onMaritalStatusChanged,
    required this.dateOfBirth,
    required this.onDateOfBirthChanged,
    required this.avatarPath,
    required this.onAvatarPathChanged,
    required this.selectedEducationOption,
    required this.onEducationOptionChanged,
  });

  @override
  State<MemberRegistrationForm> createState() =>
      _MemberRegistrationFormState();
}

class _MemberRegistrationFormState extends State<MemberRegistrationForm> {
  final ImagePicker _picker = ImagePicker();

  final List<String> _predefinedEducation = const [
    'Tiểu học',
    'Trung học cơ sở',
    'Trung học phổ thông',
    'Đại Học',
    'Cao Học',
  ];

  String _getEducationText(String edu, AppLocalizations l10n) {
    switch (edu) {
      case 'Tiểu học':
        return l10n.educationPrimary;
      case 'Trung học cơ sở':
        return l10n.educationSecondary;
      case 'Trung học phổ thông':
        return l10n.educationHighSchool;
      case 'Đại Học':
        return l10n.educationUniversity;
      case 'Cao Học':
        return l10n.educationPostgraduate;
      default:
        return edu;
    }
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        widget.onAvatarPathChanged(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking avatar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 55),
          child: _buildSectionCard(
            context,
            children: [
              const SizedBox(height: 70),
              // 1. Họ và tên
              AppOutlineTextField(
                label: l10n.fullNameLabel,
                hintText: l10n.nameHint,
                controller: widget.fullNameController,
              ),
              const SizedBox(height: 16),

              // 2. Ngày sinh
              AppDatePickerField(
                dateString: widget.dateOfBirth,
                label: l10n.dobLabel,
                hintText: l10n.dobHint,
                onDateSelected: (dt) {
                  final d = dt.day.toString().padLeft(2, '0');
                  final m = dt.month.toString().padLeft(2, '0');
                  widget.onDateOfBirthChanged('$d/$m/${dt.year}');
                },
              ),
              const SizedBox(height: 16),

              // 3. Quê quán / Nơi sinh
              AppOutlineTextField(
                label: l10n.addressLabel,
                hintText: l10n.addressHint,
                controller: widget.placeOfBirthController,
              ),
              const SizedBox(height: 16),

              // 4. Giới tính
              AppDropdown<Gender>(
                label: l10n.genderLabel,
                value: widget.gender,
                items: [
                  DropdownItem(
                    value: Gender.male,
                    child: Text(l10n.genderMale),
                  ),
                  DropdownItem(
                    value: Gender.female,
                    child: Text(l10n.genderFemale),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    widget.onGenderChanged(val);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 5. Tình trạng hôn nhân
              AppDropdown<MaritalStatus>(
                label: l10n.maritalStatusLabel,
                value: widget.maritalStatus,
                items: [
                  DropdownItem(
                    value: MaritalStatus.single,
                    child: Text(l10n.maritalSingle),
                  ),
                  DropdownItem(
                    value: MaritalStatus.married,
                    child: Text(l10n.maritalMarried),
                  ),
                  DropdownItem(
                    value: MaritalStatus.divorced,
                    child: Text(l10n.maritalDivorced),
                  ),
                  DropdownItem(
                    value: MaritalStatus.widowed,
                    child: Text(l10n.maritalWidowed),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    widget.onMaritalStatusChanged(val);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 6. Trình độ học vấn (AppDropdown)
              AppDropdown<String?>(
                label: l10n.educationLabel,
                value: widget.selectedEducationOption,
                items: [
                  DropdownItem<String?>(
                    value: null,
                    child: Text(l10n.noSelectionLabel),
                  ),
                  ..._predefinedEducation.map(
                    (edu) => DropdownItem<String?>(
                      value: edu,
                      child: Text(_getEducationText(edu, l10n)),
                    ),
                  ),
                  DropdownItem<String?>(
                    value: 'Khác',
                    child: Text(l10n.otherLabel),
                  ),
                ],
                onChanged: (val) {
                  widget.onEducationOptionChanged(val);
                  if (val != 'Khác') {
                    widget.educationController.text = val ?? '';
                  } else {
                    widget.educationController.clear();
                  }
                },
              ),
              if (widget.selectedEducationOption == 'Khác') ...[
                const SizedBox(height: 16),
                AppOutlineTextField(
                  label: l10n.inputOtherEducationLabel,
                  hintText: l10n.educationHint,
                  controller: widget.educationController,
                ),
              ],
              const SizedBox(height: 16),

              // 7. Ghi chú cho Trưởng tộc / Tiểu sử
              AppOutlineTextField(
                label: l10n.bioLabel,
                hintText: l10n.bioHint,
                controller: widget.notesController,
                maxLines: 4,
              ),
            ],
          ),
        ),

        // Avatar nổi ở viền trên của Card
        _buildAvatarSection(context),
      ],
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget avatarWidget = Icon(
      LucideIcons.user,
      size: 50,
      color: context.textSecondary.withValues(alpha: 0.6),
    );

    if (widget.avatarPath != null && widget.avatarPath!.isNotEmpty) {
      if (widget.avatarPath!.startsWith('http') ||
          widget.avatarPath!.startsWith('https')) {
        avatarWidget = ClipOval(
          child: Image.network(
            widget.avatarPath!,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              LucideIcons.user,
              size: 50,
              color: context.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        );
      } else {
        avatarWidget = ClipOval(
          child: Image.file(
            File(widget.avatarPath!),
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              LucideIcons.user,
              size: 50,
              color: context.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        );
      }
    } else if (widget.user.avatarUrl != null &&
        widget.user.avatarUrl!.isNotEmpty) {
      avatarWidget = ClipOval(
        child: Image.network(
          widget.user.avatarUrl!,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            LucideIcons.user,
            size: 50,
            color: context.textSecondary.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _pickAvatar,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: context.resolve(
                    const Color(0xFFEAE7E3),
                    context.surface,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.resolve(
                      const Color(0xFFE8D4C8),
                      context.textSecondary.withValues(alpha: 0.3),
                    ),
                    width: 1.5,
                  ),
                ),
                child: Center(child: avatarWidget),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.appBarBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.camera,
                  size: 16,
                  color: context.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.uploadPhotoLabel,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
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
        children: children,
      ),
    );
  }
}

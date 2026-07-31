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
  final List<MemberEntity> familyMembers;
  final TextEditingController fullNameController;
  final TextEditingController placeOfBirthController;
  final TextEditingController educationController;
  final TextEditingController parentNameController;
  final TextEditingController spouseNameController;
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
  final int? parentId;
  final ValueChanged<int?> onParentIdChanged;
  final int? spouseId;
  final ValueChanged<int?> onSpouseIdChanged;

  const MemberRegistrationForm({
    super.key,
    required this.user,
    required this.familyMembers,
    required this.fullNameController,
    required this.placeOfBirthController,
    required this.educationController,
    required this.parentNameController,
    required this.spouseNameController,
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
    required this.parentId,
    required this.onParentIdChanged,
    required this.spouseId,
    required this.onSpouseIdChanged,
  });

  @override
  State<MemberRegistrationForm> createState() => _MemberRegistrationFormState();
}

enum ParentMode { fromTree, customName }

enum SpouseMode { fromTree, customName }

class _MemberRegistrationFormState extends State<MemberRegistrationForm> {
  final ImagePicker _picker = ImagePicker();
  ParentMode _parentMode = ParentMode.fromTree;
  SpouseMode _spouseMode = SpouseMode.fromTree;

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

              // Trình độ học vấn (AppDropdown)
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

              // Tình trạng hôn nhân
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

              // ── THÔNG TIN VỢ / CHỒNG (CARD PHÂN ĐOẠN) ──
              if (widget.maritalStatus != MaritalStatus.single) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.resolve(
                      const Color(0xFFF9F7F5),
                      context.surface,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: context.isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFFE8D4C8),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.spouseInfoLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _spouseMode = SpouseMode.fromTree;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _spouseMode == SpouseMode.fromTree
                                      ? context.primary.withValues(alpha: 0.12)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _spouseMode == SpouseMode.fromTree
                                        ? context.primary
                                        : context.textSecondary
                                            .withValues(alpha: 0.2),
                                    width: _spouseMode == SpouseMode.fromTree
                                        ? 1.5
                                        : 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _spouseMode == SpouseMode.fromTree
                                          ? LucideIcons.checkCircle2
                                          : LucideIcons.circle,
                                      size: 14,
                                      color: _spouseMode == SpouseMode.fromTree
                                          ? context.primary
                                          : context.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      l10n.hasInTreeLabel,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        fontWeight:
                                            _spouseMode == SpouseMode.fromTree
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            _spouseMode == SpouseMode.fromTree
                                                ? context.primary
                                                : context.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _spouseMode = SpouseMode.customName;
                                  widget.onSpouseIdChanged(null);
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _spouseMode == SpouseMode.customName
                                      ? context.primary.withValues(alpha: 0.12)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _spouseMode == SpouseMode.customName
                                        ? context.primary
                                        : context.textSecondary
                                            .withValues(alpha: 0.2),
                                    width: _spouseMode == SpouseMode.customName
                                        ? 1.5
                                        : 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _spouseMode == SpouseMode.customName
                                          ? LucideIcons.checkCircle2
                                          : LucideIcons.circle,
                                      size: 14,
                                      color:
                                          _spouseMode == SpouseMode.customName
                                              ? context.primary
                                              : context.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      l10n.notInTreeLabel,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        fontWeight:
                                            _spouseMode == SpouseMode.customName
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            _spouseMode == SpouseMode.customName
                                                ? context.primary
                                                : context.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_spouseMode == SpouseMode.fromTree) ...[
                        AppDropdown<int?>(
                          label: l10n.selectSpouseLabel,
                          value: widget.spouseId,
                          showSearchBox: true,
                          searchHint: l10n.searchSpouseHint,
                          items: [
                            DropdownItem<int?>(
                              value: null,
                              child: Text(l10n.noSelectionLabel),
                            ),
                            ...widget.familyMembers.map(
                              (m) => DropdownItem<int?>(
                                value: m.id,
                                child: Text(m.fullName),
                              ),
                            ),
                          ],
                          onChanged: (val) => widget.onSpouseIdChanged(val),
                        ),
                      ] else ...[
                        AppOutlineTextField(
                          label: l10n.inputSpouseNameLabel,
                          hintText: l10n.inputSpouseNameHint,
                          controller: widget.spouseNameController,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── THÔNG TIN CHA / MẸ (CARD PHÂN ĐOẠN) ──
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.resolve(
                    const Color(0xFFF9F7F5),
                    context.surface,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: context.isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFE8D4C8),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.parentInfoLabel,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _parentMode = ParentMode.fromTree;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _parentMode == ParentMode.fromTree
                                    ? context.primary.withValues(alpha: 0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _parentMode == ParentMode.fromTree
                                      ? context.primary
                                      : context.textSecondary
                                          .withValues(alpha: 0.2),
                                  width: _parentMode == ParentMode.fromTree
                                      ? 1.5
                                      : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _parentMode == ParentMode.fromTree
                                        ? LucideIcons.checkCircle2
                                        : LucideIcons.circle,
                                    size: 14,
                                    color: _parentMode == ParentMode.fromTree
                                        ? context.primary
                                        : context.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.hasInTreeLabel,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      fontWeight:
                                          _parentMode == ParentMode.fromTree
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color: _parentMode == ParentMode.fromTree
                                          ? context.primary
                                          : context.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _parentMode = ParentMode.customName;
                                widget.onParentIdChanged(null);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _parentMode == ParentMode.customName
                                    ? context.primary.withValues(alpha: 0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _parentMode == ParentMode.customName
                                      ? context.primary
                                      : context.textSecondary
                                          .withValues(alpha: 0.2),
                                  width: _parentMode == ParentMode.customName
                                      ? 1.5
                                      : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _parentMode == ParentMode.customName
                                        ? LucideIcons.checkCircle2
                                        : LucideIcons.circle,
                                    size: 14,
                                    color: _parentMode == ParentMode.customName
                                        ? context.primary
                                        : context.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.notInTreeLabel,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      fontWeight:
                                          _parentMode == ParentMode.customName
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _parentMode == ParentMode.customName
                                              ? context.primary
                                              : context.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_parentMode == ParentMode.fromTree) ...[
                      AppDropdown<int?>(
                        label: l10n.selectParentLabel,
                        value: widget.parentId,
                        showSearchBox: true,
                        searchHint: l10n.searchParentHint,
                        items: [
                          DropdownItem<int?>(
                            value: null,
                            child: Text(l10n.noSelectionLabel),
                          ),
                          ...widget.familyMembers.map(
                            (m) => DropdownItem<int?>(
                              value: m.id,
                              child: Text(
                                '${m.fullName}${m.generation != null ? " (${l10n.generationLabel(m.generation!)})" : ""}',
                              ),
                            ),
                          ),
                        ],
                        onChanged: (val) => widget.onParentIdChanged(val),
                      ),
                    ] else ...[
                      AppOutlineTextField(
                        label: l10n.inputParentNameLabel,
                        hintText: l10n.inputParentNameHint,
                        controller: widget.parentNameController,
                      ),
                    ],
                  ],
                ),
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

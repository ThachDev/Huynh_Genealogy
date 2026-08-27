import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import '../../../family_tree/domain/entities/family_entity.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import 'new_member_registration_form.dart';

/// ============================================================================
/// PRESENTATION LAYER — VIEWER ONBOARDING WIDGET
/// ============================================================================
/// Giao diện dành cho người dùng tham gia vào dòng họ đã có sẵn (Thành viên / Viewer).
///
/// Quy trình xử lý gồm 2 bước (2-Step Flow):
///   1. BƯỚC 1 - Nhập hoặc Quét QR Code Mã mời:
///      - Người dùng nhập mã -> Gửi `VerifyInviteCodeEvent(code)` tới `OnboardingBloc`.
///      - `OnboardingBloc` xác thực -> Phát ra `InviteCodeVerifiedState(family, members)`.
///   2. BƯỚC 2 - Chọn hoặc Nhập thông tin thành viên:
///      - Nhánh 2a: Chọn thành viên có sẵn trên cây gia phả (`_selectedMember`).
///      - Nhánh 2b: Chưa có tên trên cây (`_isNotOnTree = true`) -> Điền form thông tin cá nhân.
///      - Bấm nút gửi -> Gửi `JoinFamilyEvent(...)` tới `OnboardingBloc`.
/// ============================================================================
class ViewerOnboardingWidget extends StatefulWidget {

  const ViewerOnboardingWidget({
    super.key,
    required this.user,
  });
  final UserEntity user;

  @override
  State<ViewerOnboardingWidget> createState() => _ViewerOnboardingWidgetState();
}

class _ViewerOnboardingWidgetState extends State<ViewerOnboardingWidget> {
  final _inviteCodeController = TextEditingController();
  late final TextEditingController _fullNameController;
  final _placeOfBirthController = TextEditingController();
  final _educationController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _spouseNameController = TextEditingController();
  final _notesController = TextEditingController();

  FamilyEntity? _verifiedFamily;
  List<MemberEntity> _familyMembers = [];
  MemberEntity? _selectedMember;

  bool _isNotOnTree = false;
  Gender _gender = Gender.male;
  MaritalStatus _maritalStatus = MaritalStatus.single;
  String? _dateOfBirth;
  String? _avatarPath;
  String? _selectedEducationOption;
  int? _selectedParentId;
  int? _selectedSpouseId;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    if (widget.user.avatarUrl != null && widget.user.avatarUrl!.isNotEmpty) {
      _avatarPath = widget.user.avatarUrl;
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _fullNameController.dispose();
    _placeOfBirthController.dispose();
    _educationController.dispose();
    _parentNameController.dispose();
    _spouseNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onVerifyInviteCodePressed() {
    final code = _inviteCodeController.text.trim().toUpperCase();
    if (code.isNotEmpty) {
      context.read<OnboardingBloc>().add(VerifyInviteCodeEvent(code: code));
    } else {
      final l10n = AppLocalizations.of(context);
      AppSnackBar.warning(context, l10n.enterInviteCodeWarning);
    }
  }

  void _onJoinFamilyPressed() {
    final l10n = AppLocalizations.of(context);
    if (_verifiedFamily != null && (_selectedMember != null || _isNotOnTree)) {
      if (!_isNotOnTree && _selectedMember != null && _selectedMember!.isLinked) {
        AppDialog.alert(
          context,
          title: l10n.memberAlreadyLinkedTitle,
          message: l10n.memberAlreadyLinkedDescFormat(_selectedMember!.fullName),
        );
        return;
      }

      String? maritalStatusStr;
      switch (_maritalStatus) {
        case MaritalStatus.single:
          maritalStatusStr = 'single';
          break;
        case MaritalStatus.married:
          maritalStatusStr = 'married';
          break;
        case MaritalStatus.divorced:
          maritalStatusStr = 'divorced';
          break;
        case MaritalStatus.widowed:
          maritalStatusStr = 'widowed';
          break;
        case MaritalStatus.unknown:
          maritalStatusStr = 'unknown';
          break;
      }

      String? educationVal;
      if (_selectedEducationOption == 'Khác') {
        educationVal = _educationController.text.trim();
      } else {
        educationVal = _selectedEducationOption;
      }

      final List<String> notesParts = [];
      if (_selectedParentId == null &&
          _parentNameController.text.trim().isNotEmpty) {
        notesParts.add('Cha/Mẹ: ${_parentNameController.text.trim()}');
      }
      if (_maritalStatus != MaritalStatus.single &&
          _selectedSpouseId == null &&
          _spouseNameController.text.trim().isNotEmpty) {
        notesParts.add('Vợ/Chồng: ${_spouseNameController.text.trim()}');
      }
      if (_notesController.text.trim().isNotEmpty) {
        notesParts.add(_notesController.text.trim());
      }
      final String? combinedNotes =
          notesParts.isNotEmpty ? notesParts.join(' | ') : null;

      context.read<OnboardingBloc>().add(
            JoinFamilyEvent(
              familyId: _verifiedFamily!.id,
              memberNodeId: _isNotOnTree ? null : _selectedMember?.id,
              userId: widget.user.id,
              fullName: _isNotOnTree ? _fullNameController.text.trim() : null,
              gender: _isNotOnTree
                  ? (_gender == Gender.male ? 'male' : 'female')
                  : null,
              dateOfBirth: _isNotOnTree ? _dateOfBirth : null,
              placeOfBirth:
                  _isNotOnTree ? _placeOfBirthController.text.trim() : null,
              maritalStatus: _isNotOnTree ? maritalStatusStr : null,
              education: _isNotOnTree ? educationVal : null,
              avatarUrl: _isNotOnTree ? _avatarPath : null,
              parentId: _isNotOnTree ? _selectedParentId : null,
              spouseId: _isNotOnTree ? _selectedSpouseId : null,
              notes: _isNotOnTree ? combinedNotes : null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is InviteCodeVerifiedState) {
          setState(() {
            _verifiedFamily = state.family;
            _familyMembers = state.members;
            _selectedMember = null;
            _isNotOnTree = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.joinFamilyCardTitle,
            description: l10n.welcomeViewerSubtitle,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.resolve(
                      Colors.black.withValues(alpha: 0.08), Colors.transparent),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── BƯỚC 1: NHẬP MÃ THAM GIA (Khi chưa xác thực gia tộc) ──
                if (_verifiedFamily == null) ...[
                  Text(
                    l10n.enterInviteCodeLabel,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Code Input Box
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: context.background.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: context.resolve(
                                    Colors.black.withValues(alpha: 0.03),
                                    Colors.transparent),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Icon(
                                LucideIcons.layoutGrid,
                                color: context.textPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _inviteCodeController,
                                  style: GoogleFonts.inter(
                                    color: context.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: l10n.inviteCodeHintNew,
                                    hintStyle: GoogleFonts.inter(
                                      color: context.textSecondary
                                          .withValues(alpha: 0.4),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // QR Scanner Button
                      GestureDetector(
                        onTap: () async {
                          final code = await QrScannerDialog.show(context);
                          if (code != null && mounted) {
                            setState(() {
                              _inviteCodeController.text = code;
                            });
                            _onVerifyInviteCodePressed();
                          }
                        },
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: context.background.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: context.resolve(
                                    Colors.black.withValues(alpha: 0.03),
                                    Colors.transparent),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.scanLine,
                              color: context.textPrimary,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.inviteCodeDescription,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button cho Bước 1
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return AppButton(
                        label: l10n.confirmJoinButton,
                        onPressed: _onVerifyInviteCodePressed,
                        isLoading: state is OnboardingLoading,
                        fullWidth: true,
                        size: AppButtonSize.large,
                      );
                    },
                  ),
                ]
                // ── BƯỚC 2: CHỌN / NHẬP THÔNG TIN (Khi đã tìm thấy gia tộc) ──
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.familyFoundTitle(
                              _verifiedFamily!.name.toUpperCase()),
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          setState(() {
                            _verifiedFamily = null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.refreshCw,
                                  size: 13, color: context.textSecondary),
                              Text(
                                l10n.changeInviteCodeButton,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: context.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_isNotOnTree) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.selectMemberPrompt,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else
                    const SizedBox(height: 12),
                  if (!_isNotOnTree)
                    AppDropdown<MemberEntity?>(
                      value: _selectedMember,
                      showSearchBox: true,
                      searchHint: l10n.searchNameHint,
                      items: [
                        DropdownItem<MemberEntity?>(
                          child: Text(
                            l10n.selectMemberHint,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: context.textSecondary,
                            ),
                          ),
                        ),
                        ..._familyMembers.map((m) => DropdownItem<MemberEntity?>(
                              value: m,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${m.fullName}${m.generation != null ? " (${l10n.generationLabel('${m.generation!}')})" : ""}',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: m.isLinked
                                            ? context.textSecondary
                                            : context.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (m.isLinked)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: context.error.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        l10n.statusLinked,
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: context.error,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                      ],
                      onChanged: (val) {
                        if (val != null && val.isLinked) {
                          AppDialog.alert(
                            context,
                            title: l10n.memberAlreadyLinkedTitle,
                            message: l10n.memberAlreadyLinkedDescFormat(val.fullName),
                          );
                          setState(() {
                            _selectedMember = null;
                          });
                          return;
                        }
                        setState(() {
                          _selectedMember = val;
                        });
                      },
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _isNotOnTree,
                          onChanged: (val) {
                            setState(() {
                              _isNotOnTree = val ?? false;
                              if (_isNotOnTree) {
                                _selectedMember = null;
                              }
                            });
                          },
                          activeColor: context.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isNotOnTree = !_isNotOnTree;
                            if (_isNotOnTree) {
                              _selectedMember = null;
                            }
                          });
                        },
                        child: Text(
                          l10n.notOnTreeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Form đăng ký cho người chưa có tên trên cây gia phả ──
                  if (_isNotOnTree) ...[
                    const SizedBox(height: 20),
                    MemberRegistrationForm(
                      user: widget.user,
                      familyMembers: _familyMembers,
                      fullNameController: _fullNameController,
                      placeOfBirthController: _placeOfBirthController,
                      educationController: _educationController,
                      parentNameController: _parentNameController,
                      spouseNameController: _spouseNameController,
                      notesController: _notesController,
                      gender: _gender,
                      onGenderChanged: (g) => setState(() => _gender = g),
                      maritalStatus: _maritalStatus,
                      onMaritalStatusChanged: (m) =>
                          setState(() => _maritalStatus = m),
                      dateOfBirth: _dateOfBirth,
                      onDateOfBirthChanged: (d) =>
                          setState(() => _dateOfBirth = d),
                      avatarPath: _avatarPath,
                      onAvatarPathChanged: (path) =>
                          setState(() => _avatarPath = path),
                      selectedEducationOption: _selectedEducationOption,
                      onEducationOptionChanged: (option) =>
                          setState(() => _selectedEducationOption = option),
                      parentId: _selectedParentId,
                      onParentIdChanged: (pid) =>
                          setState(() => _selectedParentId = pid),
                      spouseId: _selectedSpouseId,
                      onSpouseIdChanged: (sid) =>
                          setState(() => _selectedSpouseId = sid),
                    ),
                  ],

                  const SizedBox(height: 28),
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return AppButton(
                        label: l10n.sendJoinRequestButton,
                        onPressed: (_selectedMember != null || _isNotOnTree)
                            ? _onJoinFamilyPressed
                            : null,
                        isLoading: state is OnboardingLoading,
                        fullWidth: true,
                        size: AppButtonSize.large,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

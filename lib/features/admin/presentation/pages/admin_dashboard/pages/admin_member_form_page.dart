import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../../injection_container.dart';
import '../../../../../auth/auth.dart';
import '../../../../../onboarding/onboarding.dart';
import '../../../bloc/admin_member_form/admin_member_form_bloc.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminMemberFormPage extends StatefulWidget {
  final int? memberId; // null = Thêm mới, có giá trị = Chỉnh sửa
  /// Nếu true: sau khi tạo thành viên mới sẽ tự động liên kết với tài khoản OWNER
  final bool isOwnerSelfSetup;
  final int? ownerUserId;
  final String? initialFullName;
  final String? initialAvatarUrl;
  final int? initialParentId;
  final int? initialSpouseId;
  final int? initialGeneration;
  final bool isLockedContext;

  const AdminMemberFormPage({
    super.key,
    this.memberId,
    this.isOwnerSelfSetup = false,
    this.ownerUserId,
    this.initialFullName,
    this.initialAvatarUrl,
    this.initialParentId,
    this.initialSpouseId,
    this.initialGeneration,
    this.isLockedContext = false,
  });

  @override
  State<AdminMemberFormPage> createState() => _AdminMemberFormPageState();
}

class _AdminMemberFormPageState extends State<AdminMemberFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _generationController = TextEditingController();
  final _notesController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  final _phoneController = TextEditingController();

  // Selected values
  Gender _gender = Gender.male;
  MaritalStatus _maritalStatus = MaritalStatus.single;
  bool _isAlive = true;

  String? _dateOfBirth;
  String? _dateOfDeath;
  String? _lunarBirthDate;
  String? _lunarDeathDate;

  int? _parentId;
  int? _spouseId;
  int? _branchId;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        // Copy file sang thư mục tạm của app để tránh bị xóa khỏi cache picker
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'avatar_${DateTime.now().millisecondsSinceEpoch}${pickedFile.name.contains('.') ? pickedFile.name.substring(pickedFile.name.lastIndexOf('.')) : '.jpg'}';
        final savedFile =
            await File(pickedFile.path).copy('${tempDir.path}/$fileName');
        setState(() {
          _avatarUrlController.text = savedFile.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking avatar: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialFullName != null) {
      _fullNameController.text = widget.initialFullName!;
    }
    if (widget.initialAvatarUrl != null) {
      _avatarUrlController.text = widget.initialAvatarUrl!;
    }
    
    if (widget.memberId == null) {
      if (widget.initialParentId != null) {
        _parentId = widget.initialParentId;
      }
      if (widget.initialSpouseId != null) {
        _spouseId = widget.initialSpouseId;
        _maritalStatus = MaritalStatus.married;
      }
      if (widget.initialGeneration != null) {
        _generationController.text = widget.initialGeneration.toString();
      }
    }

    final authState = context.read<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;
    context.read<AdminMemberFormBloc>().add(LoadAdminMemberFormEvent(
        memberId: widget.memberId, familyId: familyId));
    _generationController.addListener(_onGenerationChanged);
  }

  void _onGenerationChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _generationController.removeListener(_onGenerationChanged);
    _fullNameController.dispose();
    _placeOfBirthController.dispose();
    _generationController.dispose();
    _notesController.dispose();
    _avatarUrlController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm(MemberEntity? existingMember) {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;

    final member = MemberEntity(
      id: widget.memberId ?? 0,
      fullName: _fullNameController.text.trim(),
      gender: _gender,
      dateOfBirth: _formatBackendDate(_dateOfBirth),
      placeOfBirth: _placeOfBirthController.text.trim().isEmpty
          ? null
          : _placeOfBirthController.text.trim(),
      isAlive: _isAlive,
      dateOfDeath: _isAlive ? null : _formatBackendDate(_dateOfDeath),
      maritalStatus: _maritalStatus,
      generation: int.tryParse(_generationController.text),
      branchId: _branchId,
      parentId: _parentId,
      spouseId: _spouseId,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      avatarUrl: _avatarUrlController.text.trim().isEmpty
          ? null
          : _avatarUrlController.text.trim(),
      familyId: familyId ?? existingMember?.familyId,
      lunarBirthDate: _lunarBirthDate,
      lunarDeathDate: _lunarDeathDate,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );

    context.read<AdminMemberFormBloc>().add(SubmitAdminMemberFormEvent(member));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.memberId != null;
    final l10n = AppLocalizations.of(context)!;
    final title = isEdit ? l10n.editMemberTitle : l10n.addMemberTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        elevation: 4,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: context.accent, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: context.accent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: BlocConsumer<AdminMemberFormBloc, AdminMemberFormState>(
        listener: (context, state) async {
          if (state is AdminMemberFormSuccess) {
            if (!state.isDeleted && widget.isOwnerSelfSetup) {
              // Link newly created member to the OWNER's account
              final linkUsecase = sl<LinkMemberToUser>();
              final result = await linkUsecase(LinkMemberToUserParams(
                userId: widget.ownerUserId ?? 0,
                memberId: state.member.id,
              ));
              if (mounted) {
                result.fold(
                  (failure) => AppSnackBar.error(
                      context, l10n.linkAccountError(failure.message)),
                  (_) {
                    // Refresh auth profile to sync new member_id
                    context.read<AuthBloc>().add(AuthProfileRefreshSilent());
                    AppSnackBar.success(context, l10n.linkAccountSuccess);
                    Navigator.pop(context, true);
                  },
                );
              }
            } else {
              AppSnackBar.success(
                context,
                state.isDeleted
                    ? l10n.deleteMemberSuccess
                    : l10n.saveMemberSuccess,
              );
              Navigator.pop(context, true);
            }
          } else if (state is AdminMemberFormError) {
            AppSnackBar.error(context, state.message);
          } else if (state is AdminMemberFormReady) {
            final m = state.member;
            if (m != null) {
              _fullNameController.text = m.fullName;
              _placeOfBirthController.text = m.placeOfBirth ?? '';
              _generationController.text = m.generation?.toString() ?? '';
              _notesController.text = m.notes ?? '';
              _avatarUrlController.text = m.avatarUrl ?? '';
              _phoneController.text = m.phone ?? '';
              _gender = m.gender;
              _maritalStatus = m.maritalStatus;
              _isAlive = m.isAlive;
              _dateOfBirth = _formatUIDate(m.dateOfBirth);
              _dateOfDeath = _formatUIDate(m.dateOfDeath);
              _lunarBirthDate = m.lunarBirthDate;
              _lunarDeathDate = m.lunarDeathDate;
              _parentId = m.parentId;
              _spouseId = m.spouseId;
              _branchId = m.branchId;
            }
          }
        },
        builder: (context, state) {
          if (state is AdminMemberFormInitial ||
              state is AdminMemberFormLoading ||
              state is AdminMemberFormSubmitting) {
            return const Center(
              child: AppLoading(size: 80),
            );
          }
          
          if (state is AdminMemberFormReady) {
            final isCorrectMember = (widget.memberId == null && state.member == null) ||
                                    (widget.memberId != null && state.member?.id == widget.memberId);
            if (!isCorrectMember) {
              return const Center(
                child: AppLoading(size: 80),
              );
            }
          }

          final existingMember =
              state is AdminMemberFormReady ? state.member : null;
          final allMembers =
              state is AdminMemberFormReady ? state.members : <MemberEntity>[];
          final allBranches =
              state is AdminMemberFormReady ? state.branches : <BranchEntity>[];

          // ── Smart filtering for dropdowns ─────────────────────────────────
          final int? currentGeneration =
              int.tryParse(_generationController.text.trim());

          // Đệ quy tìm tất cả con cháu trực hệ của một member để tránh chọn con làm cha mẹ
          Set<int> getDescendantIds(int memberId) {
            final descendants = <int>{};
            void dfs(int id) {
              for (final child in allMembers) {
                if (child.parentId == id && !descendants.contains(child.id)) {
                  descendants.add(child.id);
                  dfs(child.id);
                }
              }
            }

            dfs(memberId);
            return descendants;
          }

          final descendants = existingMember != null
              ? getDescendantIds(existingMember.id)
              : <int>{};

          final ancestors = <int>{};
          void dfsAncestors(int? parentId) {
            if (parentId == null) return;
            if (!ancestors.contains(parentId)) {
              ancestors.add(parentId);
              final parent = allMembers.where((m) => m.id == parentId).firstOrNull;
              if (parent != null) {
                dfsAncestors(parent.parentId);
              }
            }
          }
          if (existingMember != null) {
            dfsAncestors(existingMember.parentId);
          }

          DateTime? parseDate(String? dateStr) {
            if (dateStr == null) return null;
            return DateTime.tryParse(dateStr);
          }
          final myDob = parseDate(_formatBackendDate(_dateOfBirth));

          // Cha/Mẹ: thế hệ trước (gen - 1)
          final parentOptions = allMembers.where((m) {
            if (m.id == existingMember?.id) return false;
            // LUÔN CHO PHÉP parent hiện tại để không bị reset ngầm khi chỉnh sửa
            if (existingMember != null && m.id == existingMember.parentId) {
              return true;
            }
            if (widget.initialParentId != null && m.id == widget.initialParentId) {
              return true;
            }

            // Không được chọn vợ/chồng làm cha/mẹ
            if (_spouseId != null && m.id == _spouseId) return false;
            // Không được chọn con cháu làm cha/mẹ
            if (descendants.contains(m.id)) return false;
            
            // Ràng buộc tuổi tác: Cha mẹ phải lớn hơn con ít nhất 13 tuổi
            if (myDob != null) {
              final parentDob = parseDate(m.dateOfBirth);
              if (parentDob != null) {
                final ageGap = myDob.difference(parentDob).inDays / 365.25;
                if (ageGap < 13) return false;
              }
            }

            if (currentGeneration != null && m.generation != null) {
              return m.generation == currentGeneration - 1;
            }
            return true;
          }).toList();

          // Vợ/Chồng: cùng thế hệ + ngược giới tính + chưa có vợ/chồng khác
          final spouseOptions = allMembers.where((m) {
            if (m.id == existingMember?.id) return false;
            // LUÔN CHO PHÉP spouse hiện tại để không bị reset ngầm khi chỉnh sửa
            if (existingMember != null && m.id == existingMember.spouseId) {
              return true;
            }
            if (widget.initialSpouseId != null && m.id == widget.initialSpouseId) {
              return true;
            }

            // Không được chọn cha/mẹ làm vợ/chồng
            if (_parentId != null && m.id == _parentId) return false;
            // Không được cưới tổ tiên hoặc con cháu
            if (descendants.contains(m.id) || ancestors.contains(m.id)) {
              return false;
            }
            // Lọc cùng thế hệ
            if (currentGeneration != null && m.generation != null) {
              if (m.generation != currentGeneration) return false;
            }
            // Lọc ngược giới tính
            if (_gender == Gender.male && m.gender == Gender.male) return false;
            if (_gender == Gender.female && m.gender == Gender.female) {
              return false;
            }
            // Bỏ những người đã có vợ/chồng khác
            if (m.spouseId != null &&
                m.spouseId != existingMember?.id &&
                m.spouseId != _spouseId) {
              // Cho phép Đa thê: Nếu Nữ đang chọn chồng, thì cho phép chọn Nam dù Nam đã có vợ
              if (_gender == Gender.female && m.gender == Gender.male) {
                // allow
              } else {
                return false;
              }
            }
            // Không được cưới anh/chị/em ruột (chung parentId)
            if (_parentId != null &&
                m.parentId != null &&
                m.parentId == _parentId) {
              return false;
            }
            // Không được cưới anh/em họ trực hệ gần (con của cô dì chú bác ruột - chung ông bà)
            if (_parentId != null) {
              final myParent =
                  allMembers.where((x) => x.id == _parentId).firstOrNull;
              if (myParent != null &&
                  myParent.parentId != null &&
                  m.parentId != null) {
                final spouseParent =
                    allMembers.where((x) => x.id == m.parentId).firstOrNull;
                if (spouseParent != null &&
                    spouseParent.parentId == myParent.parentId) {
                  return false; // Chung ông/bà nội ngoại
                }
              }
            }
            return true;
          }).toList();

          // Reset _parentId nếu người đã chọn không còn thuộc danh sách
          final parentIds = parentOptions.map((m) => m.id).toSet();
          if (_parentId != null && !parentIds.contains(_parentId)) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => setState(() => _parentId = null));
          }
          // Reset _spouseId nếu người đã chọn không còn thuộc danh sách
          final spouseIds = spouseOptions.map((m) => m.id).toSet();
          if (_spouseId != null && !spouseIds.contains(_spouseId)) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => setState(() => _spouseId = null));
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Stack: avatar nổi trên viền trên của card
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            // Card đẩy xuống để nhường chỗ nửa avatar (55px)
                            Padding(
                              padding: const EdgeInsets.only(top: 55),
                              child: _buildSectionCard(
                                context,
                                children: [
                                  // Khoảng trống phần nửa dưới avatar + label
                                  const SizedBox(height: 70),

                                  // Hàng 1: Họ và tên + Thế hệ
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: _buildTextField(
                                          controller: _fullNameController,
                                          label: l10n.fullNameLabel,
                                          hintText: l10n.nameHint,
                                          validator: (val) =>
                                              AppValidators.validateFullName(
                                                  context, val),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: _buildGenerationField(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Hàng 2: Hôn nhân + Giới tính
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: _buildDropdown<MaritalStatus>(
                                          label: l10n.maritalStatusLabel,
                                          value: _maritalStatus,
                                          items: [
                                            DropdownItem(
                                                value: MaritalStatus.single,
                                                child:
                                                    Text(l10n.maritalSingle)),
                                            DropdownItem(
                                                value: MaritalStatus.married,
                                                child:
                                                    Text(l10n.maritalMarried)),
                                            DropdownItem(
                                                value: MaritalStatus.divorced,
                                                child:
                                                    Text(l10n.maritalDivorced)),
                                            DropdownItem(
                                                value: MaritalStatus.widowed,
                                                child:
                                                    Text(l10n.maritalWidowed)),
                                            DropdownItem(
                                                value: MaritalStatus.unknown,
                                                child:
                                                    Text(l10n.maritalUnknown)),
                                          ],
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                _maritalStatus = val;
                                                if (val !=
                                                    MaritalStatus.married) {
                                                  _spouseId = null;
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        flex: 2,
                                        child: _buildDropdown<Gender>(
                                          label: l10n.genderLabel,
                                          value: _gender,
                                          items: [
                                            DropdownItem(
                                                value: Gender.male,
                                                child: Text(l10n.genderMale)),
                                            DropdownItem(
                                                value: Gender.female,
                                                child: Text(l10n.genderFemale)),
                                            DropdownItem(
                                                value: Gender.unknown,
                                                child:
                                                    Text(l10n.genderUnknown)),
                                          ],
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() => _gender = val);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Ngày sinh + Tình trạng (cùng hàng)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Ngày sinh – flex 3
                                      Expanded(
                                        flex: 3,
                                        child: AppDatePickerField(
                                          dateString: _dateOfBirth,
                                          label: l10n.dobLabel,
                                          hintText: l10n.dobHint,
                                          onDateSelected: (date) {
                                            final formattedDate =
                                                "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                                            setState(() {
                                              _dateOfBirth = formattedDate;
                                              _lunarBirthDate = LunarDateHelper
                                                  .getLunarDateString(date);
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Tình trạng – flex 2
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () => setState(
                                              () => _isAlive = !_isAlive),
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              fillColor: context.resolve(
                                                const Color(0xFFFCFAF8),
                                                AppColors.surfaceDark,
                                              ),
                                              filled: true,
                                              labelText: l10n.statusLabel,
                                              labelStyle: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: context.textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                              floatingLabelStyle:
                                                  GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: context.textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: _isAlive
                                                      ? context.primary
                                                      : context.textSecondary
                                                          .withValues(
                                                              alpha: 0.5),
                                                  width: 1.2,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: _isAlive
                                                      ? context.primary
                                                      : context.textSecondary
                                                          .withValues(
                                                              alpha: 0.5),
                                                  width: 1.2,
                                                ),
                                              ),
                                            ),
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: Row(
                                                key: ValueKey(_isAlive),
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    _isAlive
                                                        ? LucideIcons.heart
                                                        : LucideIcons
                                                            .heartCrack,
                                                    size: 14,
                                                    color: _isAlive
                                                        ? context.primary
                                                        : context.textSecondary
                                                            .withValues(
                                                                alpha: 0.5),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _isAlive
                                                        ? l10n.aliveLabel
                                                        : l10n.deceasedLabel,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      color: _isAlive
                                                          ? context.primary
                                                          : context
                                                              .textSecondary
                                                              .withValues(
                                                                  alpha: 0.5),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Nếu đã mất thì hiện ngày mất
                                  if (!_isAlive) ...[
                                    const SizedBox(height: 12),
                                    AppDatePickerField(
                                      dateString: _dateOfDeath,
                                      label: l10n.dodLabel,
                                      hintText: l10n.dodHint,
                                      onDateSelected: (date) {
                                        final formattedDate =
                                            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                                        setState(() {
                                          _dateOfDeath = formattedDate;
                                          _lunarDeathDate = LunarDateHelper
                                              .getLunarDateString(date);
                                        });
                                      },
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  // Số điện thoại
                                  _buildTextField(
                                    controller: _phoneController,
                                    label: l10n.phoneLabel,
                                    hintText: l10n.phoneHint,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 16),

                                  _buildTextField(
                                    controller: _placeOfBirthController,
                                    label: l10n.addressLabel,
                                    hintText: l10n.addressHint,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDropdown<int?>(
                                    label: l10n.parentLabel,
                                    value: parentIds.contains(_parentId)
                                        ? _parentId
                                        : null,
                                    locked: widget.isLockedContext,
                                    items: [
                                      DropdownItem<int?>(
                                          value: null,
                                          child: Text(l10n.noSelectionLabel)),
                                      ...parentOptions
                                          .map((m) => DropdownItem<int?>(
                                                value: m.id,
                                                child: Text(
                                                    '${m.fullName} (${l10n.generationBadge('${m.generation}')})'),
                                              )),
                                    ],
                                    onChanged: (val) {
                                      final selectedParent = val == null
                                          ? null
                                          : allMembers
                                              .where((m) => m.id == val)
                                              .firstOrNull;
                                      setState(() {
                                        _parentId = val;
                                        if (selectedParent?.branchId != null) {
                                          _branchId = selectedParent!.branchId;
                                        }
                                      });
                                    },
                                    showSearchBox: true,
                                  ),
                                  if (_maritalStatus ==
                                      MaritalStatus.married) ...[
                                    const SizedBox(height: 16),
                                    _buildDropdown<int?>(
                                      label: l10n.spouseLabel,
                                      value: spouseIds.contains(_spouseId)
                                          ? _spouseId
                                          : null,
                                      locked: widget.isLockedContext && widget.initialSpouseId != null,
                                      items: [
                                        DropdownItem<int?>(
                                            value: null,
                                            child: Text(l10n.noSelectionLabel)),
                                        ...spouseOptions
                                            .map((m) => DropdownItem<int?>(
                                                  value: m.id,
                                                  child: Text(
                                                      '${m.fullName} (${l10n.generationBadge('${m.generation}')})'),
                                                )),
                                      ],
                                      onChanged: (val) {
                                        final selectedSpouse = val == null
                                            ? null
                                            : allMembers
                                                .where((m) => m.id == val)
                                                .firstOrNull;
                                        setState(() {
                                          _spouseId = val;
                                          if (_gender == Gender.female &&
                                              selectedSpouse?.gender == Gender.male &&
                                              selectedSpouse?.branchId != null) {
                                            _branchId = selectedSpouse!.branchId;
                                          }
                                        });
                                      },
                                      showSearchBox: true,
                                    ),
                                  ],
                                  const SizedBox(height: 16),

                                  Builder(builder: (context) {
                                    // Lấy chi tộc của cha/mẹ hoặc vợ/chồng (nếu có) để hiển thị gợi ý và auto-select
                                    final contextMemberId = _parentId ?? _spouseId;
                                    final contextMember = contextMemberId == null
                                        ? null
                                        : allMembers
                                            .where((m) => m.id == contextMemberId)
                                            .firstOrNull;
                                    final contextBranchId = contextMember?.branchId;
                                    
                                    // Auto-select branch cho contextual add
                                    if (widget.isLockedContext && _branchId == null && contextBranchId != null) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) setState(() => _branchId = contextBranchId);
                                      });
                                    }

                                    // Sắp xếp: chi tộc của ngữ cảnh lên đầu
                                    final sortedBranches = [...allBranches]
                                      ..sort((a, b) {
                                        if (a.id == contextBranchId) return -1;
                                        if (b.id == contextBranchId) return 1;
                                        return 0;
                                      });

                                    return _buildDropdown<int?>(
                                      label: l10n.branchSectionLabel,
                                      locked: widget.isLockedContext,
                                      value: allBranches
                                              .any((b) => b.id == (_branchId ?? contextBranchId))
                                          ? (_branchId ?? contextBranchId)
                                          : null,
                                      items: [
                                        DropdownItem<int?>(
                                            value: null,
                                            child: Text(l10n.noBranchLabel)),
                                        ...sortedBranches
                                            .map((b) => DropdownItem<int?>(
                                                  value: b.id,
                                                  child: Text(
                                                    b.id == contextBranchId
                                                        ? l10n
                                                            .parentBranchMarker(
                                                                b.name)
                                                        : b.name,
                                                  ),
                                                )),
                                      ],
                                      onChanged: (val) =>
                                          setState(() => _branchId = val),
                                      showSearchBox: true,
                                    );
                                  }),

                                  const SizedBox(height: 16),

                                  // Tiểu sử
                                  _buildTextField(
                                    controller: _notesController,
                                    label: l10n.bioLabel,
                                    hintText: l10n.bioHint,
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                            ),

                            // Avatar nổi trên viền trên của card
                            _buildAvatarSection(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Sticky bottom buttons
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
                  saveLabel: l10n.formSave,
                  onSave: () => _submitForm(existingMember),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avatarPath = _avatarUrlController.text.trim();
    Widget avatarWidget = Icon(
      LucideIcons.user,
      size: 50,
      color: context.textSecondary.withValues(alpha: 0.6),
    );

    if (avatarPath.isNotEmpty) {
      if (avatarPath.startsWith('http') || avatarPath.startsWith('https')) {
        avatarWidget = ClipOval(
          child: Image.network(
            avatarPath,
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
            File(avatarPath),
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
                  color: context.isDarkMode
                      ? AppColors.surfaceDark
                      : const Color(0xFFEAE7E3),
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
                child: const Icon(
                  LucideIcons.camera,
                  size: 16,
                  color: AppColors.gold,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return AppOutlineTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownItem<T>> items,
    required ValueChanged<T?> onChanged,
    bool showSearchBox = false,
    String? label,
    bool locked = false,
  }) {
    Widget dropdown = AppDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      showSearchBox: showSearchBox,
      label: label,
    );
    if (locked) {
      return IgnorePointer(
        ignoring: true,
        child: Opacity(opacity: 0.6, child: dropdown),
      );
    }
    return dropdown;
  }

  Widget _buildGenerationField() {
    final l10n = AppLocalizations.of(context)!;
    Widget field = AppOutlineTextField(
      controller: _generationController,
      label: l10n.generationFieldLabel,
      hintText: l10n.generationFieldHint,
      keyboardType: TextInputType.number,
      validator: (val) => AppValidators.validateGeneration(context, val),
    );
    
    if (widget.isLockedContext && widget.initialGeneration != null) {
      return IgnorePointer(
        ignoring: true,
        child: Opacity(opacity: 0.6, child: field),
      );
    }
    return field;
  }

  String? _formatUIDate(String? backendDate) {
    if (backendDate == null) return null;
    final parts = backendDate.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return backendDate;
  }

  String? _formatBackendDate(String? uiDate) {
    if (uiDate == null) return null;
    final parts = uiDate.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return uiDate;
  }
}

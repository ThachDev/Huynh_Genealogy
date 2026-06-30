import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../auth/auth.dart';
import '../../../bloc/admin_member_form/admin_member_form_bloc.dart';

class AdminMemberFormPage extends StatefulWidget {
  final int? memberId; // null = Thêm mới, có giá trị = Chỉnh sửa

  const AdminMemberFormPage({super.key, this.memberId});

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

  // Selected values
  Gender _gender = Gender.male;
  MaritalStatus _maritalStatus = MaritalStatus.single;
  bool _isAlive = true;

  String? _dateOfBirth;
  String? _dateOfDeath;
  bool _isLunarBirthDate = false;
  bool _isLunarDeathDate = false;

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
    context
        .read<AdminMemberFormBloc>()
        .add(LoadAdminMemberFormEvent(memberId: widget.memberId));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _placeOfBirthController.dispose();
    _generationController.dispose();
    _notesController.dispose();
    _avatarUrlController.dispose();
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
      branchId: _branchId ?? existingMember?.branchId,
      parentId: _parentId ?? existingMember?.parentId,
      spouseId: _spouseId ?? existingMember?.spouseId,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      avatarUrl: _avatarUrlController.text.trim().isEmpty
          ? null
          : _avatarUrlController.text.trim(),
      familyId: familyId ?? existingMember?.familyId,
      isLunarBirthDate: _isLunarBirthDate,
      isLunarDeathDate: _isLunarDeathDate,
    );

    context.read<AdminMemberFormBloc>().add(SubmitAdminMemberFormEvent(member));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.memberId != null;
    final title = isEdit ? 'SỬA THÀNH VIÊN' : 'THÊM THÀNH VIÊN';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2825),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft,
              color: AppColors.gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(LucideIcons.trash2,
                  color: Colors.redAccent, size: 20),
              onPressed: _showDeleteConfirmDialog,
              tooltip: 'Xóa thành viên',
            ),
        ],
      ),
      body: BlocConsumer<AdminMemberFormBloc, AdminMemberFormState>(
        listener: (context, state) {
          if (state is AdminMemberFormSuccess) {
            AppSnackBar.success(
              context,
              state.isDeleted
                  ? 'Đã xóa thành viên thành công'
                  : 'Đã lưu thông tin thành viên thành công',
            );
            Navigator.pop(context, true);
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
              _gender = m.gender;
              _maritalStatus = m.maritalStatus;
              _isAlive = m.isAlive;
              _dateOfBirth = _formatUIDate(m.dateOfBirth);
              _dateOfDeath = _formatUIDate(m.dateOfDeath);
              _isLunarBirthDate = m.isLunarBirthDate;
              _isLunarDeathDate = m.isLunarDeathDate;
              _parentId = m.parentId;
              _spouseId = m.spouseId;
              _branchId = m.branchId;
            }
          }
        },
        builder: (context, state) {
          if (state is AdminMemberFormLoading ||
              state is AdminMemberFormSubmitting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          final existingMember =
              state is AdminMemberFormReady ? state.member : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
                          children: [
                            // Khoảng trống phần nửa dưới avatar + label
                            const SizedBox(height: 70),

                            // Hàng 1: Họ và tên + Thế hệ
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildTextField(
                                    controller: _fullNameController,
                                    label: 'Họ và tên',
                                    hintText: 'Nhập họ và tên',
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

                            // Hàng 2: Giới tính + Quan hệ / Hôn nhân
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('QUAN HỆ / HÔN NHÂN'),
                                      _buildDropdown<MaritalStatus>(
                                        value: _maritalStatus,
                                        items: const [
                                          DropdownItem(
                                              value: MaritalStatus.single,
                                              child: Text('Độc thân')),
                                          DropdownItem(
                                              value: MaritalStatus.married,
                                              child: Text('Đã kết hôn')),
                                          DropdownItem(
                                              value: MaritalStatus.divorced,
                                              child: Text('Ly hôn')),
                                          DropdownItem(
                                              value: MaritalStatus.widowed,
                                              child: Text('Góa phụ')),
                                          DropdownItem(
                                              value: MaritalStatus.unknown,
                                              child: Text('Chưa rõ')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(
                                                () => _maritalStatus = val);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('GIỚI TÍNH'),
                                      _buildDropdown<Gender>(
                                        value: _gender,
                                        items: const [
                                          DropdownItem(
                                              value: Gender.male,
                                              child: Text('Nam')),
                                          DropdownItem(
                                              value: Gender.female,
                                              child: Text('Nữ')),
                                          DropdownItem(
                                              value: Gender.unknown,
                                              child: Text('Chưa rõ')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(() => _gender = val);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Quê quán
                            _buildTextField(
                              controller: _placeOfBirthController,
                              label: 'Quê quán',
                              hintText: 'Quê quán hoặc nơi sinh',
                              validator: (val) =>
                                  AppValidators.validatePlaceOfBirth(
                                      context, val),
                            ),
                            const SizedBox(height: 16),
                            // Ngày sinh
                            FormField<String>(
                              validator: (val) =>
                                  AppValidators.validateDateOfBirth(
                                      context, _dateOfBirth),
                              builder: (formState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: AppDatePickerField(
                                            dateString: _dateOfBirth,
                                            label: 'Ngày sinh',
                                            hintText: 'dd/mm/yyyy',
                                            onDateSelected: (date) {
                                              final formattedDate =
                                                  "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                                              setState(() {
                                                _dateOfBirth = formattedDate;
                                              });
                                              formState
                                                  .didChange(formattedDate);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildLabel('LỊCH SINH'),
                                              _buildCalendarToggle(
                                                isLunar: _isLunarBirthDate,
                                                onChanged: (val) {
                                                  setState(() =>
                                                      _isLunarBirthDate = val);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (formState.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 6.0, left: 16.0),
                                        child: Text(
                                          formState.errorText ?? '',
                                          style: GoogleFonts.beVietnamPro(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Trạng thái
                            _buildStatusSwitchRow(),

                            // Nếu đã mất thì hiện ngày mất
                            if (!_isAlive) ...[
                              const SizedBox(height: 16),
                              const Divider(
                                  height: 1, color: Color(0xFFECE7E3)),
                              const SizedBox(height: 16),
                              FormField<String>(
                                validator: (val) =>
                                    AppValidators.validateDateOfDeath(
                                        context, _dateOfDeath, _isAlive),
                                builder: (formState) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: AppDatePickerField(
                                              dateString: _dateOfDeath,
                                              label: 'Ngày mất',
                                              hintText: 'dd/mm/yyyy',
                                              onDateSelected: (date) {
                                                final formattedDate =
                                                    "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                                                setState(() {
                                                  _dateOfDeath = formattedDate;
                                                });
                                                formState
                                                    .didChange(formattedDate);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildLabel('LỊCH MẤT'),
                                                _buildCalendarToggle(
                                                  isLunar: _isLunarDeathDate,
                                                  onChanged: (val) {
                                                    setState(() =>
                                                        _isLunarDeathDate =
                                                            val);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (formState.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6.0, left: 16.0),
                                          child: Text(
                                            formState.errorText ?? '',
                                            style: GoogleFonts.beVietnamPro(
                                              color: Colors.redAccent,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 16),

                            // Tiểu sử
                            _buildTextField(
                              controller: _notesController,
                              label: 'Tiểu sử',
                              hintText:
                                  'Nhập thông tin nghề nghiệp, học văn hoặc cột mốc quan trọng...',
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),

                      // Avatar nổi trên viền trên của card
                      _buildAvatarSection(),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Save & Cancel buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                                color: AppColors.wood, width: 1.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'HỦY BỎ',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              color: AppColors.wood,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          label: 'LƯU LẠI',
                          onPressed: () => _submitForm(existingMember),
                          size: AppButtonSize.large,
                          variant: AppButtonVariant.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection() {
    final avatarPath = _avatarUrlController.text.trim();
    Widget avatarWidget = const Icon(
      LucideIcons.user,
      size: 50,
      color: Color(0xFF7A7571),
    );

    if (avatarPath.isNotEmpty) {
      if (avatarPath.startsWith('http') || avatarPath.startsWith('https')) {
        avatarWidget = ClipOval(
          child: Image.network(
            avatarPath,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              LucideIcons.user,
              size: 50,
              color: Color(0xFF7A7571),
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
            errorBuilder: (context, error, stackTrace) => const Icon(
              LucideIcons.user,
              size: 50,
              color: Color(0xFF7A7571),
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
                  color: const Color(0xFFEAE7E3),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFFE8D4C8), width: 1.5),
                ),
                child: Center(child: avatarWidget),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.wood,
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
            'TẢI ẢNH ĐẠI DIỆN',
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.crimson,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    IconData? icon,
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2ECE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                Icon(icon, size: 20, color: AppColors.crimson),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B6661),
          letterSpacing: 0.5,
        ),
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
  }) {
    return AppDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildStatusSwitchRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('TRẠNG THÁI'),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFAF8),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: const Color(0xFFEFEBE7), width: 1.2),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isAlive ? LucideIcons.heart : LucideIcons.heartCrack,
                      size: 18,
                      color: _isAlive
                          ? AppColors.crimson
                          : const Color(0xFF7A7571),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sức khỏe / Sự sống',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B2825),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('TÙY CHỌN'),
              GestureDetector(
                onTap: () => setState(() => _isAlive = !_isAlive),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        _isAlive ? AppColors.crimson : const Color(0xFF6B6661),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _isAlive
                            ? const Alignment(-0.25, 0)
                            : const Alignment(0.25, 0),
                        child: Text(
                          _isAlive ? 'Còn sống' : 'Đã mất',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _isAlive
                            ? const Alignment(0.85, 0)
                            : const Alignment(-0.85, 0),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarToggle({
    required bool isLunar,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isLunar),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isLunar ? AppColors.crimson : const Color(0xFF6B6661),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isLunar
                  ? const Alignment(-0.25, 0)
                  : const Alignment(0.25, 0),
              child: Text(
                isLunar ? 'Âm lịch' : 'Dương lịch',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isLunar
                  ? const Alignment(0.85, 0)
                  : const Alignment(-0.85, 0),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationField() {
    return AppOutlineTextField(
      controller: _generationController,
      label: 'Thế hệ',
      hintText: 'VD: 3',
      keyboardType: TextInputType.number,
      validator: (val) => AppValidators.validateGeneration(context, val),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.parchment,
          title: Text('Xác nhận xóa',
              style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold)),
          content: Text(
              'Bạn có chắc chắn muốn xóa thành viên này khỏi gia phả? Hành động này không thể hoàn tác.',
              style: GoogleFonts.beVietnamPro()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('HỦY BỎ',
                  style: GoogleFonts.beVietnamPro(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .read<AdminMemberFormBloc>()
                    .add(DeleteAdminMemberFormEvent(widget.memberId!));
              },
              child: Text('XÓA',
                  style: GoogleFonts.beVietnamPro(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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

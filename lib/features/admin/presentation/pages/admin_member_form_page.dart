import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/auth.dart';
import '../bloc/admin_member_form/admin_member_form_bloc.dart';

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

  Future<void> _selectDate(BuildContext context, bool isDeathDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.wood,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final formattedDate =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        if (isDeathDate) {
          _dateOfDeath = formattedDate;
        } else {
          _dateOfBirth = formattedDate;
        }
      });
    }
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
      dateOfBirth: _dateOfBirth,
      placeOfBirth: _placeOfBirthController.text.trim().isEmpty
          ? null
          : _placeOfBirthController.text.trim(),
      isAlive: _isAlive,
      dateOfDeath: _isAlive ? null : _dateOfDeath,
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
    final title =
        widget.memberId == null ? 'Thêm Thành Viên' : 'Sửa Thành Viên';

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (widget.memberId != null)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
              onPressed: () {
                _showDeleteConfirmDialog();
              },
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
            // Populate form with existing data in edit mode
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
              _dateOfBirth = m.dateOfBirth;
              _dateOfDeath = m.dateOfDeath;
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full name
                  AppTextFieldLight(
                    label: 'Họ và tên *',
                    controller: _fullNameController,
                    hintText: 'Nhập đầy đủ họ và tên',
                    validator: (val) =>
                        AppValidators.validateFullName(context, val),
                    prefixIcon: const Icon(LucideIcons.user, size: 20),
                  ),
                  const SizedBox(height: 20),

                  // Gender & Marital status in a row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GIỚI TÍNH',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Gender>(
                              initialValue: _gender,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.crimson, width: 1.5),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: Gender.male, child: Text('Nam')),
                                DropdownMenuItem(
                                    value: Gender.female, child: Text('Nữ')),
                                DropdownMenuItem(
                                    value: Gender.unknown,
                                    child: Text('Chưa rõ')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _gender = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HÔN NHÂN',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<MaritalStatus>(
                              initialValue: _maritalStatus,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.crimson, width: 1.5),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: MaritalStatus.single,
                                    child: Text('Độc thân')),
                                DropdownMenuItem(
                                    value: MaritalStatus.married,
                                    child: Text('Đã kết hôn')),
                                DropdownMenuItem(
                                    value: MaritalStatus.divorced,
                                    child: Text('Ly hôn')),
                                DropdownMenuItem(
                                    value: MaritalStatus.widowed,
                                    child: Text('Góa phụ/Góa phu')),
                                DropdownMenuItem(
                                    value: MaritalStatus.unknown,
                                    child: Text('Chưa rõ')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _maritalStatus = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Generation & Place of birth
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFieldLight(
                          label: 'Thế hệ',
                          controller: _generationController,
                          hintText: 'Ví dụ: 1, 2, 3...',
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val != null &&
                                val.isNotEmpty &&
                                int.tryParse(val) == null) {
                              return 'Phải là số nguyên';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(LucideIcons.hash, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextFieldLight(
                          label: 'Nơi sinh',
                          controller: _placeOfBirthController,
                          hintText: 'Quê quán/Nơi sinh',
                          prefixIcon: const Icon(LucideIcons.mapPin, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Date of birth & Lunar option
                  Text(
                    'NGÀY SINH',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              prefixIcon:
                                  const Icon(LucideIcons.calendar, size: 20),
                            ),
                            child: Text(
                              _dateOfBirth ?? 'Chưa chọn',
                              style: GoogleFonts.inter(
                                color: _dateOfBirth != null
                                    ? AppColors.textPrimary
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _isLunarBirthDate,
                            activeColor: AppColors.wood,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _isLunarBirthDate = val);
                              }
                            },
                          ),
                          Text('Lịch âm',
                              style: GoogleFonts.inter(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Status (Alive / Deceased)
                  Row(
                    children: [
                      Text(
                        'CÒN SỐNG:',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: _isAlive,
                        activeThumbImage: null,
                        onChanged: (val) {
                          setState(() {
                            _isAlive = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // If deceased, show Death date & Lunar option
                  if (!_isAlive) ...[
                    Text(
                      'NGÀY MẤT',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                prefixIcon:
                                    const Icon(LucideIcons.calendar, size: 20),
                              ),
                              child: Text(
                                _dateOfDeath ?? 'Chưa chọn',
                                style: GoogleFonts.inter(
                                  color: _dateOfDeath != null
                                      ? AppColors.textPrimary
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: _isLunarDeathDate,
                              activeColor: AppColors.wood,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _isLunarDeathDate = val);
                                }
                              },
                            ),
                            Text('Lịch âm',
                                style: GoogleFonts.inter(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Avatar URL & Notes
                  AppTextFieldLight(
                    label: 'Đường dẫn ảnh đại diện (Avatar URL)',
                    controller: _avatarUrlController,
                    hintText: 'https://...',
                    prefixIcon: const Icon(LucideIcons.image, size: 20),
                  ),
                  const SizedBox(height: 20),

                  AppTextFieldLight(
                    label: 'Ghi chú / Tiểu sử ngắn',
                    controller: _notesController,
                    hintText: 'Nhập thông tin ghi chú...',
                    maxLines: 4,
                    prefixIcon: const Icon(LucideIcons.fileText, size: 20),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.wood),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'HỦY BỎ',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: AppColors.wood),
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

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Xác nhận xóa',
              style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold)),
          content: Text(
              'Bạn có chắc chắn muốn xóa thành viên này khỏi gia phả? Hành động này không thể hoàn tác.',
              style: GoogleFonts.inter()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  Text('HỦY BỎ', style: GoogleFonts.inter(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .read<AdminMemberFormBloc>()
                    .add(DeleteAdminMemberFormEvent(widget.memberId!));
              },
              child: Text('XÓA',
                  style: GoogleFonts.inter(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

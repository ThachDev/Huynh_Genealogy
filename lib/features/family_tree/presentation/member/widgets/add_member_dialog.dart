import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:app_family_tree/components/text/section_label.dart';
import 'package:app_family_tree/components/input/common_text_field.dart';
import 'package:app_family_tree/components/input/common_dropdown.dart';
import 'package:app_family_tree/components/dialog/common_dialog_container.dart';
import 'package:app_family_tree/components/dialog/success_dialog.dart';
import 'package:app_family_tree/components/button/common_buttons.dart';

class AddMemberDialog extends StatefulWidget {
  final int? initialParentId;
  final int? initialSpouseId;
  final int? initialBranchId;
  final MemberEntity? memberToEdit;

  const AddMemberDialog({
    super.key,
    this.initialParentId,
    this.initialSpouseId,
    this.initialBranchId,
    this.memberToEdit,
  });

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _generationController = TextEditingController(
    text: '1',
  );
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();
  final TextEditingController _deathAnniversaryController =
      TextEditingController();

  String _selectedGender = 'Nam';
  String _selectedMaritalStatus = 'unknown';

  final Map<String, String> _maritalStatusMap = {
    'single': 'Độc thân',
    'married': 'Đã kết hôn',
    'divorced': 'Ly hôn',
    'widowed': 'Góa',
    'unknown': 'Không rõ',
  };

  int? _selectedParentId;
  int? _selectedSpouseId;
  int? _selectedBranchId;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    if (widget.memberToEdit != null) {
      final m = widget.memberToEdit!;
      _nameController.text = m.fullName;
      _generationController.text = (m.generation ?? 1).toString();
      _placeOfBirthController.text = m.placeOfBirth ?? '';
      _noteController.text = m.notes ?? '';
      _selectedGender = m.gender == Gender.male
          ? 'Nam'
          : (m.gender == Gender.female ? 'Nữ' : 'Khác');
      _selectedMaritalStatus = m.maritalStatus.name;
      _selectedParentId = m.parentId;
      _selectedSpouseId = m.spouseId;
      _selectedBranchId = m.branchId;

      if (m.dateOfBirth != null) {
        try {
          final date = DateTime.parse(m.dateOfBirth!);
          _dobController.text = DateFormat('dd/MM/yyyy').format(date);
        } catch (_) {}
      }
      if (m.dateOfDeath != null) {
        try {
          final date = DateTime.parse(m.dateOfDeath!);
          _dodController.text = DateFormat('dd/MM/yyyy').format(date);
        } catch (_) {}
      }
    } else {
      _selectedParentId = widget.initialParentId;
      _selectedSpouseId = widget.initialSpouseId;
      _selectedBranchId = widget.initialBranchId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _generationController.dispose();
    _dobController.dispose();
    _dodController.dispose();
    _noteController.dispose();
    _placeOfBirthController.dispose();
    _deathAnniversaryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _imageFile = File(image.path));
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.crimson,
            onPrimary: Colors.white,
            onSurface: AppColors.crimson,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => controller.text = DateFormat('dd/MM/yyyy').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return BlocListener<MemberFormBloc, MemberFormState>(
      listener: (context, state) {
        if (state is MemberFormSuccess) {
          SuccessDialog.show(
            context,
            title: 'LƯU THÀNH CÔNG!',
            message: 'Đã lưu thông tin thành viên ${state.member.fullName}.',
          );
          context.read<TreeBloc>().add(LoadTreeEvent(force: true));
        } else if (state is MemberFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: CommonDialogContainer(
        title: widget.memberToEdit != null
            ? 'CHỈNH SỬA THÀNH VIÊN'
            : 'THÊM THÀNH VIÊN',
        icon: Icons.person_add_rounded,
        statusLabel: widget.memberToEdit != null ? 'SỬA' : 'MỚI',
        isDesktop: isDesktop,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildLeftColumn()),
                    const SizedBox(width: 40),
                    Expanded(flex: 3, child: _buildRightColumn()),
                  ],
                )
              else
                Column(
                  children: [
                    _buildLeftColumn(),
                    const SizedBox(height: 24),
                    _buildRightColumn(),
                  ],
                ),
              const SizedBox(height: 32),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAvatarPicker(),
        const SizedBox(height: 24),
        const SectionLabel('HỌ VÀ TÊN'),
        CommonTextField(controller: _nameController, hintText: 'Nguyễn Văn A'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('GIỚI TÍNH'),
                  CommonDropdown<String>(
                    value: _selectedGender,
                    items: const ['Nam', 'Nữ'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGender = val);
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
                  const SectionLabel('ĐỜI THỨ'),
                  CommonTextField(
                    controller: _generationController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('NGÀY SINH'),
                  CommonTextField(
                    controller: _dobController,
                    hintText: 'dd/mm/yyyy',
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: () => _selectDate(context, _dobController),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('NGÀY MẤT'),
                  CommonTextField(
                    controller: _dodController,
                    hintText: 'dd/mm/yyyy',
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: () => _selectDate(context, _dodController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('QUÊ QUÁN'),
        CommonTextField(
          controller: _placeOfBirthController,
          hintText: 'Gia Lai, Việt Nam',
        ),
        const SizedBox(height: 20),
        const SectionLabel('HÔN NHÂN'),
        CommonDropdown<String>(
          value: _selectedMaritalStatus,
          items: _maritalStatusMap.keys.toList(),
          itemLabel: (val) => _maritalStatusMap[val] ?? val,
          onChanged: (val) {
            if (val != null) setState(() => _selectedMaritalStatus = val);
          },
        ),
        const SizedBox(height: 20),
        _buildRelationSelectors(),
        const SizedBox(height: 20),
        const SectionLabel('GHI CHÚ / TIỂU SỬ'),
        CommonTextField(
          controller: _noteController,
          maxLines: 5,
          hintText: 'Thông tin thêm...',
        ),
      ],
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                        color: AppColors.gold,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            const Text(
              'CHỌN ẢNH CHÂN DUNG',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.crimson,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationSelectors() {
    return BlocBuilder<TreeBloc, TreeState>(
      builder: (context, state) {
        final allMembers = state is TreeLoaded
            ? state.allMembers
            : <MemberEntity>[];
        final branches = state is TreeLoaded
            ? state.branches
            : <BranchEntity>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('CHA / MẸ (Người trực hệ)'),
            CommonDropdown<int>(
              value: _selectedParentId,
              items: allMembers
                  .where((m) => m.id != widget.memberToEdit?.id)
                  .map((m) => m.id)
                  .toList(),
              itemLabel: (id) =>
                  allMembers.firstWhere((m) => m.id == id).fullName,
              hint: 'Chọn người đời trước',
              onChanged: (val) => setState(() => _selectedParentId = val),
            ),
            const SizedBox(height: 20),
            const SectionLabel('VỢ / CHỒNG'),
            CommonDropdown<int>(
              value: _selectedSpouseId,
              items: allMembers
                  .where((m) => m.id != widget.memberToEdit?.id)
                  .map((m) => m.id)
                  .toList(),
              itemLabel: (id) =>
                  allMembers.firstWhere((m) => m.id == id).fullName,
              hint: 'Chọn người phối ngẫu',
              onChanged: (val) => setState(() => _selectedSpouseId = val),
            ),
            if (branches.isNotEmpty) ...[
              const SizedBox(height: 20),
              const SectionLabel('CHI / NHÁNH GIA PHẢ'),
              CommonDropdown<int>(
                value: _selectedBranchId,
                items: branches.map((b) => b.id).toList(),
                itemLabel: (id) => branches.firstWhere((b) => b.id == id).name,
                hint: 'Dòng họ chính',
                onChanged: (val) => setState(() => _selectedBranchId = val),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SecondaryButton(
          text: 'HỦY BỎ',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 16),
        BlocBuilder<MemberFormBloc, MemberFormState>(
          builder: (context, state) => PrimaryButton(
            text: 'LƯU THÔNG TIN',
            isLoading: state is MemberFormSubmitting,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng nhập họ tên')));
      return;
    }

    String? formatToBE(String uiDate) {
      if (uiDate.isEmpty) return null;
      try {
        return DateFormat(
          'yyyy-MM-dd',
        ).format(DateFormat('dd/MM/yyyy').parse(uiDate));
      } catch (e) {
        return null;
      }
    }

    final member = MemberEntity(
      id: widget.memberToEdit?.id ?? 0,
      fullName: _nameController.text,
      gender: _selectedGender == 'Nam'
          ? Gender.male
          : (_selectedGender == 'Nữ' ? Gender.female : Gender.unknown),
      generation: int.tryParse(_generationController.text) ?? 1,
      dateOfBirth: formatToBE(_dobController.text),
      dateOfDeath: formatToBE(_dodController.text),
      placeOfBirth: _placeOfBirthController.text,
      maritalStatus: MaritalStatus.values.firstWhere(
        (e) => e.name == _selectedMaritalStatus,
        orElse: () => MaritalStatus.unknown,
      ),
      notes: _noteController.text,
      isAlive: _dodController.text.isEmpty,
      parentId: _selectedParentId,
      spouseId: _selectedSpouseId,
      branchId: _selectedBranchId,
      avatarUrl: widget.memberToEdit?.avatarUrl,
    );

    context.read<MemberFormBloc>().add(
      SubmitMemberFormEvent(member, imageFile: _imageFile),
    );
  }
}

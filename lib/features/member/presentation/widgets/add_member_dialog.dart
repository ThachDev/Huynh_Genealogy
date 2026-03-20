import 'package:app_family_tree/features/branch/domain/entities/branch.dart';
import 'package:app_family_tree/features/tree/presentation/bloc/tree_bloc.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/member/presentation/bloc/member_bloc.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:app_family_tree/components/text/section_label.dart';
import 'package:app_family_tree/components/input/common_text_field.dart';
import 'package:app_family_tree/components/input/common_dropdown.dart';
import 'package:app_family_tree/components/dialog/common_dialog_container.dart';
import 'package:app_family_tree/components/dialog/success_dialog.dart';
import 'package:app_family_tree/components/button/common_buttons.dart';
import 'package:resources/resources.dart';

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

  Gender _selectedGender = Gender.male;
  String _selectedMaritalStatus = 'unknown';

  Map<String, String> get _maritalStatusMap {
    final l10n = S.of(context);
    return {
      'single': l10n.maritalSingle,
      'married': l10n.maritalMarried,
      'divorced': l10n.maritalDivorced,
      'widowed': l10n.maritalWidowed,
      'unknown': l10n.maritalUnknown,
    };
  }

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
      _selectedGender = m.gender;
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

    return BlocListener<MemberBloc, MemberState>(
      listener: (context, state) {
        if (state is MemberSuccess) {
          SuccessDialog.show(
            context,
            title: S.of(context).saveSuccessTitle,
            message: S
                .of(context)
                .saveMemberSuccessMessage(state.member.fullName),
          );
          context.read<TreeBloc>().add(LoadTreeEvent(force: true));
        } else if (state is MemberError) {
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
            ? S.of(context).editMemberTitle
            : S.of(context).addMemberTitle,
        statusLabel: widget.memberToEdit != null
            ? S.of(context).statusEdit
            : S.of(context).statusNew,
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
        _buildAvatarPicker(S.of(context)),
        const SizedBox(height: 24),
        SectionLabel(S.of(context).fullNameLabel),
        CommonTextField(controller: _nameController, hintText: 'Nguyễn Văn A'),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(S.of(context).genderLabel),
                  CommonDropdown<Gender>(
                    value: _selectedGender,
                    items: const [Gender.male, Gender.female, Gender.unknown],
                    itemLabel: (g) {
                      if (g == Gender.male) return S.of(context).male;
                      if (g == Gender.female) return S.of(context).female;
                      return S.of(context).generalUnknown;
                    },
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
                  SectionLabel(S.of(context).generationLabel),
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
                  SectionLabel(S.of(context).dobLabel),
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
                  SectionLabel(S.of(context).dodLabel),
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
        SectionLabel(S.of(context).birthPlaceLabel),
        CommonTextField(
          controller: _placeOfBirthController,
          hintText: 'Gia Lai, Việt Nam',
        ),
        const SizedBox(height: 20),
        SectionLabel(S.of(context).maritalStatusLabel),
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
        SectionLabel(S.of(context).notesLabel),
        CommonTextField(
          controller: _noteController,
          maxLines: 5,
          hintText: '${S.of(context).aboutCopyrightTitle}...',
        ),
      ],
    );
  }

  Widget _buildAvatarPicker(S l10n) {
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
            Text(
              l10n.pickAvatarLabel,
              style: const TextStyle(
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
            SectionLabel(S.of(context).parentRelationLabel),
            CommonDropdown<int>(
              value: _selectedParentId,
              items: allMembers
                  .where((m) => m.id != widget.memberToEdit?.id)
                  .map((m) => m.id)
                  .toList(),
              itemLabel: (id) =>
                  allMembers.firstWhere((m) => m.id == id).fullName,
              hint: S.of(context).parentDropdownHint,
              onChanged: (val) => setState(() => _selectedParentId = val),
            ),
            const SizedBox(height: 20),
            SectionLabel(S.of(context).spouseRelationLabel),
            CommonDropdown<int>(
              value: _selectedSpouseId,
              items: allMembers
                  .where((m) => m.id != widget.memberToEdit?.id)
                  .map((m) => m.id)
                  .toList(),
              itemLabel: (id) =>
                  allMembers.firstWhere((m) => m.id == id).fullName,
              hint: S.of(context).spouseDropdownHint,
              onChanged: (val) => setState(() => _selectedSpouseId = val),
            ),
            if (branches.isNotEmpty) ...[
              const SizedBox(height: 20),
              SectionLabel(S.of(context).branchRelationLabel),
              CommonDropdown<int>(
                value: _selectedBranchId,
                items: branches.map((b) => b.id).toList(),
                itemLabel: (id) => branches.firstWhere((b) => b.id == id).name,
                hint: S.of(context).branchDropdownHint,
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
      children: [
        Expanded(
          child: SecondaryButton(
            text: S.of(context).cancelButton,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BlocBuilder<MemberBloc, MemberState>(
            builder: (context, state) => PrimaryButton(
              text: S.of(context).saveButton,
              isLoading: state is MemberSubmitting,
              onPressed: _submit,
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).errorEnterName)));
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
      gender: _selectedGender,
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

    context.read<MemberBloc>().add(
      SubmitMemberEvent(member: member, imageFile: _imageFile),
    );
  }
}

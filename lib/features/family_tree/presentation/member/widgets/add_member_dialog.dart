import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/app/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  bool _isSmartFilter = true;

  @override
  void initState() {
    super.initState();
    _dodController.addListener(() {
      setState(() {});
    });

    // Khởi tạo giá trị ban đầu nếu có
    if (widget.memberToEdit != null) {
      final m = widget.memberToEdit!;
      _nameController.text = m.fullName;
      _generationController.text = (m.generation ?? 1).toString();
      _placeOfBirthController.text = m.placeOfBirth ?? '';
      _noteController.text = m.notes ?? '';
      _selectedGender = m.gender == Gender.male
          ? 'Nam'
          : (m.gender == Gender.female ? 'Nữ' : 'Khác');
      _selectedMaritalStatus = _maritalStatusToKey(m.maritalStatus);
      _selectedParentId = m.parentId;
      _selectedSpouseId = m.spouseId;
      _selectedBranchId = m.branchId;

      // Định dạng ngày cho UI
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
      // Trường hợp thêm mới nhưng có gợi ý quan hệ
      _selectedParentId = widget.initialParentId;
      _selectedSpouseId = widget.initialSpouseId;
      _selectedBranchId = widget.initialBranchId;
    }
  }

  String _maritalStatusToKey(MaritalStatus status) {
    switch (status) {
      case MaritalStatus.single:
        return 'single';
      case MaritalStatus.married:
        return 'married';
      case MaritalStatus.divorced:
        return 'divorced';
      case MaritalStatus.widowed:
        return 'widowed';
      case MaritalStatus.unknown:
        return 'unknown';
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
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.crimson,
              onPrimary: Colors.white,
              onSurface: AppColors.crimson,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine layout based on screen width
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: isDesktop ? 800 : double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.crimson, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.memberToEdit != null
                            ? 'Chỉnh sửa thông tin'
                            : 'Thêm thành viên',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.crimson,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Content ──
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _buildLeftColumn()),
                              const SizedBox(width: 40),
                              Expanded(flex: 3, child: _buildRightColumn()),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLeftColumn(),
                              const SizedBox(height: 24),
                              _buildRightColumn(),
                            ],
                          ),
                  ),
                ),

                // ── Footer ──
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: BlocListener<MemberFormBloc, MemberFormState>(
                    listener: (context, state) {
                      if (state is MemberFormSuccess) {
                        // 1. Đóng ngay cửa sổ nhập liệu
                        Navigator.of(context).pop();

                        // 2. Phát lệnh load lại dữ liệu toàn app (ép buộc load mới)
                        context.read<TreeBloc>().add(
                          LoadTreeEvent(force: true),
                        );

                        // 3. Hiển thị thông báo thành công "Premium"
                        _showSuccessDialog(context, state.member.fullName);
                      } else if (state is MemberFormError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: ${state.message}'),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.crimson,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            'HỦY BỎ',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        BlocBuilder<MemberFormBloc, MemberFormState>(
                          builder: (context, state) {
                            final isSubmitting = state is MemberFormSubmitting;

                            return ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () {
                                      if (_nameController.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Vui lòng nhập họ tên',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // Map UI dates dd/mm/yyyy to BE dates yyyy-mm-dd
                                      String? formatToBE(String uiDate) {
                                        if (uiDate.isEmpty) return null;
                                        try {
                                          return DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(
                                            DateFormat(
                                              'dd/MM/yyyy',
                                            ).parse(uiDate),
                                          );
                                        } catch (e) {
                                          return null;
                                        }
                                      }

                                      final member = MemberEntity(
                                        id: widget.memberToEdit?.id ?? 0,
                                        fullName: _nameController.text,
                                        gender: _selectedGender == 'Nam'
                                            ? Gender.male
                                            : _selectedGender == 'Nữ'
                                            ? Gender.female
                                            : Gender.unknown,
                                        generation:
                                            int.tryParse(
                                              _generationController.text,
                                            ) ??
                                            1,
                                        dateOfBirth: formatToBE(
                                          _dobController.text,
                                        ),
                                        dateOfDeath: formatToBE(
                                          _dodController.text,
                                        ),
                                        placeOfBirth:
                                            _placeOfBirthController.text,
                                        maritalStatus: _parseMaritalStatus(
                                          _selectedMaritalStatus,
                                        ),
                                        notes: _noteController.text,
                                        isAlive: _dodController.text.isEmpty,
                                        parentId: _selectedParentId,
                                        spouseId: _selectedSpouseId,
                                        branchId: _selectedBranchId,
                                        avatarUrl:
                                            widget.memberToEdit?.avatarUrl,
                                      );

                                      context.read<MemberFormBloc>().add(
                                        SubmitMemberFormEvent(
                                          member,
                                          imageFile: _imageFile,
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.crimson,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black45,
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'LƯU THÔNG TIN',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Diagonal "MỚI" Label ──
          Positioned(
            top: 12,
            right: -24,
            child: Transform.rotate(
              angle: 0.785, // ~ 45 degrees
              child: Container(
                width: 100,
                height: 22,
                color: AppColors.gold,
                alignment: Alignment.center,
                child: Text(
                  widget.memberToEdit != null ? 'SỬA' : 'MỚI',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.crimson,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Avatar picker
        Center(
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
                      : Center(
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                            color: AppColors.crimson.withValues(alpha: 0.4),
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  _imageFile != null ? 'THAY ĐỔI ẢNH' : 'CHỌN ẢNH CHÂN DUNG',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson.withValues(alpha: 0.8),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Name
        _buildLabel('HỌ VÀ TÊN'),
        const SizedBox(height: 8),
        _buildTextField(_nameController, hintText: 'Nguyễn Văn A'),
        const SizedBox(height: 20),

        // Gender & Generation
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('GIỚI TÍNH'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedGender,
                    items: ['Nam', 'Nữ'],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedGender = val;
                          // Khi đổi giới tính, xóa người phối ngẫu hiện tại nếu không còn hợp lệ
                          _selectedSpouseId = null;
                        });
                      }
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
                  _buildLabel('ĐỜI THỨ'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _generationController,
                    onChanged: (val) {
                      setState(() {
                        // Khi người dùng tự tay đổi đời, xóa các lựa chọn phụ thuộc
                        _selectedParentId = null;
                        _selectedSpouseId = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Dates
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('NGÀY SINH'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _dobController,
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
                  _buildLabel('NGÀY MẤT (nếu có)'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _dodController,
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
        const SizedBox(height: 20),

        // Place of Birth & Marital Status
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('QUÊ QUÁN'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _placeOfBirthController,
                    hintText: 'Hà Nội, Việt Nam',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('HÔN NHÂN'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedMaritalStatus,
                    items: _maritalStatusMap.keys.toList(),
                    itemLabel: (val) => _maritalStatusMap[val] ?? val,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedMaritalStatus = val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_dodController.text.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildLabel('NGÀY GIỖ'),
          const SizedBox(height: 8),
          _buildTextField(
            _deathAnniversaryController,
            hintText: 'Chọn ngày giỗ',
            icon: Icons.access_time_outlined,
            readOnly: true,
            onTap: () => _selectDate(context, _deathAnniversaryController),
          ),
        ],
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Parent & Spouse selection
        BlocBuilder<TreeBloc, TreeState>(
          builder: (context, state) {
            final allMembers = state is TreeLoaded
                ? state.allMembers
                : <MemberEntity>[];
            final branches = state is TreeLoaded
                ? state.branches
                : <BranchEntity>[];

            // Common filters
            final availableMembers = allMembers.where((m) {
              if (widget.memberToEdit != null &&
                  m.id == widget.memberToEdit!.id) {
                return false;
              }
              return true;
            }).toList();

            final currentGen = int.tryParse(_generationController.text) ?? 1;
            final currentGender = _selectedGender == 'Nam'
                ? Gender.male
                : Gender.female;

            // Parents filtering
            final parentItems = availableMembers.where((m) {
              if (!_isSmartFilter) return true;
              // Parent should be in a previous generation
              return m.generation != null && m.generation! < currentGen;
            }).toList();

            // Spouses filtering
            final spouseItems = availableMembers.where((m) {
              if (!_isSmartFilter) return true;
              // Spouse should be opposite gender (if known) and similar generation
              bool genderMatch =
                  m.gender != currentGender && m.gender != Gender.unknown;
              bool genMatch = m.generation == currentGen;
              return genderMatch && genMatch;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('LỌC THÔNG MINH'),
                    Switch(
                      value: _isSmartFilter,
                      activeThumbColor: AppColors.crimson,
                      onChanged: (val) => setState(() => _isSmartFilter = val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildLabel('CHA / MẸ (Người trực hệ)'),
                const SizedBox(height: 8),
                _buildDropdown<int>(
                  value: _selectedParentId,
                  items: parentItems.map((m) => m.id).toList(),
                  itemLabel: (id) {
                    final m = allMembers.firstWhere((m) => m.id == id);
                    return '${m.fullName} (Đời ${m.generation ?? "?"})';
                  },
                  hint: parentItems.isEmpty
                      ? 'Không tìm thấy người phù hợp'
                      : 'Chọn người đời trước',
                  onChanged: (val) {
                    setState(() {
                      _selectedParentId = val;
                      if (val != null) {
                        final parent = allMembers.firstWhere(
                          (m) => m.id == val,
                        );
                        if (parent.generation != null) {
                          _generationController.text = (parent.generation! + 1)
                              .toString();
                        }
                        if (parent.branchId != null) {
                          _selectedBranchId = parent.branchId;
                        }
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildLabel('VỢ / CHỒNG'),
                const SizedBox(height: 8),
                _buildDropdown<int>(
                  value: _selectedSpouseId,
                  items: spouseItems.map((m) => m.id).toList(),
                  itemLabel: (id) {
                    final m = allMembers.firstWhere((m) => m.id == id);
                    return '${m.fullName} (Đời ${m.generation ?? "?"})';
                  },
                  hint: spouseItems.isEmpty
                      ? 'Không tìm thấy người phù hợp'
                      : 'Chọn người phối ngẫu',
                  onChanged: (val) => setState(() => _selectedSpouseId = val),
                ),
                if (branches.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildLabel('CHI / NHÁNH GIA PHẢ'),
                  const SizedBox(height: 8),
                  _buildDropdown<int>(
                    value: _selectedBranchId,
                    items: branches.map((b) => b.id).toList(),
                    itemLabel: (id) =>
                        branches.firstWhere((m) => m.id == id).name,
                    hint: 'Mặc định (Dòng họ chính)',
                    onChanged: (val) => setState(() => _selectedBranchId = val),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        // Note
        _buildLabel('GHI CHÚ / TIỂU SỬ'),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 8,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.crimson,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: icon != null
            ? Icon(icon, size: 20, color: Colors.black54)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    T? value,
    required List<T> items,
    String? hint,
    String Function(T)? itemLabel,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: hint != null
              ? Text(
                  hint,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                )
              : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          items: [
            // Null option for hint
            if (hint != null)
              DropdownMenuItem<T>(
                value: null,
                child: Text(
                  hint,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
            ...items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel != null ? itemLabel(item) : item.toString(),
                ),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    String name, {
    bool isDeleted = false,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Success',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        // Tự động đóng sau 1.5 giây
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) Navigator.of(context).pop();
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.crimson,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.crimson.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isDeleted ? 'ĐÃ XÓA!' : 'LƯU THÀNH CÔNG!',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.crimson,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isDeleted
                        ? 'Thành viên $name đã được xóa khỏi gia phả.'
                        : 'Đã thêm $name vào gia phả.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );
  }

  MaritalStatus _parseMaritalStatus(String status) {
    return MaritalStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => MaritalStatus.unknown,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/domain/entity/user_entity.dart';
import '../../../../../../core/domain/entity/member_entity.dart';
import '../../../../../../injection_container.dart';
import '../../../../admin.dart';

class AdminEditProfilePage extends StatefulWidget {
  final UserEntity? user;
  const AdminEditProfilePage({super.key, this.user});

  @override
  State<AdminEditProfilePage> createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  bool _isEditable = false;
  bool _isLoading = false;
  bool _isSaving = false;
  MemberEntity? _member;

  String? _localAvatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.user?.fullName ?? 'Huỳnh Gia Trưởng');
    _emailController =
        TextEditingController(text: widget.user?.email ?? 'truongtoc@gmail.com');
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _fetchMemberDetails();
  }

  void _fetchMemberDetails() async {
    final memberId = widget.user?.memberId;
    if (memberId == null || memberId == 0) {
      // Fallback/Mock values
      _phoneController.text = '0987654321';
      _addressController.text = 'Từ đường họ Huỳnh, Quảng Nam';
      return;
    }

    setState(() => _isLoading = true);
    final getMemberDetailUsecase = sl<GetMemberDetail>();
    final result = await getMemberDetailUsecase(memberId);

    if (mounted) {
      setState(() => _isLoading = false);
      result.fold(
        (failure) {
          AppSnackBar.error(context,
              'Không thể tải thông tin từ gia phả: ${failure.message}');
          _phoneController.text = '0987654321';
          _addressController.text = 'Từ đường họ Huỳnh, Quảng Nam';
        },
        (member) {
          setState(() {
            _member = member;
            _nameController.text = member.fullName;
            _phoneController.text = member.phone ?? '';
            _addressController.text = member.address ?? '';
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    if (!_isEditable) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'user_avatar_${DateTime.now().millisecondsSinceEpoch}${pickedFile.name.contains('.') ? pickedFile.name.substring(pickedFile.name.lastIndexOf('.')) : '.jpg'}';
        final savedFile =
            await File(pickedFile.path).copy('${tempDir.path}/$fileName');
        setState(() {
          _localAvatarPath = savedFile.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking avatar: $e");
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (_member == null) {
        // Mock save if no member linked
        AppSnackBar.success(context, 'Đã cập nhật thông tin cá nhân (Mock)!');
        setState(() {
          _isEditable = false;
        });
        return;
      }

      setState(() => _isSaving = true);
      final saveMemberUsecase = sl<SaveMember>();

      final updatedMember = MemberEntity(
        id: _member!.id,
        fullName: _nameController.text.trim(),
        gender: _member!.gender,
        dateOfBirth: _member!.dateOfBirth,
        placeOfBirth: _member!.placeOfBirth,
        isAlive: _member!.isAlive,
        dateOfDeath: _member!.dateOfDeath,
        maritalStatus: _member!.maritalStatus,
        generation: _member!.generation,
        branchId: _member!.branchId,
        branchName: _member!.branchName,
        parentId: _member!.parentId,
        spouseId: _member!.spouseId,
        notes: _member!.notes,
        avatarUrl: _localAvatarPath ?? _member!.avatarUrl,
        familyId: _member!.familyId,
        isLunarBirthDate: _member!.isLunarBirthDate,
        isLunarDeathDate: _member!.isLunarDeathDate,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      final result =
          await saveMemberUsecase(SaveMemberParams(member: updatedMember));

      if (mounted) {
        setState(() => _isSaving = false);
        result.fold(
          (failure) => AppSnackBar.error(context, failure.message),
          (savedMember) {
            AppSnackBar.success(
                context, 'Đã cập nhật thông tin cá nhân thành công!');
            setState(() {
              _member = savedMember;
              _isEditable = false;
              _localAvatarPath = null;
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUserAvatar = _localAvatarPath != null ||
        (_member?.avatarUrl != null && _member!.avatarUrl!.isNotEmpty) ||
        (widget.user?.avatarUrl != null && widget.user!.avatarUrl!.isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('CHỈNH SỬA NGƯỜI DÙNG'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditable ? LucideIcons.check : LucideIcons.edit2),
            onPressed: () {
              setState(() {
                _isEditable = !_isEditable;
                if (!_isEditable) {
                  _localAvatarPath = null;
                  if (_member != null) {
                    _nameController.text = _member!.fullName;
                    _phoneController.text = _member!.phone ?? '';
                    _addressController.text = _member!.address ?? '';
                  } else {
                    _nameController.text =
                        widget.user?.fullName ?? 'Huỳnh Gia Trưởng';
                    _phoneController.text = '0987654321';
                    _addressController.text = 'Từ đường họ Huỳnh, Quảng Nam';
                  }
                  _emailController.text =
                      widget.user?.email ?? 'truongtoc@gmail.com';
                }
              });
            },
            tooltip: _isEditable ? 'Hoàn tất' : 'Chỉnh sửa',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.crimson))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Clouds Banner + User Avatar Stack
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.crimson,
                          image: DecorationImage(
                            image: AssetImage('assets/images/clouds.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _pickAvatar,
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: AppColors.parchment,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.gold, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                    image: hasUserAvatar
                                        ? DecorationImage(
                                            image: _localAvatarPath != null
                                                ? FileImage(
                                                        File(_localAvatarPath!))
                                                    as ImageProvider
                                                : (_member?.avatarUrl != null &&
                                                        _member!
                                                            .avatarUrl!.isNotEmpty
                                                    ? NetworkImage(
                                                        _member!.avatarUrl!)
                                                    : NetworkImage(widget
                                                        .user!.avatarUrl!)
                                                        as ImageProvider),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: !hasUserAvatar
                                      ? const Center(
                                          child: Icon(LucideIcons.user,
                                              size: 45,
                                              color: AppColors.crimson),
                                        )
                                      : null,
                                ),
                              ),
                              if (_isEditable)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.gold,
                                    radius: 14,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(LucideIcons.camera,
                                          size: 12, color: Colors.white),
                                      onPressed: _pickAvatar,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 70),

                  // Form Fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_member == null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  border: Border.all(color: Colors.amber.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.alertTriangle, color: Colors.amber.shade800),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Tài khoản chưa liên kết với hồ sơ gia phả. Thông tin bên dưới đang hiển thị chế độ nháp.',
                                        style: TextStyle(
                                          color: Colors.amber.shade900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          AppOutlineTextField(
                            controller: _nameController,
                            label: 'Họ và tên',
                            hintText: 'Nhập đầy đủ họ và tên',
                            enabled: _isEditable,
                            prefixIcon:
                                const Icon(LucideIcons.user, color: AppColors.wood),
                            validator: (val) => val == null || val.trim().isEmpty
                                ? 'Vui lòng nhập họ tên'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          AppOutlineTextField(
                            controller: _emailController,
                            label: 'Email (Tài khoản)',
                            hintText: 'example@email.com',
                            enabled: false, // Locked account field
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon:
                                const Icon(LucideIcons.mail, color: AppColors.wood),
                          ),
                          const SizedBox(height: 16),
                          AppOutlineTextField(
                            controller: _phoneController,
                            label: 'Số điện thoại',
                            hintText: '0xxxxxxxxx',
                            enabled: _isEditable,
                            keyboardType: TextInputType.phone,
                            prefixIcon:
                                const Icon(LucideIcons.phone, color: AppColors.wood),
                            validator: (val) =>
                                val == null || val.trim().length < 10
                                    ? 'Số điện thoại không hợp lệ'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          AppOutlineTextField(
                            controller: _addressController,
                            label: 'Địa chỉ sinh sống',
                            hintText: 'Số nhà, đường, quận, thành phố...',
                            enabled: _isEditable,
                            prefixIcon:
                                const Icon(LucideIcons.mapPin, color: AppColors.wood),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: !_isEditable
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: AppButton(
                  label: 'LƯU THAY ĐỔI',
                  onPressed: _saveChanges,
                  isLoading: _isSaving,
                  fullWidth: true,
                  size: AppButtonSize.large,
                ),
              ),
            ),
    );
  }
}

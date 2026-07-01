import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_text_field.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/domain/entity/family_entity.dart';
import '../../../../../../injection_container.dart';
import '../../../../admin.dart';

class AdminClanInfoSettingsPage extends StatefulWidget {
  final FamilyEntity? family;
  const AdminClanInfoSettingsPage({super.key, this.family});

  @override
  State<AdminClanInfoSettingsPage> createState() =>
      _AdminClanInfoSettingsPageState();
}

class _AdminClanInfoSettingsPageState extends State<AdminClanInfoSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _originController;
  bool _isSaving = false;
  bool _isEditable = false;

  String? _localAvatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.family?.name ?? 'Huỳnh Gia Tộc');
    _descController = TextEditingController(
      text: widget.family?.description ??
          'Dòng họ Huỳnh phát tích từ vùng đất Quảng Nam, trải qua nhiều đời gìn giữ gia phong và nề nếp gia đình.',
    );
    _originController =
        TextEditingController(text: widget.family?.origin ?? 'None');
  }

  @override
  void didUpdateWidget(covariant AdminClanInfoSettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.family != oldWidget.family && widget.family != null) {
      _nameController.text = widget.family!.name;
      _descController.text = widget.family!.description ?? '';
      _originController.text = widget.family!.origin ?? 'None';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _originController.dispose();
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
            'clan_avatar_${DateTime.now().millisecondsSinceEpoch}${pickedFile.name.contains('.') ? pickedFile.name.substring(pickedFile.name.lastIndexOf('.')) : '.jpg'}';
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
    if (widget.family == null) {
      AppSnackBar.error(
          context, 'Không tìm thấy thông tin dòng họ để cập nhật');
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final updateFamilyUsecase = sl<UpdateFamily>();
      final result = await updateFamilyUsecase(UpdateFamilyParams(
        id: widget.family!.id,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        origin: _originController.text.trim(),
        logoUrl: _localAvatarPath,
      ));

      if (mounted) {
        setState(() => _isSaving = false);
        result.fold(
          (failure) => AppSnackBar.error(context, failure.message),
          (updatedFamily) {
            AppSnackBar.success(
                context, 'Cập nhật thông tin dòng tộc thành công!');
            context.read<AdminPendingRequestsBloc>().add(
                  LoadAdminPendingRequestsEvent(familyId: updatedFamily.id),
                );
            setState(() {
              _isEditable = false;
              _localAvatarPath = null;
            });
          },
        );
      }
    }
  }

  ImageProvider _getImageProvider(String? path, ImageProvider fallback) {
    if (path == null || path.isEmpty) return fallback;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final hasLogo = _localAvatarPath != null ||
        (widget.family?.logoUrl != null && widget.family!.logoUrl!.isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('THÔNG TIN DÒNG TỘC'),
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
                  _nameController.text = widget.family?.name ?? 'Huỳnh Gia Tộc';
                  _descController.text = widget.family?.description ??
                      'Dòng họ Huỳnh phát tích từ vùng đất Quảng Nam, trải qua nhiều đời gìn giữ gia phong và nề nếp gia đình.';
                  _originController.text = widget.family?.origin ?? 'None';
                }
              });
            },
            tooltip: _isEditable ? 'Hoàn tất' : 'Chỉnh sửa',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner & Avatar Preview
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
                              border:
                                  Border.all(color: AppColors.gold, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                              image: hasLogo
                                  ? DecorationImage(
                                      image: _localAvatarPath != null
                                          ? FileImage(File(_localAvatarPath!))
                                              as ImageProvider
                                          : _getImageProvider(
                                              widget.family!.logoUrl,
                                              const AssetImage(
                                                  'assets/images/clouds.png'),
                                            ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: !hasLogo
                                ? const Center(
                                    child: Icon(LucideIcons.shield,
                                        size: 45, color: AppColors.crimson),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Thông tin cơ bản',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.crimson,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldLight(
                      controller: _nameController,
                      label: 'Tên dòng tộc',
                      hintText: 'Nhập tên dòng tộc của bạn',
                      enabled: _isEditable,
                      prefixIcon: const Icon(LucideIcons.award,
                          color: AppColors.crimson),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Vui lòng nhập tên dòng tộc';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldLight(
                      controller: _originController,
                      label: 'Quê quán / Nguồn gốc',
                      hintText: 'Nhập quê quán tổ tiên dòng tộc',
                      enabled: _isEditable,
                      prefixIcon: const Icon(LucideIcons.mapPin,
                          color: AppColors.crimson),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Vui lòng nhập địa chỉ nguồn gốc dòng tộc';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldLight(
                      controller: _descController,
                      label: 'Mô tả chi tiết',
                      hintText: 'Tóm tắt lịch sử, gia phong dòng họ',
                      maxLines: 4,
                      enabled: _isEditable,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Icon(LucideIcons.text, color: AppColors.crimson),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
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

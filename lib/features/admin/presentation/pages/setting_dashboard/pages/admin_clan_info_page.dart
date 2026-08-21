import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/utils/file_size_guard.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../family_tree/domain/entities/family_entity.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../../core/di/injection_container.dart';
import '../../../../admin.dart';
import '../../../../../auth/domain/entities/user_entity.dart';

class AdminClanInfoPage extends StatefulWidget {

  const AdminClanInfoPage({
    super.key,
    this.family,
    this.user,
  });
  final FamilyEntity? family;
  final UserEntity? user;

  @override
  State<AdminClanInfoPage> createState() => _AdminClanInfoPageState();
}

class _AdminClanInfoPageState extends State<AdminClanInfoPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isEditable = false;
  bool _isSaving = false;

  bool get _isOwner {
    final role = (widget.user?.role ?? '').toUpperCase();
    return role == 'OWNER' || role == 'CREATOR';
  }

  // Controllers for Clan Info
  late TextEditingController _clanNameController;
  late TextEditingController _clanDescController;
  late TextEditingController _clanOriginController;
  String? _localClanLogoPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _clanNameController =
        TextEditingController(text: widget.family?.name ?? '');
    _clanDescController =
        TextEditingController(text: widget.family?.description ?? '');
    _clanOriginController =
        TextEditingController(text: widget.family?.origin ?? 'None');
  }

  @override
  void dispose() {
    _clanNameController.dispose();
    _clanDescController.dispose();
    _clanOriginController.dispose();
    super.dispose();
  }

  Future<void> _pickClanLogo() async {
    if (!_isEditable) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        if (await exceedsMaxFileSize(pickedFile, 10)) {
          if (!mounted) return;
          AppSnackBar.error(context, AppLocalizations.of(context).imageTooLargeFormat(10));
          return;
        }
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'clan_avatar_${DateTime.now().millisecondsSinceEpoch}${pickedFile.name.contains('.') ? pickedFile.name.substring(pickedFile.name.lastIndexOf('.')) : '.jpg'}';
        final savedFile =
            await File(pickedFile.path).copy('${tempDir.path}/$fileName');
        setState(() {
          _localClanLogoPath = savedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking avatar: $e');
    }
  }



  void _saveClanChanges() async {
    final l10n = AppLocalizations.of(context);
    if (widget.family == null) {
      AppSnackBar.error(context, l10n.noFamilyInfo);
      return;
    }

    final newName = _clanNameController.text.trim();
    final newDesc = _clanDescController.text.trim();
    final newOrigin = _clanOriginController.text.trim();
    final currentName = (widget.family!.name).trim();
    final currentDesc = (widget.family!.description ?? '').trim();
    final currentOrigin = (widget.family!.origin ?? 'None').trim();

    final isChanged = newName != currentName ||
        newDesc != currentDesc ||
        newOrigin != currentOrigin ||
        _localClanLogoPath != null;

    if (!isChanged) {
      setState(() {
        _isEditable = false;
        _localClanLogoPath = null;
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final updateFamilyUsecase = sl<UpdateFamily>();
      final result = await updateFamilyUsecase(UpdateFamilyParams(
        id: widget.family!.id,
        name: newName,
        description: newDesc,
        origin: newOrigin,
        logoUrl: _localClanLogoPath,
      ));

      if (mounted) {
        setState(() => _isSaving = false);
        result.fold(
          (failure) => AppSnackBar.error(context, failure.message),
          (updatedFamily) {
            AppSnackBar.success(context, l10n.updateFamilySuccess);
            context.read<AdminPendingRequestsBloc>().add(
                  LoadAdminPendingRequestsEvent(familyId: updatedFamily.id),
                );
            setState(() {
              _isEditable = false;
              _localClanLogoPath = null;
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.clanInfoSettingsTitle,
        actions: [
          if (widget.family != null && _isOwner)
            IconButton(
              icon: Icon(
                _isEditable ? LucideIcons.check : LucideIcons.edit3,
                color: context.textPrimary,
              ),
              onPressed: () {
                if (_isEditable) {
                  _saveClanChanges();
                } else {
                  setState(() {
                    _isEditable = true;
                  });
                }
              },
            ),
        ],
      ),
      body: AppBackgroundBody(
        child: _isSaving
            ? const Center(child: AppLoading(size: 80))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Avatar (Chỉ hiển thị cho Clan)
                      if (widget.family != null) ...[
                        GestureDetector(
                          onTap: _isEditable ? _pickClanLogo : null,
                          child: Stack(
                            children: [
                              _localClanLogoPath != null
                                  ? CircleAvatar(
                                      radius: 45,
                                      backgroundImage:
                                          FileImage(File(_localClanLogoPath!)),
                                    )
                                  : AppAvatar(
                                      avatarUrl: widget.family?.logoUrl,
                                      fullName: widget.family?.name ??
                                          _clanNameController.text,
                                      radius: 45,
                                      fontSize: 32,
                                    ),
                              if (_isEditable)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: context.accent,
                                    child: const Icon(
                                      LucideIcons.camera,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Clan Info Form
                      if (widget.family != null) _buildClanForm(l10n),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildClanForm(AppLocalizations l10n) {
    return Column(
      children: [
        AppOutlineTextField(
          controller: _clanNameController,
          label: l10n.clanNameLabel,
          hintText: l10n.clanNameHint,
          enabled: _isEditable,
          prefixIcon: Icon(LucideIcons.award, color: context.primary),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.clanNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppOutlineTextField(
          controller: _clanOriginController,
          label: l10n.originLabel,
          hintText: l10n.originHint,
          enabled: _isEditable,
          prefixIcon: Icon(LucideIcons.mapPin, color: context.primary),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.originRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppOutlineTextField(
          controller: _clanDescController,
          label: l10n.clanDescLabel,
          hintText: l10n.clanDescHint,
          minLines: 3,
          maxLines: 6,
          enabled: _isEditable,
        ),
      ],
    );
  }
}

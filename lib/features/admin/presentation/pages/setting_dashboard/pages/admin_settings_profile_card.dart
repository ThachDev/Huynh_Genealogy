import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/domain/entity/member_entity.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../../core/di/injection_container.dart';
import '../../../../../auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../../domain/usecase/get_member_detail.dart';
import '../../../../domain/usecase/save_member.dart';

class AdminSettingsProfileCard extends StatefulWidget {
  final dynamic user;

  const AdminSettingsProfileCard({
    super.key,
    required this.user,
  });

  @override
  State<AdminSettingsProfileCard> createState() =>
      _AdminSettingsProfileCardState();
}

class _AdminSettingsProfileCardState extends State<AdminSettingsProfileCard> {
  bool _isEditingInline = false;
  bool _isSaving = false;
  late TextEditingController _nameController;
  String? _localAvatarPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullName ?? '');
  }

  @override
  void didUpdateWidget(covariant AdminSettingsProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user?.fullName != oldWidget.user?.fullName &&
        !_isEditingInline) {
      _nameController.text = widget.user?.fullName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!_isEditingInline) return;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _localAvatarPath = picked.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking profile image: $e');
    }
  }

  Future<void> _saveChanges(int? memberId) async {
    final l10n = AppLocalizations.of(context)!;
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      AppSnackBar.error(context, 'Tên không được để trống');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final firebaseUser = fb.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(newName);
      }
      if (memberId != null && memberId != 0) {
        final getMemberDetail = sl<GetMemberDetail>();
        final result = await getMemberDetail(memberId);
        await result.fold(
          (failure) async => AppSnackBar.error(context, failure.message),
          (member) async {
            final updatedMember = MemberEntity(
              id: member.id,
              fullName: newName,
              gender: member.gender,
              dateOfBirth: member.dateOfBirth,
              placeOfBirth: member.placeOfBirth,
              isAlive: member.isAlive,
              dateOfDeath: member.dateOfDeath,
              maritalStatus: member.maritalStatus,
              generation: member.generation,
              branchId: member.branchId,
              branchName: member.branchName,
              parentId: member.parentId,
              motherId: member.motherId,
              spouseId: member.spouseId,
              notes: member.notes,
              avatarUrl: _localAvatarPath ?? member.avatarUrl,
              familyId: member.familyId,
              lunarBirthDate: member.lunarBirthDate,
              lunarDeathDate: member.lunarDeathDate,
              phone: member.phone,
              education: member.education,
              occupation: member.occupation,
            );

            final saveMember = sl<SaveMember>();
            final saveResult =
                await saveMember(SaveMemberParams(member: updatedMember));
            saveResult.fold(
              (failure) => AppSnackBar.error(context, failure.message),
              (_) {},
            );
          },
        );
      }

      if (mounted) {
        context.read<AuthBloc>().add(AuthProfileRefreshSilent());
        AppSnackBar.success(context, l10n.saveMemberSuccess);
        setState(() {
          _isEditingInline = false;
          _localAvatarPath = null;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onEditClick() async {
    final user = widget.user;
    if (user == null) return;

    final memberId = user.memberId as int?;

    if (_isEditingInline) {
      // User clicked check button to SAVE
      _saveChanges(memberId);
    } else {
      // User clicked edit button to EDIT INLINE
      setState(() {
        _isEditingInline = true;
        _nameController.text = user.fullName ?? '';
        _localAvatarPath = null;
      });
    }
  }

  ImageProvider _getAvatarImage(String? avatarUrl) {
    if (_localAvatarPath != null) {
      return FileImage(File(_localAvatarPath!));
    }
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      if (avatarUrl.startsWith('http')) {
        return NetworkImage(avatarUrl);
      }
      return FileImage(File(avatarUrl));
    }
    return const AssetImage('assets/images/wood_dragon.png');
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final avatarUrl = user?.avatarUrl as String?;
    final hasAvatar =
        (avatarUrl != null && avatarUrl.isNotEmpty) || _localAvatarPath != null;
    final email = (user?.email as String?) ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: _isEditingInline ? _pickImage : null,
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isEditingInline
                          ? context.accent
                          : context.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    color: context.primary.withValues(alpha: 0.08),
                    image: hasAvatar
                        ? DecorationImage(
                            image: _getAvatarImage(avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasAvatar
                      ? Icon(
                          LucideIcons.user,
                          size: 22,
                          color: context.primary.withValues(alpha: 0.5),
                        )
                      : null,
                ),
                if (_isEditingInline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: context.accent,
                      child: const Icon(
                        LucideIcons.camera,
                        size: 9,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Name & email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditingInline)
                  SizedBox(
                    height: 32,
                    child: TextField(
                      controller: _nameController,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        border: UnderlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                  )
                else
                  Text(
                    _nameController.text,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Edit/Save button
          GestureDetector(
            onTap: _isSaving ? null : _onEditClick,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isEditingInline
                    ? Colors.green.withValues(alpha: 0.1)
                    : context.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  : Icon(
                      _isEditingInline ? LucideIcons.check : LucideIcons.pencil,
                      size: 14,
                      color: _isEditingInline ? Colors.green : context.primary,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/domain/entity/family_entity.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../../injection_container.dart';
import '../../../../admin.dart';
import '../../../../../auth/auth.dart';

class AdminClanAndPersonalInfoPage extends StatefulWidget {
  final FamilyEntity? family;
  final UserEntity? user;

  const AdminClanAndPersonalInfoPage({
    super.key,
    this.family,
    this.user,
  });

  @override
  State<AdminClanAndPersonalInfoPage> createState() =>
      _AdminClanAndPersonalInfoPageState();
}

class _AdminClanAndPersonalInfoPageState
    extends State<AdminClanAndPersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  // View mode state
  bool _isClanView = true;
  bool _isEditable = false;
  bool _isSaving = false;
  bool _isEditor = false;

  // Controllers for Clan Info
  late TextEditingController _clanNameController;
  late TextEditingController _clanDescController;
  late TextEditingController _clanOriginController;
  String? _localClanLogoPath;

  // Controllers for Personal Info
  late TextEditingController _userNameController;
  late TextEditingController _userEmailController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Check if current user is an EDITOR
    final role = widget.user?.role ?? 'VIEWER';
    _isEditor = role.toUpperCase() == 'EDITOR';
    if (_isEditor || widget.family == null) {
      _isClanView =
          false; // Editors or users without family context only see personal info
    }

    // Initialize Clan Info
    _clanNameController =
        TextEditingController(text: widget.family?.name ?? '');
    _clanDescController =
        TextEditingController(text: widget.family?.description ?? '');
    _clanOriginController =
        TextEditingController(text: widget.family?.origin ?? 'None');

    // Initialize Personal Info
    _userNameController =
        TextEditingController(text: widget.user?.fullName ?? '');
    _userEmailController =
        TextEditingController(text: widget.user?.email ?? '');
  }

  @override
  void dispose() {
    _clanNameController.dispose();
    _clanDescController.dispose();
    _clanOriginController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  Future<void> _pickClanLogo() async {
    if (!_isEditable || !_isClanView) return;
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
          _localClanLogoPath = savedFile.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking avatar: $e");
    }
  }

  void _saveClanChanges() async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.family == null) {
      AppSnackBar.error(context, l10n.noFamilyInfo);
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final updateFamilyUsecase = sl<UpdateFamily>();
      final result = await updateFamilyUsecase(UpdateFamilyParams(
        id: widget.family!.id,
        name: _clanNameController.text.trim(),
        description: _clanDescController.text.trim(),
        origin: _clanOriginController.text.trim(),
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

  void _navigateToMemberFormSetup() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<AdminMemberFormBloc>(),
          child: AdminMemberFormPage(
            isOwnerSelfSetup: true,
            ownerUserId: widget.user?.id,
            initialFullName: widget.user?.fullName,
            initialAvatarUrl: widget.user?.avatarUrl,
          ),
        ),
      ),
    );
    if (result == true && mounted) {
      context.read<AuthBloc>().add(AuthProfileRefreshSilent());
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.background,
      extendBodyBehindAppBar: true,
      appBar: AppAppBar(
        title: _isClanView ? l10n.clanInfoSettingsTitle : l10n.accountInfoTitle,
        transparent: true,
        actions: (_isEditor || widget.family == null)
            ? null
            : [
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: context.surface,
                  elevation: 4,
                  offset: const Offset(0, 45),
                  icon:
                      const Icon(LucideIcons.moreVertical, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'swap') {
                      setState(() {
                        _isClanView = !_isClanView;
                        _isEditable = false; // Reset edit mode on view swap
                      });
                    } else if (value == 'edit') {
                      if (_isEditable) {
                        _saveClanChanges();
                      } else {
                        setState(() {
                          _isEditable = true;
                        });
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'swap',
                      height: 38,
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.refreshCw,
                            color: context.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isClanView
                                ? l10n.personalInfoLabel
                                : l10n.clanInfoLabel,
                            style: GoogleFonts.beVietnamPro(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (_isClanView) // Only clan info is editable from this screen
                      PopupMenuItem<String>(
                        value: 'edit',
                        height: 38,
                        child: Row(
                          children: [
                            Icon(
                              _isEditable
                                  ? LucideIcons.check
                                  : LucideIcons.edit2,
                              color:
                                  _isEditable ? Colors.green : context.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isEditable ? l10n.doneTooltip : l10n.editTooltip,
                              style: GoogleFonts.beVietnamPro(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
      ),
      body: AppBackgroundBody(
        child: _isSaving
            ? const Center(child: AppLoading(size: 80))
            : SingleChildScrollView(
                child: Column(
                children: [
                  // Banner & Avatar Stack
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
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
                          child: GestureDetector(
                            onTap: _isClanView ? _pickClanLogo : null,
                            child: Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: context.background,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: context.accent, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.resolve(
                                            Colors.black.withValues(alpha: 0.1),
                                            Colors.transparent),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    image: _isClanView
                                        ? DecorationImage(
                                            image: _getImageProvider(
                                              _localClanLogoPath ??
                                                  widget.family?.logoUrl,
                                              const AssetImage(
                                                  'assets/images/wood_dragon.png'),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : (widget.user?.avatarUrl != null &&
                                                widget
                                                    .user!.avatarUrl!.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    widget.user!.avatarUrl!),
                                                fit: BoxFit.cover,
                                              )
                                            : null),
                                  ),
                                  child: (!_isClanView &&
                                          (widget.user?.avatarUrl == null ||
                                              widget.user!.avatarUrl!.isEmpty))
                                      ? Center(
                                          child: Icon(
                                            LucideIcons.user,
                                            size: 45,
                                            color: context.primary,
                                          ),
                                        )
                                      : null,
                                ),
                                if (_isClanView && _isEditable)
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),

                  // Contents Form Fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: _isClanView
                          ? _buildClanForm(l10n)
                          : _buildUserForm(l10n),
                    ),
                  ),
                ],
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
          maxLines: 4,
          enabled: _isEditable,
          prefixIcon: Icon(LucideIcons.text, color: context.primary),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUserForm(AppLocalizations l10n) {
    return Column(
      children: [
        AppOutlineTextField(
          controller: _userNameController,
          label: l10n.fullNameLabel,
          hintText: l10n.nameHint,
          enabled: false,
          prefixIcon: Icon(LucideIcons.user, color: context.appBarBg),
        ),
        const SizedBox(height: 16),
        AppOutlineTextField(
          controller: _userEmailController,
          label: l10n.emailAccountLabel,
          hintText: l10n.emailHint,
          enabled: false,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(LucideIcons.mail, color: context.appBarBg),
        ),
        const SizedBox(height: 32),
        if (widget.family != null &&
            widget.user?.role == 'OWNER' &&
            (widget.user?.memberId == null || widget.user?.memberId == 0))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: context.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.alertCircle, color: Colors.brown),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.noProfileLink,
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noProfileLinkDesc,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: l10n.createProfileButton,
                    onPressed: _navigateToMemberFormSetup,
                    prefixIcon: const Icon(LucideIcons.userPlus, size: 16),
                    variant: AppButtonVariant.primary,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../bloc/onboarding_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class CreatorOnboardingWidget extends StatefulWidget {
  final UserEntity user;

  const CreatorOnboardingWidget({
    super.key,
    required this.user,
  });

  @override
  State<CreatorOnboardingWidget> createState() =>
      _CreatorOnboardingWidgetState();
}

class _CreatorOnboardingWidgetState extends State<CreatorOnboardingWidget> {
  final _createFormKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _familyDescriptionController = TextEditingController();
  late final TapGestureRecognizer _termsRecognizer;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    const double lineLength = 12.0;
    const double thickness = 2.0;
    const Color cornerColor = Colors.amber;

    return SizedBox(
      width: lineLength,
      height: lineLength,
      child: Stack(
        children: [
          // Horizontal line
          Positioned(
            top: isTop ? 0 : null,
            bottom: !isTop ? 0 : null,
            left: 0,
            right: 0,
            child: Container(
              height: thickness,
              color: cornerColor,
            ),
          ),
          // Vertical line
          Positioned(
            top: 0,
            bottom: 0,
            left: isLeft ? 0 : null,
            right: !isLeft ? 0 : null,
            child: Container(
              width: thickness,
              color: cornerColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _showTermsDialog;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _familyNameController.dispose();
    _familyDescriptionController.dispose();
    super.dispose();
  }

  void _onCreateFamilyPressed() {
    if (_createFormKey.currentState?.validate() ?? false) {
      context.read<OnboardingBloc>().add(
            CreateFamilyEvent(
              name: _familyNameController.text.trim(),
              description: _familyDescriptionController.text.trim(),
              logoUrl: _imageFile?.path,
              userId: widget.user.id,
            ),
          );
    }
  }

  void _showTermsDialog() {
    final l10n = AppLocalizations.of(context)!;
    AppDialog.custom(
      context,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                l10n.termsOfService,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.parchment),
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.termsContent,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.parchment),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: l10n.okLabel,
                onPressed: () => Navigator.of(context).pop(),
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _createFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const AppSectionHeader(
            title: "Khởi tạo gia tộc mới",
            description:
                "Khởi tạo cây gia phả số ngay hôm nay để kết nối các thế hệ và gìn giữ nguồn cội của dòng họ.",
            titleSize: 20,
            spacing: 8,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ẢNH ĐẠI DIỆN DÒNG HỌ",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C1E1C),
                          borderRadius: BorderRadius.circular(8),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(File(_imageFile!.path)),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image:
                                      AssetImage('assets/images/thumbnail.png'),
                                  opacity: 0.25,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: _imageFile != null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LucideIcons.edit2,
                                      size: 32,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.tapToChangePhoto,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    LucideIcons.camera,
                                    size: 38,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    l10n.tapToUploadPhoto,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      // Top Left Corner
                      Positioned(
                        top: 6,
                        left: 6,
                        child: _buildCorner(isTop: true, isLeft: true),
                      ),
                      // Top Right Corner
                      Positioned(
                        top: 6,
                        right: 6,
                        child: _buildCorner(isTop: true, isLeft: false),
                      ),
                      // Bottom Left Corner
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: _buildCorner(isTop: false, isLeft: true),
                      ),
                      // Bottom Right Corner
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: _buildCorner(isTop: false, isLeft: false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.familyNameLabel.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.parchment.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _familyNameController,
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l10n.familyNameHint,
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.familyNameRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.familyDescriptionLabel.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.parchment.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _familyDescriptionController,
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary, fontSize: 14),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: l10n.familyDescriptionHint,
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return AppButton(
                      label: l10n.initFamilyButton,
                      onPressed: _onCreateFamilyPressed,
                      isLoading: state is OnboardingLoading,
                      fullWidth: true,
                      size: AppButtonSize.large,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: l10n.byInitAgreeTerms,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        letterSpacing: 0.6,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.appTerms,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.crimson,
                            decoration: TextDecoration.underline,
                            letterSpacing: 0.6,
                            height: 1.3,
                          ),
                          recognizer: _termsRecognizer,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

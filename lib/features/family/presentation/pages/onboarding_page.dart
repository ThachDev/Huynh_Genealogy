import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../../../family_tree/domain/entity/member_entity.dart';
import '../../domain/entity/family_entity.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Common states
  bool _isRequestSent = false;
  int? _selectedPath; // null = select screen, 1 = Creator, 2 = Viewer

  // Creator Page states
  final _createFormKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _familyDescriptionController = TextEditingController();

  // Viewer Page states
  final _inviteCodeController = TextEditingController();
  FamilyEntity? _verifiedFamily;
  List<MemberEntity> _familyMembers = [];
  MemberEntity? _selectedMember;

  @override
  void dispose() {
    _familyNameController.dispose();
    _familyDescriptionController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _onCreateFamilyPressed(int userId) {
    if (_createFormKey.currentState?.validate() ?? false) {
      context.read<OnboardingBloc>().add(
            CreateFamilyEvent(
              name: _familyNameController.text.trim(),
              description: _familyDescriptionController.text.trim(),
              userId: userId,
            ),
          );
    }
  }

  void _onVerifyInviteCodePressed() {
    final code = _inviteCodeController.text.trim().toUpperCase();
    if (code.isNotEmpty) {
      context.read<OnboardingBloc>().add(VerifyInviteCodeEvent(code: code));
    } else {
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.warning(context, l10n.enterInviteCodeWarning);
    }
  }

  void _onJoinFamilyPressed(int userId) {
    if (_verifiedFamily != null) {
      context.read<OnboardingBloc>().add(
            JoinFamilyEvent(
              userId: userId,
              familyId: _verifiedFamily!.id,
              memberNodeId: _selectedMember?.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: AppColors.crimson)),
      );
    }

    final user = authState.user;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.onboardingTitle,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: (_selectedPath != null && !_isRequestSent)
            ? IconButton(
                icon:
                    const Icon(LucideIcons.arrowLeft, color: AppColors.crimson),
                onPressed: () {
                  setState(() {
                    _selectedPath = null;
                    _verifiedFamily = null;
                    _familyMembers = [];
                    _selectedMember = null;
                    _inviteCodeController.clear();
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            icon:
                const Icon(LucideIcons.logOut, color: AppColors.textSecondary),
            tooltip: l10n.logoutTooltip,
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingFailureState) {
            AppSnackBar.error(context, state.message);
          } else if (state is FamilyCreatedState) {
            AppSnackBar.success(context, l10n.createFamilySuccess);
            // Update Auth State with the new familyId so main.dart routes to Dashboard
            final updatedUser = user.copyWith(familyId: state.family.id);
            context.read<AuthBloc>().add(AuthUserUpdated(user: updatedUser));
          } else if (state is InviteCodeVerifiedState) {
            AppSnackBar.success(
              context,
              l10n.verifyInviteSuccess(state.family.name),
            );
            setState(() {
              _verifiedFamily = state.family;
              _familyMembers = state.members;
              _selectedMember = null;
            });
          } else if (state is JoinRequestSentState) {
            AppSnackBar.success(context, l10n.joinRequestSuccess);
            setState(() {
              _isRequestSent = true;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is OnboardingLoading;

          return AppLoadingOverlay(
            isLoading: isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isRequestSent)
                    _buildPendingApprovalView(user)
                  else if (_selectedPath == null)
                    _buildPathSelection(user)
                  else if (_selectedPath == 1)
                    _buildCreatorOnboarding(user)
                  else
                    _buildViewerOnboarding(user),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── PENDING APPROVAL VIEW (VIEWER WAITING) ───
  Widget _buildPendingApprovalView(UserEntity user) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 48),
          const Icon(
            LucideIcons.hourglass,
            size: 80,
            color: AppColors.gold,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.pendingApprovalTitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.crimson,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              l10n.pendingApprovalMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 36),
          AppButton(
            label: l10n.checkStatusButton,
            onPressed: () {
              context.read<AuthBloc>().add(AuthCheckRequested());
            },
            fullWidth: true,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.logoutTooltip,
            variant: AppButtonVariant.outline,
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  // ─── CREATOR ONBOARDING (CREATE FAMILY) ───
  Widget _buildCreatorOnboarding(UserEntity user) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _createFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.welcomeCreatorTitle(user.fullName),
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeCreatorSubtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          AppTextFieldLight(
            label: l10n.familyNameLabel,
            controller: _familyNameController,
            hintText: l10n.familyNameHint,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.familyNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppTextFieldLight(
            label: l10n.familyDescriptionLabel,
            controller: _familyDescriptionController,
            hintText: l10n.familyDescriptionHint,
            maxLines: 4,
          ),
          const SizedBox(height: 36),
          AppButton(
            label: l10n.initFamilyButton,
            onPressed: () => _onCreateFamilyPressed(user.id),
            fullWidth: true,
            size: AppButtonSize.large,
          ),
        ],
      ),
    );
  }

  // ─── VIEWER ONBOARDING (JOIN FAMILY) ───
  Widget _buildViewerOnboarding(UserEntity user) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcomeViewerTitle(user.fullName),
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.welcomeViewerSubtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextFieldLight(
                label: l10n.inviteCodeLabel,
                controller: _inviteCodeController,
                hintText: l10n.inviteCodeHint,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 52,
              child: AppButton(
                label: l10n.verifyButton,
                onPressed: _onVerifyInviteCodePressed,
                size: AppButtonSize.medium,
              ),
            ),
          ],
        ),
        if (_verifiedFamily != null) ...[
          const SizedBox(height: 32),
          const Divider(color: AppColors.gold, thickness: 0.5),
          const SizedBox(height: 20),
          Text(
            l10n.familyFoundTitle(_verifiedFamily!.name.toUpperCase()),
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.crimson,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.selectMemberPrompt,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
            ),
            child: DropdownButton<MemberEntity>(
              isExpanded: true,
              hint: Text(l10n.whoAreYouDropdownHint),
              underline: const SizedBox(),
              value: _selectedMember,
              items: _familyMembers.map((MemberEntity m) {
                return DropdownMenuItem<MemberEntity>(
                  value: m,
                  child: Text(m.fullName),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedMember = val;
                });
              },
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: l10n.sendJoinRequestButton,
            onPressed: () => _onJoinFamilyPressed(user.id),
            fullWidth: true,
            size: AppButtonSize.large,
          ),
        ],
      ],
    );
  }

  Widget _buildPathSelection(UserEntity user) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          l10n.welcomeViewerTitle(user.fullName),
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.chooseOnboardingSubtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),

        // Card 1: Khởi tạo gia tộc
        _buildSelectionCard(
          icon: LucideIcons.plusCircle,
          iconColor: AppColors.crimson,
          title: l10n.createFamilyCardTitle,
          subtitle: l10n.createFamilyCardDesc,
          onTap: () {
            setState(() {
              _selectedPath = 1;
            });
          },
        ),

        const SizedBox(height: 20),

        // Card 2: Gia nhập gia tộc có sẵn
        _buildSelectionCard(
          icon: LucideIcons.users,
          iconColor: AppColors.gold,
          title: l10n.joinFamilyCardTitle,
          subtitle: l10n.joinFamilyCardDesc,
          onTap: () {
            setState(() {
              _selectedPath = 2;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: iconColor.withValues(alpha: 0.05),
          highlightColor: iconColor.withValues(alpha: 0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Center(
                  child: Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

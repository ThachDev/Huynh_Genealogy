import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../../../family_tree/domain/entity/member_entity.dart';
import '../../domain/entity/family_entity.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class ViewerOnboardingWidget extends StatefulWidget {
  final UserEntity user;

  const ViewerOnboardingWidget({
    super.key,
    required this.user,
  });

  @override
  State<ViewerOnboardingWidget> createState() => _ViewerOnboardingWidgetState();
}

class _ViewerOnboardingWidgetState extends State<ViewerOnboardingWidget> {
  final _inviteCodeController = TextEditingController();
  FamilyEntity? _verifiedFamily;
  List<MemberEntity> _familyMembers = [];
  MemberEntity? _selectedMember;

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
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

  void _onJoinFamilyPressed() {
    if (_verifiedFamily != null && _selectedMember != null) {
      context.read<OnboardingBloc>().add(
            JoinFamilyEvent(
              familyId: _verifiedFamily!.id,
              memberNodeId: _selectedMember?.id,
              userId: widget.user.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is InviteCodeVerifiedState) {
          setState(() {
            _verifiedFamily = state.family;
            _familyMembers = state.members;
            _selectedMember = null;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3.5,
                height: 20,
                margin: const EdgeInsets.only(top: 4, right: 12),
                decoration: BoxDecoration(
                  color: AppColors.crimson,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.welcomeViewerTitle(widget.user.fullName),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                  ),
                ),
              ),
            ],
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
              onPressed: _selectedMember != null ? _onJoinFamilyPressed : null,
              fullWidth: true,
              size: AppButtonSize.large,
            ),
          ],
        ],
      ),
    );
  }
}

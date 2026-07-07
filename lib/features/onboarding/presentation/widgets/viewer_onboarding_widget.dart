import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../../core/domain/entity/family_entity.dart';
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

  bool _isNotOnTree = false;

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
    if (_verifiedFamily != null && (_selectedMember != null || _isNotOnTree)) {
      context.read<OnboardingBloc>().add(
            JoinFamilyEvent(
              familyId: _verifiedFamily!.id,
              memberNodeId: _isNotOnTree ? null : _selectedMember?.id,
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
            _isNotOnTree = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          AppSectionHeader(
            title: l10n.connectFamilySectionTitle,
            description: l10n.welcomeViewerSubtitle,
            titleSize: 20,
            indicatorHeight: 20,
            spacing: 8,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.resolve(Colors.black.withValues(alpha: 0.08), Colors.transparent),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.enterInviteCodeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Code Input Box
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: context.background.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: context.resolve(Colors.black.withValues(alpha: 0.03), Colors.transparent),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              LucideIcons.layoutGrid,
                              color: context.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _inviteCodeController,
                                style: GoogleFonts.inter(
                                  color: context.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.inviteCodeHintNew,
                                  hintStyle: GoogleFonts.inter(
                                    color: context.textSecondary
                                        .withValues(alpha: 0.4),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // QR Scanner Button
                    GestureDetector(
                      onTap: () async {
                        final code = await QrScannerDialog.show(context);
                        if (code != null && mounted) {
                          setState(() {
                            _inviteCodeController.text = code;
                          });
                          _onVerifyInviteCodePressed();
                        }
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: context.background.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: context.resolve(Colors.black.withValues(alpha: 0.03), Colors.transparent),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            LucideIcons.qrCode,
                            color: context.primary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.inviteCodeDescription,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: context.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return AppButton(
                      label: l10n.confirmJoinButton,
                      onPressed: _onVerifyInviteCodePressed,
                      isLoading: state is OnboardingLoading,
                      fullWidth: true,
                      size: AppButtonSize.large,
                    );
                  },
                ),

                if (_verifiedFamily != null) ...[
                  const SizedBox(height: 32),
                  Divider(color: context.background, thickness: 1),
                  const SizedBox(height: 20),
                  Text(
                    l10n.familyFoundTitle(_verifiedFamily!.name.toUpperCase()),
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.selectMemberPrompt,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isNotOnTree
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.resolve(const Color(0xFFFDFCFB), const Color(0xFF3D2C28)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: context.resolve(const Color(0xFFEFEBE7), const Color(0xFF5A4A44)), width: 1.2),
                          ),
                          child: Text(
                            l10n.joinRequestDescription,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: context.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        )
                      : AppDropdown<MemberEntity?>(
                          value: _selectedMember,
                          showSearchBox: true,
                          searchHint: l10n.searchNameHint,
                          items: [
                            DropdownItem<MemberEntity?>(
                              value: null,
                              child: Text(l10n.selectMemberHint),
                            ),
                            ..._familyMembers
                                .map((m) => DropdownItem<MemberEntity?>(
                                      value: m,
                                      child: Text(
                                          '${m.fullName} (Đời ${m.generation})'),
                                    )),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedMember = val;
                            });
                          },
                        ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _isNotOnTree,
                          onChanged: (val) {
                            setState(() {
                              _isNotOnTree = val ?? false;
                              if (_isNotOnTree) {
                                _selectedMember = null;
                              }
                            });
                          },
                          activeColor: context.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isNotOnTree = !_isNotOnTree;
                            if (_isNotOnTree) {
                              _selectedMember = null;
                            }
                          });
                        },
                        child: Text(
                          l10n.notOnTreeLabel,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return AppButton(
                        label: l10n.sendJoinRequestButton,
                        onPressed: (_selectedMember != null || _isNotOnTree)
                            ? _onJoinFamilyPressed
                            : null,
                        isLoading: state is OnboardingLoading,
                        fullWidth: true,
                        size: AppButtonSize.large,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

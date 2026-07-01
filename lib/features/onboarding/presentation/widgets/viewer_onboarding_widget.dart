import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
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
            title: "Kết nối dòng tộc",
            description: l10n.welcomeViewerSubtitle,
            titleSize: 20,
            indicatorHeight: 20,
            spacing: 8,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
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
                  l10n.enterInviteCodeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
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
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              LucideIcons.layoutGrid,
                              color: AppColors.crimson,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _inviteCodeController,
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.inviteCodeHintNew,
                                  hintStyle: GoogleFonts.inter(
                                    color: AppColors.textSecondary
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
                        child: const Center(
                          child: Icon(
                            LucideIcons.qrCode,
                            color: AppColors.crimson,
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
                    color: AppColors.textSecondary,
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
                  const Divider(color: AppColors.parchment, thickness: 1),
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
                  _isNotOnTree
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDFCFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFEFEBE7), width: 1.2),
                          ),
                          child: Text(
                            'Yêu cầu gia nhập sẽ được gửi tới Trưởng tộc. Trưởng tộc sẽ thêm và xếp bạn vào đúng vị trí trên cây gia phả sau khi phê duyệt.',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        )
                      : AppDropdown<MemberEntity?>(
                          value: _selectedMember,
                          showSearchBox: true,
                          searchHint: 'Tìm kiếm tên của bạn...',
                          items: [
                            const DropdownItem<MemberEntity?>(
                              value: null,
                              child: Text('Chọn thành viên...'),
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
                          activeColor: AppColors.crimson,
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
                          'Tên tôi chưa có trên cây gia phả',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
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

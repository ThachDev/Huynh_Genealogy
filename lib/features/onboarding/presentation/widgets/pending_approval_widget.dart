import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/domain/usecase/get_family_detail.dart';
import '../../../auth/auth.dart';

class PendingApprovalWidget extends StatefulWidget {

  const PendingApprovalWidget({
    super.key,
    required this.user,
    this.clanLeaderName,
    this.clanLeaderPhone,
    this.familyId,
  });
  final UserEntity user;
  final String? clanLeaderName;
  final String? clanLeaderPhone;
  final int? familyId;

  @override
  State<PendingApprovalWidget> createState() => _PendingApprovalWidgetState();
}

class _PendingApprovalWidgetState extends State<PendingApprovalWidget> {
  String? _leaderName;
  String? _leaderPhone;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _leaderName = widget.clanLeaderName;
    _leaderPhone = widget.clanLeaderPhone;

    if (_leaderName == null || _leaderPhone == null) {
      _fetchLeaderInfo();
    }
  }

  Future<void> _fetchLeaderInfo() async {
    final targetFamilyId = widget.familyId ?? widget.user.familyId;
    if (targetFamilyId == null || targetFamilyId == 0) return;

    setState(() {
      _isLoading = true;
    });

    final getFamilyDetail = sl<GetFamilyDetail>();
    final result = await getFamilyDetail(targetFamilyId);

    if (mounted) {
      result.fold(
        (_) => null,
        (family) {
          setState(() {
            _leaderName = family.creatorName;
            _leaderPhone = family.creatorPhone;
          });
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final hasLeaderInfo = _leaderName != null &&
        _leaderName!.isNotEmpty &&
        _leaderPhone != null &&
        _leaderPhone!.isNotEmpty;

    final message = hasLeaderInfo
        ? l10n.pendingApprovalMessage(_leaderName!, _leaderPhone!)
        : l10n.pendingApprovalMessageSimple;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Lottie.asset(
            'assets/json/loading.json',
            height: 180,
            repeat: true,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.pendingApprovalTitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _isLoading
                ? const AppLoading(size: 24)
                : hasLeaderInfo
                    ? Text.rich(
                        TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: context.textSecondary,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.pendingApprovalRequestSent,
                            ),
                            TextSpan(
                              text: l10n.pendingApprovalLeaderFormat(
                                  _leaderName!, _leaderPhone!),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: l10n.pendingApprovalWaitEnd,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: context.textSecondary,
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
            label: l10n.logoutLabel,
            variant: AppButtonVariant.outline,
            color: context.textPrimary,
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

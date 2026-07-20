import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../auth/auth.dart';
import '../../../bloc/admin_dissolve_clan_bloc/admin_dissolve_clan_bloc.dart';

class AdminDissolveClanPage extends StatefulWidget {
  final int familyId;
  final String familyName;

  const AdminDissolveClanPage({
    super.key,
    required this.familyId,
    required this.familyName,
  });

  @override
  State<AdminDissolveClanPage> createState() => _AdminDissolveClanPageState();
}

class _AdminDissolveClanPageState extends State<AdminDissolveClanPage> {
  final _confirmController = TextEditingController();
  bool _canDissolve = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _confirmController.removeListener(_onTextChanged);
    _confirmController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _canDissolve = _confirmController.text.trim() == widget.familyName;
    });
  }

  void _dissolveClan() {
    if (!_canDissolve) return;

    final l10n = AppLocalizations.of(context)!;
    AppDialog.confirm(
      context,
      title: l10n.deletePermanentDialogTitle,
      message: l10n.deletePermanentDialogMessage(widget.familyName),
      confirmLabel: l10n.confirmDeletePermanentLabel,
      cancelLabel: l10n.formCancel,
      type: AppDialogType.danger,
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context
            .read<AdminDissolveClanBloc>()
            .add(DeleteFamilyRequested(familyId: widget.familyId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AdminDissolveClanBloc, AdminDissolveClanState>(
      listener: (context, state) {
        if (state is AdminDissolveClanSuccess) {
          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated) {
            final updatedUser = authState.user.copyWith(
              familyId: null,
              role: 'VIEWER',
            );
            context.read<AuthBloc>().add(AuthUserUpdated(user: updatedUser));
          }
          AppSnackBar.success(
            context,
            l10n.dissolveSuccessMessage,
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is AdminDissolveClanFailure) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.background,
      appBar: AppAppBar(title: l10n.dissolveClanTitle),
        body: AppBackgroundBody(
          child: BlocBuilder<AdminDissolveClanBloc, AdminDissolveClanState>(
            builder: (context, state) {
            final isLoading = state is AdminDissolveClanLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: AppColors.error.withValues(alpha: 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.alertOctagon,
                                color: AppColors.error, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.irreversibleActionTitle,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.irreversibleWarningDesc,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    height: 1.5,
                                    color:
                                        AppColors.error.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: context.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: context.accent.withValues(alpha: 0.1)),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.confirmDissolveTitle,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.confirmDissolveInstruction,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: context.primary.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      context.primary.withValues(alpha: 0.15)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  l10n.enterLabel,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: context.textSecondary),
                                ),
                                Text(
                                  widget.familyName,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: context.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextFieldLight(
                            controller: _confirmController,
                            label: l10n.reenterClanNameLabel,
                            hintText: l10n.reenterClanNameHint,
                            prefixIcon: const Icon(LucideIcons.trash2,
                                color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: l10n.dissolvePermanentButton,
                    onPressed: _canDissolve ? _dissolveClan : null,
                    isLoading: isLoading,
                    fullWidth: true,
                    size: AppButtonSize.large,
                    variant: AppButtonVariant.danger,
                  ),
                ],
              ),
            );
          },
        ),),
      ),
    );
  }
}

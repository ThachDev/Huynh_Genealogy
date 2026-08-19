import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../auth/auth.dart';
import '../../../bloc/admin_dissolve_clan_bloc/admin_dissolve_clan_bloc.dart';

class AdminDissolveClanPage extends StatefulWidget {

  const AdminDissolveClanPage({
    super.key,
    required this.familyId,
    required this.familyName,
  });
  final int familyId;
  final String familyName;

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
    final text = _confirmController.text.trim().toUpperCase();
    final l10n = AppLocalizations.of(context);
    setState(() {
      _canDissolve = text == widget.familyName.trim().toUpperCase() ||
          text == l10n.dissolveWord.toUpperCase();
    });
  }

  void _dissolveClan() async {
    if (!_canDissolve) return;

    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialog.confirmWithInput(
      context,
      title: l10n.deletePermanentDialogTitle,
      message: l10n.deletePermanentDialogMessage(widget.familyName),
      requiredWord: l10n.dissolveWord,
      inputInstruction: l10n.confirmDissolveInstruction,
      confirmLabel: l10n.confirmDeletePermanentLabel,
      cancelLabel: l10n.formCancel,
    );

    if (confirmed == true && mounted) {
      context
          .read<AdminDissolveClanBloc>()
          .add(DeleteFamilyRequested(familyId: widget.familyId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthBloc>().state;
    final role = authState is Authenticated
        ? authState.user.role.toUpperCase()
        : '';
    final isOwner = role == 'OWNER' || role == 'CREATOR';
    if (!isOwner) {
      return Scaffold(
        backgroundColor: context.background,
        appBar: AppAppBar(title: l10n.dissolveClanTitle),
        body: AppBackgroundBody(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.shieldAlert,
                      color: context.textSecondary, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    l10n.rolePermissionDenied,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      color: context.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Warning Section (no card background)
                    Row(
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          color: context.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.irreversibleActionTitle,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.irreversibleWarningDesc,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.6,
                        color: context.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      height: 1,
                      color: context.textSecondary.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 24),

                    // Confirmation Section (no card background)
                    Text(
                      l10n.confirmDissolveTitle,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Instruction line
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textSecondary,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: '${l10n.enterLabel} '),
                          TextSpan(
                            text: '"${widget.familyName}"',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                          TextSpan(text: l10n.orLabel),
                          TextSpan(
                            text: '"${l10n.dissolveWord}"',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Text Field
                    AppTextFieldLight(
                      controller: _confirmController,
                      label: l10n.reenterClanNameLabel,
                      hintText: l10n.dissolveWord,
                      prefixIcon: Icon(
                        LucideIcons.trash2,
                        color: context.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Action Button
                    AppButton(
                      label: l10n.dissolvePermanentButton,
                      onPressed: _canDissolve ? _dissolveClan : null,
                      isLoading: isLoading,
                      fullWidth: true,
                      size: AppButtonSize.large,
                      variant: AppButtonVariant.danger,
                      color: context.primary,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

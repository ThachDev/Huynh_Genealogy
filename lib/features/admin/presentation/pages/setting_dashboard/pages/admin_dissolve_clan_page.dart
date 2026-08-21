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
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── 1. Danger Warning Card ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: context.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      context.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LucideIcons.alertTriangle,
                                  color: context.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
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
                          const SizedBox(height: 12),
                          Text(
                            l10n.irreversibleWarningDesc,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 1.55,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 2. Verification / Confirmation Card ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: context.accent.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.confirmDissolveTitle,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.enterLabel,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildKeywordChip(
                                context,
                                text: widget.familyName,
                                onTap: () {
                                  _confirmController.text = widget.familyName;
                                },
                              ),
                              _buildKeywordChip(
                                context,
                                text: l10n.dissolveWord,
                                onTap: () {
                                  _confirmController.text = l10n.dissolveWord;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppTextFieldLight(
                            controller: _confirmController,
                            label: l10n.reenterClanNameLabel,
                            hintText: l10n.dissolveWord,
                            prefixIcon: Icon(
                              LucideIcons.trash2,
                              color: _canDissolve
                                  ? context.primary
                                  : context.textSecondary,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── 3. Submit Button ──
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

  Widget _buildKeywordChip(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: context.primary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                LucideIcons.copy,
                size: 12,
                color: context.primary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


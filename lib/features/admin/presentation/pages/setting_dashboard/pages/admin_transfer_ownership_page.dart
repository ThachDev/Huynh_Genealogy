import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/resources/app_localizations.dart';
import 'package:giatocviet/features/auth/auth.dart';
import 'package:giatocviet/features/admin/admin.dart';

class AdminTransferOwnershipPage extends StatefulWidget {
  const AdminTransferOwnershipPage({super.key});

  @override
  State<AdminTransferOwnershipPage> createState() =>
      _AdminTransferOwnershipPageState();
}

class _AdminTransferOwnershipPageState
    extends State<AdminTransferOwnershipPage> {
  int? _selectedUserId;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        context
            .read<AdminTransferOwnershipBloc>()
            .add(LoadCandidatesEvent(familyId: authState.user.familyId!));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmTransfer(int familyId, int newOwnerUserId, String newOwnerName) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isValid =
                confirmController.text.trim().toUpperCase() == l10n.confirmWord.toUpperCase();
            return AlertDialog(
              backgroundColor: ctx.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.warningDialogTitle,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.warningDialogConfirmMessage(newOwnerName),
                    style: GoogleFonts.beVietnamPro(fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.typeConfirmToTransfer,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ctx.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    onChanged: (_) => setDialogState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.confirmWord,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, false),
                  child: Text(l10n.formCancel, style: GoogleFonts.beVietnamPro()),
                ),
                AppButton(
                  label: l10n.confirmTransferButton,
                  variant: AppButtonVariant.danger,
                  onPressed: isValid ? () => Navigator.pop(dialogCtx, true) : null,
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true && mounted) {
      context.read<AdminTransferOwnershipBloc>().add(
            TransferOwnershipEvent(
              familyId: familyId,
              newOwnerUserId: newOwnerUserId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: l10n.transferOwnershipLabel),
      body: AppBackgroundBody(
        child: BlocConsumer<AdminTransferOwnershipBloc,
            AdminTransferOwnershipState>(
          listener: (context, state) {
            if (state is AdminTransferOwnershipSuccess) {
              AppSnackBar.success(context, l10n.transferSuccess);
              context.read<AuthBloc>().add(AuthProfileRefreshSilent());
              Navigator.pop(context, true);
            } else if (state is AdminTransferOwnershipFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AdminTransferOwnershipLoading ||
                state is AdminTransferOwnershipInitial) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: ListPageSkeleton(
                  itemCount: 6,
                  showBottomButton: true,
                ),
              );
            }

            if (state is AdminTransferOwnershipFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.alertCircle,
                          color: AppColors.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          color: AppColors.error,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: l10n.retryButton,
                        onPressed: () {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is Authenticated &&
                              authState.user.familyId != null) {
                            context.read<AdminTransferOwnershipBloc>().add(
                                  LoadCandidatesEvent(
                                      familyId: authState.user.familyId!),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is AdminTransferOwnershipSubmitting) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoading(size: 80),
                    const SizedBox(height: 16),
                    Text(l10n.transferProcessing),
                  ],
                ),
              );
            }

            final candidates = state is AdminTransferOwnershipLoaded
                ? state.candidates
                : <dynamic>[];

            if (candidates.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.users,
                          color: context.textSecondary, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noEligibleMembers,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          color: context.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final query = _searchController.text.trim().toLowerCase();
            final filtered = query.isEmpty
                ? candidates
                : candidates
                    .where((c) =>
                        (c.userFullName ?? '').toLowerCase().contains(query))
                    .toList();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chooseRecipientLabel,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.transferDesc,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: l10n.searchMemberHint,
                                hintStyle: GoogleFonts.inter(fontSize: 13),
                                prefixIcon: Icon(LucideIcons.search,
                                    size: 18, color: context.textSecondary),
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: context.accent
                                          .withValues(alpha: 0.2)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: context.accent
                                          .withValues(alpha: 0.2)),
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          Expanded(
                            child: filtered.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        l10n.noMemberFound,
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: context.textSecondary),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: context.accent
                                          .withValues(alpha: 0.05),
                                    ),
                                    itemBuilder: (context, index) {
                                      final candidate = filtered[index];
                                      final isSelected =
                                          _selectedUserId == candidate.userId;

                                      return ListTile(
                                        onTap: () {
                                          setState(() {
                                            if (_selectedUserId ==
                                                candidate.userId) {
                                              _selectedUserId = null;
                                            } else {
                                              _selectedUserId =
                                                  candidate.userId;
                                            }
                                          });
                                        },
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                        leading: AppAvatar(
                                          avatarUrl: candidate.userAvatarUrl,
                                          fullName: candidate.userFullName,
                                          radius: 20,
                                          fallbackInitial: 'U',
                                        ),
                                        title: Text(
                                          candidate.userFullName ??
                                              l10n.roleViewer,
                                          style: GoogleFonts.beVietnamPro(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: context.textPrimary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${AdminDashboardPage.roleLabel(candidate.role, context)} • ${candidate.userEmail ?? l10n.noEmail}',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: context.textSecondary,
                                          ),
                                        ),
                                        trailing: Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_unchecked,
                                          color: isSelected
                                              ? context.primary
                                              : context.textSecondary,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: l10n.proceedTransferButton,
                    onPressed: _selectedUserId != null
                        ? () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is Authenticated &&
                                authState.user.familyId != null) {
                              final selectedCandidate = candidates
                                  .where((c) => c.userId == _selectedUserId)
                                  .firstOrNull;
                              if (selectedCandidate != null) {
                                _confirmTransfer(
                                  authState.user.familyId!,
                                  selectedCandidate.userId,
                                  selectedCandidate.userFullName ??
                                      l10n.roleViewer,
                                );
                              }
                            }
                          }
                        : null,
                    fullWidth: true,
                    size: AppButtonSize.medium,
                    variant: AppButtonVariant.primary,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

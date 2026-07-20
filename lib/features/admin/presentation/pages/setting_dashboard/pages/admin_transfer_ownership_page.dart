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
  int? _selectedIndex;
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

  void _confirmTransfer(int familyId, int newOwnerUserId, String newOwnerName) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: AppColors.error.withValues(alpha: 0.3), width: 1),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle,
                color: AppColors.error, size: 22),
            const SizedBox(width: 10),
            Text(l10n.warningDialogTitle,
                style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.warningDialogMessage,
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.warningDialogConfirmMessage(newOwnerName),
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.white60, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.formCancel,
                style: GoogleFonts.inter(
                    color: Colors.white60, fontWeight: FontWeight.w600)),
          ),
          AppButton(
            label: l10n.confirmTransferButton,
            onPressed: () => Navigator.of(ctx).pop(true),
            variant: AppButtonVariant.danger,
            size: AppButtonSize.small,
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.read<AdminTransferOwnershipBloc>().add(
              TransferOwnershipEvent(
                familyId: familyId,
                newOwnerUserId: newOwnerUserId,
              ),
            );
      }
    });
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
              Navigator.pop(context);
            } else if (state is AdminTransferOwnershipFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AdminTransferOwnershipLoading ||
                state is AdminTransferOwnershipInitial) {
              return const Center(
                child: AppLoading(size: 80),
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
                                : RadioGroup<int>(
                                    groupValue: _selectedIndex,
                                    onChanged: (val) =>
                                        setState(() => _selectedIndex = val),
                                    child: ListView.separated(
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

                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                          leading: CircleAvatar(
                                            backgroundColor: context.appBarBg
                                                .withValues(alpha: 0.08),
                                            backgroundImage: candidate
                                                        .userAvatarUrl !=
                                                    null
                                                ? NetworkImage(
                                                    candidate.userAvatarUrl!)
                                                : null,
                                            child: candidate.userAvatarUrl ==
                                                    null
                                                ? Text(
                                                    (candidate.userFullName ??
                                                            'U')[0]
                                                        .toUpperCase(),
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: context.appBarBg,
                                                    ),
                                                  )
                                                : null,
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
                                          trailing: Radio<int>(value: index),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: l10n.proceedTransferButton,
                    onPressed: _selectedIndex != null
                        ? () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is Authenticated &&
                                authState.user.familyId != null) {
                              final candidate = filtered[_selectedIndex!];
                              _confirmTransfer(
                                authState.user.familyId!,
                                candidate.userId,
                                candidate.userFullName ?? l10n.roleViewer,
                              );
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

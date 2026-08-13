import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  String? _roleFilter;

  bool _isOwner() {
    final authState = context.read<AuthBloc>().state;
    final role = authState is Authenticated
        ? authState.user.role.toUpperCase()
        : '';
    return role == 'OWNER' || role == 'CREATOR';
  }

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

    final confirmed = await AppDialog.confirmWithInput(
      context,
      title: l10n.warningDialogTitle,
      message: l10n.warningDialogConfirmMessage(newOwnerName),
      requiredWord: l10n.confirmWord,
      inputInstruction: l10n.typeConfirmToTransfer,
      confirmLabel: l10n.confirmTransferButton,
      cancelLabel: l10n.formCancel,
      type: AppDialogType.danger,
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
    if (!_isOwner()) {
      return Scaffold(
        backgroundColor: context.background,
        appBar: AppAppBar(title: l10n.transferOwnershipLabel),
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
            var filtered = query.isEmpty
                ? candidates
                : candidates
                    .where((c) =>
                        (c.userFullName ?? '').toLowerCase().contains(query))
                    .toList();

            if (_roleFilter != null) {
              filtered = filtered.where((c) {
                final mappedRole = AdminDashboardPage.roleLabel(c.role, context);
                final filterRole = AdminDashboardPage.roleLabel(_roleFilter!, context);
                return mappedRole == filterRole;
              }).toList();
            }

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
                            child: AppSearchBar(
                              controller: _searchController,
                              hintText: l10n.searchMemberHint,
                              onChanged: (_) => setState(() {}),
                              trailing: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      LucideIcons.listFilter,
                                      size: 20,
                                      color: _roleFilter != null
                                          ? context.primary
                                          : context.textSecondary,
                                    ),
                                    offset: const Offset(0, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: context.surface,
                                    elevation: 4,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'clear_all',
                                        height: 38,
                                        child: Row(
                                          children: [
                                            Icon(LucideIcons.filterX,
                                                color: context.textPrimary,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Bỏ chọn tất cả',
                                              style: GoogleFonts.beVietnamPro(
                                                  fontSize: 13,
                                                  color: context.textPrimary),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _roleFilter = null;
                                          });
                                        },
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem(
                                        enabled: false,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: StatefulBuilder(
                                          builder: (context, setPopupState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Phân quyền',
                                                    style: GoogleFonts.beVietnamPro(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: context.textPrimary)),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: CupertinoSlidingSegmentedControl<
                                                      String>(
                                                    backgroundColor: context.isDarkMode
                                                        ? Colors.grey.shade900
                                                        : Colors.grey.shade200,
                                                    thumbColor: context.isDarkMode
                                                        ? Colors.grey.shade700
                                                        : Colors.white,
                                                    groupValue: _roleFilter == 'OWNER'
                                                        ? 'OWNER'
                                                        : (_roleFilter == 'EDITOR'
                                                            ? 'EDITOR'
                                                            : (_roleFilter == 'VIEWER'
                                                                ? 'VIEWER'
                                                                : null)),
                                                    children: {
                                                      'OWNER': Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 8),
                                                        child: Text(l10n.roleOwner,
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts
                                                                .beVietnamPro(
                                                                    fontSize: 12,
                                                                    color: context
                                                                        .textPrimary)),
                                                      ),
                                                      'EDITOR': Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 8),
                                                        child: Text(l10n.roleEditor,
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts
                                                                .beVietnamPro(
                                                                    fontSize: 12,
                                                                    color: context
                                                                        .textPrimary)),
                                                      ),
                                                      'VIEWER': Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 8),
                                                        child: Text(l10n.roleViewer,
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts
                                                                .beVietnamPro(
                                                                    fontSize: 12,
                                                                    color: context
                                                                        .textPrimary)),
                                                      ),
                                                    },
                                                    onValueChanged: (value) {
                                                      if (value != null) {
                                                        setPopupState(() {
                                                          _roleFilter = value;
                                                        });
                                                        setState(() {
                                                          _roleFilter = value;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                                    itemCount: filtered.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final candidate = filtered[index];
                                      final isSelected =
                                          _selectedUserId == candidate.userId;
                                      final role = candidate.role;

                                      return Container(
                                        decoration: const BoxDecoration(),
                                        child: ListTile(
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
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                candidate.userEmail ?? l10n.noEmail,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: context.textSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AdminDashboardPage.roleColor(role)
                                                          .withValues(alpha: 0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  AdminDashboardPage.roleLabel(
                                                      role, context),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: AdminDashboardPage.roleColor(
                                                        role),
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Icon(
                                            isSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            color: isSelected
                                                ? context.primary
                                                : context.textSecondary,
                                          ),
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

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
import 'package:giatocviet/features/admin/domain/entities/member_account_link_entity.dart';
import 'package:giatocviet/features/admin/presentation/bloc/member_account_links/member_account_links_bloc.dart';
import 'package:giatocviet/features/admin/presentation/widgets/link_account_email_sheet.dart';

/// Màn hình "Quản lý Tài khoản & Liên kết".
class AdminLinkAccountsPage extends StatefulWidget {
  final int? memberId;
  final String? memberName;

  const AdminLinkAccountsPage({super.key, this.memberId, this.memberName});

  @override
  State<AdminLinkAccountsPage> createState() => _AdminLinkAccountsPageState();
}

enum LinkStatusFilter { all, linked, unlinked }

class _AdminLinkAccountsPageState extends State<AdminLinkAccountsPage> {
  final _searchController = TextEditingController();
  LinkStatusFilter _statusFilter = LinkStatusFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        context.read<MemberAccountLinksBloc>().add(
              LoadMemberAccountLinksEvent(familyId: authState.user.familyId!),
            );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.familyId != null) {
      context.read<MemberAccountLinksBloc>().add(
            LoadMemberAccountLinksEvent(familyId: authState.user.familyId!),
          );
    }
  }

  Future<void> _onLinkPressed(
    MemberAccountLinkEntity item,
    int familyId,
    AppLocalizations l10n,
  ) async {
    final email = await showLinkAccountEmailSheet(
      context,
      memberName: item.fullName,
    );
    if (email == null || !mounted) return;
    context.read<MemberAccountLinksBloc>().add(LinkMemberEmailEvent(
          familyId: familyId,
          memberId: item.memberId,
          email: email,
        ));
  }

  Future<void> _onUnlinkPressed(
    MemberAccountLinkEntity item,
    int familyId,
    AppLocalizations l10n,
  ) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.confirmUnlinkTitle,
      message: l10n.confirmUnlinkMessage(item.fullName),
      confirmLabel: l10n.unlinkButton,
      type: AppDialogType.danger,
      confirmColor: AppColors.error,
    );
    if (confirmed == true && mounted) {
      context.read<MemberAccountLinksBloc>().add(UnlinkMemberAccountEvent(
            familyId: familyId,
            memberId: item.memberId,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: widget.memberId != null
            ? l10n.linkAccountsNodeTitle
            : l10n.linkAccountsTitle,
      ),
      body: AppBackgroundBody(
        child: SafeArea(
          child: BlocConsumer<MemberAccountLinksBloc, MemberAccountLinksState>(
            listener: (context, state) {
              if (state is MemberAccountLinkedSuccess) {
                AppSnackBar.success(
                  context,
                  state.invited
                      ? l10n.inviteSentSuccess(state.email)
                      : l10n.linkSuccess(state.email),
                );
                _reload();
              } else if (state is MemberAccountUnlinkedSuccess) {
                AppSnackBar.success(context, l10n.unlinkSuccess);
                _reload();
              } else if (state is MemberAccountLinksFailure) {
                AppSnackBar.error(context, state.message);
                _reload();
              }
            },
            builder: (context, state) {
              if (state is MemberAccountLinksLoading ||
                  state is MemberAccountLinksInitial) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: ListPageSkeleton(itemCount: 8),
                );
              }

              if (state is MemberAccountLinksFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      state.message,
                      style: GoogleFonts.beVietnamPro(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final items = state is MemberAccountLinksLoaded
                  ? state.items
                  : const <MemberAccountLinkEntity>[];

              var visibleItems = items;
              if (widget.memberId != null) {
                visibleItems =
                    items.where((e) => e.memberId == widget.memberId).toList();
              }

              if (_statusFilter == LinkStatusFilter.linked) {
                visibleItems = visibleItems.where((e) => e.isLinked).toList();
              } else if (_statusFilter == LinkStatusFilter.unlinked) {
                visibleItems = visibleItems.where((e) => !e.isLinked).toList();
              }

              final query = _searchController.text.trim().toLowerCase();
              if (query.isNotEmpty) {
                visibleItems = visibleItems
                    .where((e) =>
                        e.fullName.toLowerCase().contains(query) ||
                        (e.linkedAccount?.email ?? '')
                            .toLowerCase()
                            .contains(query) ||
                        (e.pendingInvite?.email ?? '')
                            .toLowerCase()
                            .contains(query))
                    .toList();
              }

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noMembers,
                    style: GoogleFonts.beVietnamPro(
                      color: context.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                          child: PopupMenuButton<LinkStatusFilter>(
                            icon: Icon(
                              LucideIcons.listFilter,
                              size: 20,
                              color: _statusFilter != LinkStatusFilter.all
                                  ? context.primary
                                  : context.textSecondary,
                            ),
                            offset: const Offset(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: context.surface,
                            elevation: 4,
                            onSelected: (val) {
                              setState(() {
                                _statusFilter = val;
                              });
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: LinkStatusFilter.all,
                                height: 38,
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.filterX,
                                        color: context.textPrimary, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.allLabel,
                                      style: GoogleFonts.beVietnamPro(
                                          fontSize: 13,
                                          color: context.textPrimary),
                                    ),
                                  ],
                                ),
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
                                        Text('Trạng thái',
                                            style: GoogleFonts.beVietnamPro(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: context.textPrimary)),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          child:
                                              CupertinoSlidingSegmentedControl<
                                                  String>(
                                            backgroundColor: context.isDarkMode
                                                ? Colors.grey.shade900
                                                : Colors.grey.shade200,
                                            thumbColor: context.isDarkMode
                                                ? Colors.grey.shade700
                                                : Colors.white,
                                            groupValue: _statusFilter ==
                                                    LinkStatusFilter.all
                                                ? null
                                                : (_statusFilter ==
                                                        LinkStatusFilter.linked
                                                    ? 'linked'
                                                    : 'unlinked'),
                                            children: {
                                              'linked': Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(l10n.linkedLabel,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                            fontSize: 12,
                                                            color: context
                                                                .textPrimary)),
                                              ),
                                              'unlinked': Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(l10n.notLinkedLabel,
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
                                                final filter = value == 'linked'
                                                    ? LinkStatusFilter.linked
                                                    : LinkStatusFilter.unlinked;
                                                setPopupState(() {
                                                  _statusFilter = filter;
                                                });
                                                setState(() {
                                                  _statusFilter = filter;
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
                    child: visibleItems.isEmpty
                        ? Center(
                            child: Text(
                              l10n.noMemberFound,
                              style: GoogleFonts.beVietnamPro(
                                color: context.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: visibleItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) => _buildItem(
                                context, visibleItems[index], familyId, l10n),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, MemberAccountLinkEntity item,
      int? familyId, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                avatarUrl: item.avatarUrl,
                fullName: item.fullName,
                radius: 22,
                backgroundColor: context.primary.withValues(alpha: 0.15),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fullName,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    if (item.generation != null)
                      Text(
                        l10n.generationBadge('${item.generation}'),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              _buildStatusChip(context, item, l10n),
            ],
          ),
          const SizedBox(height: 12),
          _buildAccountInfo(context, item, l10n),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: item.isLinked
                      ? l10n.changeEmailButton
                      : l10n.linkInviteButton,
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.small,
                  prefixIcon: const Icon(LucideIcons.mail, size: 14),
                  onPressed: familyId == null
                      ? null
                      : () => _onLinkPressed(item, familyId, l10n),
                ),
              ),
              if (item.isLinked || item.pendingInvite != null) ...[
                const SizedBox(width: 8),
                AppButton(
                  label: l10n.unlinkButton,
                  variant: AppButtonVariant.danger,
                  size: AppButtonSize.small,
                  prefixIcon: const Icon(LucideIcons.unlink, size: 14),
                  onPressed: familyId == null
                      ? null
                      : () => _onUnlinkPressed(item, familyId, l10n),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, MemberAccountLinkEntity item,
      AppLocalizations l10n) {
    if (item.isLinked) {
      return _chip(context, l10n.linkedLabel, Colors.green);
    }
    if (item.pendingInvite != null) {
      return _chip(context, l10n.invitePendingLabel, AppColors.accent);
    }
    return _chip(context, l10n.notLinkedLabel, context.textSecondary);
  }

  Widget _chip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context, MemberAccountLinkEntity item,
      AppLocalizations l10n) {
    if (item.isLinked) {
      final account = item.linkedAccount!;
      final hasName = account.fullName.isNotEmpty;
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.userCheck,
              size: 14,
              color: context.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (hasName) ...[
                    TextSpan(
                      text: account.fullName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: ' • ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                  TextSpan(
                    text: account.email,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    if (item.pendingInvite != null) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.mailWarning,
              size: 14,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.invitePendingDesc(item.pendingInvite!.email),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: context.textSecondary,
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

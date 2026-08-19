import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/resources/app_localizations.dart';
import 'package:giatocviet/features/auth/auth.dart';
import 'package:giatocviet/features/family_tree/domain/entities/audit_log_entity.dart';
import 'package:giatocviet/features/family_tree/presentation/bloc/family_tree_bloc.dart';
import 'package:giatocviet/features/family_tree/presentation/pages/family_member_detail_page.dart';
import 'package:giatocviet/features/admin/presentation/bloc/audit_logs/audit_logs_bloc.dart';

/// Màn hình "Nhật ký biên soạn": lịch sử thêm/sửa/xóa trong gia tộc.
class AuditLogsPage extends StatefulWidget {
  const AuditLogsPage({super.key});

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  int? _familyId;
  String _selectedFilter = 'all'; // all, create, update, delete, restore
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        _familyId = authState.user.familyId;
        context
            .read<AuditLogsBloc>()
            .add(LoadAuditLogsEvent(familyId: _familyId));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    if (_familyId != null) {
      context
          .read<AuditLogsBloc>()
          .add(LoadAuditLogsEvent(familyId: _familyId));
    }
  }

  List<AuditLogEntity> _filterLogs(
      List<AuditLogEntity> logs, AppLocalizations l10n) {
    var result = logs;

    if (_selectedFilter != 'all') {
      result = result.where((log) {
        switch (_selectedFilter) {
          case 'create':
            return log.action.contains('create') ||
                log.action.contains('restore');
          case 'update':
            return log.action.contains('update') ||
                log.action.contains('role') ||
                log.action.contains('link') ||
                log.action.contains('transfer_ownership') ||
                log.action.startsWith('family.');
          case 'delete':
            return log.action.contains('delete') ||
                log.action.contains('purge');
          default:
            return true;
        }
      }).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((log) {
        final actor = (log.actorName ?? log.actorEmail ?? '').toLowerCase();
        final targetName = (log.detail?['name'] as String? ??
                log.detail?['title'] as String? ??
                log.targetId ??
                '')
            .toLowerCase();
        final actionText = _AuditLogItem.getActionText(log, l10n).toLowerCase();
        return actor.contains(query) ||
            targetName.contains(query) ||
            actionText.contains(query);
      }).toList();
    }

    return result;
  }

  void _showDetailBottomSheet(BuildContext context, AuditLogEntity log) {
    final l10n = AppLocalizations.of(context)!;
    final actor = (log.actorName?.isNotEmpty ?? false)
        ? log.actorName!
        : (log.actorEmail ?? l10n.auditUnknownActor);
    final targetName = log.detail?['name'] as String? ?? log.targetId ?? '';
    final changes = log.detail?['changes'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ctx.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      _AuditLogItem.getActionIcon(log.action),
                      color: _AuditLogItem.getActionColor(ctx, log.action),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.auditLogsTitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ctx.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Thông tin chi tiết
                _buildDetailRow(ctx, l10n.auditActorLabel, actor),
                _buildDetailRow(ctx, l10n.roleColonLabel, l10n.clanLeaderAdminLabel),
                if (log.actorEmail != null && log.actorEmail!.isNotEmpty)
                  _buildDetailRow(ctx, l10n.auditEmailLabel, log.actorEmail!),
                _buildDetailRow(ctx, l10n.auditActionLabel,
                    _AuditLogItem.getActionText(log, l10n)),
                if (targetName.isNotEmpty && int.tryParse(targetName) == null)
                  _buildDetailRow(ctx, l10n.auditTargetLabel, targetName),
                if (log.createdAt != null)
                  _buildDetailRow(ctx, l10n.auditTimeLabel,
                      log.createdAt!.replaceAll('T', ' ').split('.').first),

                if (changes is Map && changes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.auditChangedFieldsTitle,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ctx.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ctx.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ctx.textSecondary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: changes.entries.map((e) {
                        final keyStr = e.key.toString();
                        final fieldTranslations = {
                          'fullName': l10n.fullNameLabel,
                          'gender': l10n.genderLabel,
                          'birthDate': l10n.dateOfBirthLabel,
                          'deathDate': l10n.dateOfDeathLabel,
                          'generation': l10n.generationFieldLabel,
                          'branchId': l10n.branchLabel,
                          'fatherId': l10n.fatherLabel,
                          'motherId': l10n.motherLabel,
                          'spouseId': l10n.spouseLabel,
                          'role': l10n.roleFieldLabel,
                          'email': 'Email',
                          'title': l10n.titleFieldLabel,
                          'date': l10n.dateFieldLabel,
                          'location': l10n.locationFieldLabel,
                          'content': l10n.contentFieldLabel,
                          'newOwnerUserId': l10n.newOwnerFieldLabel,
                        };
                        final friendlyKey = fieldTranslations[keyStr] ?? keyStr;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '• $friendlyKey: ${e.value}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: ctx.textSecondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Nút xem chi tiết thành viên (nếu có id thành viên)
                Builder(builder: (builderCtx) {
                  final targetIdInt = int.tryParse(log.targetId ?? '') ??
                      (log.detail?['id'] as int?);
                  if (targetIdInt != null) {
                    return SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: l10n.viewMemberPage,
                        variant: AppButtonVariant.primary,
                        prefixIcon: const Icon(LucideIcons.user, size: 16),
                        onPressed: () {
                          Navigator.pop(ctx);
                          final treeState =
                              context.read<FamilyTreeBloc>().state;
                          if (treeState is FamilyTreeLoaded) {
                            final targetMember = treeState.members
                                .where((m) => m.id == targetIdInt)
                                .firstOrNull;
                            if (targetMember != null) {
                              Navigator.push(
                                context,
                                SereneFadeSlidePageRoute(
                                  page: FamilyMemberDetailPage(
                                    member: targetMember,
                                    allMembers: treeState.members,
                                  ),
                                ),
                              );
                            } else {
                              AppSnackBar.info(
                                context,
                                l10n.memberNoLongerExists,
                              );
                            }
                          }
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: context.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    final role =
        authState is Authenticated ? authState.user.role.toUpperCase() : '';
    final isOwner = role == 'OWNER' || role == 'CREATOR';
    if (!isOwner) {
      return Scaffold(
        backgroundColor: context.background,
        appBar: AppAppBar(title: l10n.auditLogsTitle),
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
      appBar: AppAppBar(
        title: l10n.auditLogsTitle,
      ),
      body: AppBackgroundBody(
        child: SafeArea(
          child: Column(
            children: [
              // ── Search & Filter Bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: AppSearchBar(
                  controller: _searchController,
                  hintText: l10n.auditSearchHint,
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
                          color: _selectedFilter != 'all'
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
                            _selectedFilter = val;
                          });
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'all',
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
                                    color: _selectedFilter == 'all'
                                        ? context.primary
                                        : context.textPrimary,
                                    fontWeight: _selectedFilter == 'all'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          _buildPopupMenuItem(
                            key: 'create',
                            label: l10n.addNewLabel,
                            icon: LucideIcons.userPlus,
                            iconColor: Colors.green,
                          ),
                          _buildPopupMenuItem(
                            key: 'update',
                            label: l10n.editLabel,
                            icon: LucideIcons.pencil,
                            iconColor: context.accent,
                          ),
                          _buildPopupMenuItem(
                            key: 'delete',
                            label: l10n.deletedLabel,
                            icon: LucideIcons.trash2,
                            iconColor: AppColors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer<AuditLogsBloc, AuditLogsState>(
                  listener: (context, state) {
                    if (state is AuditLogsFailure) {
                      AppSnackBar.error(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuditLogsLoading ||
                        state is AuditLogsInitial) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: ListPageSkeleton(itemCount: 8),
                      );
                    }
                    if (state is AuditLogsFailure) {
                      return AppErrorState(
                        message: state.message,
                        onRetry: _reload,
                      );
                    }
                    final logs = state is AuditLogsLoaded
                        ? state.logs
                        : const <AuditLogEntity>[];
                    final filteredLogs = _filterLogs(logs, l10n);
                    if (filteredLogs.isEmpty) {
                      return AppEmptyState(
                        icon: LucideIcons.clipboardList,
                        message: l10n.auditLogsEmpty,
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _reload(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                        itemCount: filteredLogs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final log = filteredLogs[index];
                          return _AuditLogItem(
                            log: log,
                            onTap: () => _showDetailBottomSheet(context, log),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String key,
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedFilter == key;
    return PopupMenuItem(
      value: key,
      height: 38,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: isSelected ? context.primary : context.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditLogItem extends StatelessWidget {
  final AuditLogEntity log;
  final VoidCallback onTap;

  const _AuditLogItem({
    required this.log,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = getActionColor(context, log.action);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              getActionIcon(log.action),
              size: 22,
              color: color,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getActionText(log, l10n),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  if (_detailText(l10n).isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      _detailText(l10n),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (log.createdAt != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          size: 11,
                          color: context.textSecondary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _formatDate(log.createdAt!),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color:
                                  context.textSecondary.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  static String getActionText(AuditLogEntity log, AppLocalizations l10n) {
    final actor = (log.actorName?.isNotEmpty ?? false)
        ? log.actorName!
        : (log.actorEmail ?? l10n.auditUnknownActor);

    final rawAction = log.action.toLowerCase();

    // 1. Member actions
    if (rawAction == 'member.create' || rawAction == 'member_create') {
      return l10n.auditActionMemberCreate(actor);
    }
    if (rawAction == 'member.update' || rawAction == 'member_update') {
      return l10n.auditActionMemberUpdate(actor);
    }
    if (rawAction == 'member.soft_delete' || rawAction == 'member.delete') {
      return l10n.auditActionMemberSoftDelete(actor);
    }
    if (rawAction == 'member.restore') {
      return l10n.auditActionMemberRestore(actor);
    }
    if (rawAction == 'member.purge_trash' || rawAction == 'member.purge') {
      return l10n.auditActionMemberPurge(actor);
    }

    // 2. Family Invite & Account Link
    if (rawAction.contains('send_invite') || rawAction.contains('invite')) {
      return l10n.auditActionInvite(actor);
    }
    if (rawAction.contains('role_change') ||
        rawAction.contains('update_role') ||
        rawAction.contains('role.update')) {
      return l10n.auditActionRoleChange(actor);
    }
    if (rawAction.contains('link_account') || rawAction == 'account.link') {
      return l10n.auditActionLinkAccount(actor);
    }
    if (rawAction.contains('unlink_account') || rawAction == 'account.unlink') {
      return l10n.auditActionUnlinkAccount(actor);
    }

    // 3. Family & Ownership
    if (rawAction.contains('transfer_ownership')) {
      return l10n.auditActionTransferOwnership(actor);
    }
    if (rawAction == 'family.create') {
      return l10n.auditActionFamilyCreate(actor);
    }
    if (rawAction == 'family.update') {
      return l10n.auditActionFamilyUpdate(actor);
    }
    if (rawAction == 'family.dissolve') {
      return l10n.auditActionFamilyDissolve(actor);
    }

    // 4. Branch
    if (rawAction.startsWith('branch.create')) {
      return l10n.auditActionBranchCreate(actor);
    }
    if (rawAction.startsWith('branch.update')) {
      return l10n.auditActionBranchUpdate(actor);
    }
    if (rawAction.startsWith('branch.delete')) {
      return l10n.auditActionBranchDelete(actor);
    }

    // 5. Events
    if (rawAction.startsWith('event.create')) {
      return l10n.auditActionEventCreate(actor);
    }
    if (rawAction.startsWith('event.update')) {
      return l10n.auditActionEventUpdate(actor);
    }
    if (rawAction.startsWith('event.delete')) {
      return l10n.auditActionEventDelete(actor);
    }

    // Fallback: chuyển đổi action dạng snake/dot sang tiếng Việt dễ hiểu
    final friendlyAction = rawAction
        .replaceAll('family.', '')
        .replaceAll('member.', '')
        .replaceAll('event.', '')
        .replaceAll('branch.', '')
        .replaceAll('_', ' ')
        .replaceAll('.', ' ')
        .trim();

    return l10n.auditActionGeneric(actor, friendlyAction);
  }

  String _detailText(AppLocalizations l10n) {
    final name = log.detail?['name'] as String? ??
        log.detail?['title'] as String? ??
        log.detail?['fullName'] as String?;
    final changes = log.detail?['changes'];

    // Map tên các trường kỹ thuật sang tiếng Việt thân thiện
    final fieldTranslations = {
      'fullName': l10n.fullNameLabel,
      'gender': l10n.genderLabel,
      'birthDate': l10n.dateOfBirthLabel,
      'deathDate': l10n.dateOfDeathLabel,
      'generation': l10n.generationFieldLabel,
      'branchId': l10n.branchLabel,
      'fatherId': l10n.fatherLabel,
      'motherId': l10n.motherLabel,
      'spouseId': l10n.spouseLabel,
      'role': l10n.roleFieldLabel,
      'email': 'Email',
      'title': l10n.titleFieldLabel,
      'date': l10n.dateFieldLabel,
      'location': l10n.locationFieldLabel,
      'content': l10n.contentFieldLabel,
      'newOwnerUserId': l10n.newOwnerFieldLabel,
    };

    if (changes is Map && changes.isNotEmpty) {
      final translatedKeys = changes.keys.map((k) {
        final keyStr = k.toString();
        return fieldTranslations[keyStr] ?? keyStr;
      }).toList();

      if (name != null && name.isNotEmpty) {
        return l10n.auditDetailEdit(name, translatedKeys.join(', '));
      }
      return l10n.auditDetailChanges(translatedKeys.join(', '));
    }

    // Nếu không có changes mà có targetName
    if (name != null && name.isNotEmpty) {
      // Tránh trùng lặp nếu name trùng với actor
      final actor = log.actorName ?? log.actorEmail ?? '';
      if (name != actor) {
        return l10n.auditDetailTarget(name);
      }
    }

    return '';
  }

  String _formatDate(String value) {
    return value.replaceAll('T', ' ').split('.').first;
  }

  static IconData getActionIcon(String action) {
    if (action.contains('delete') || action.contains('purge')) {
      return LucideIcons.trash2;
    }
    if (action.contains('transfer_ownership')) {
      return LucideIcons.crown;
    }
    if (action.startsWith('member.create') ||
        action.startsWith('branch.create')) {
      return LucideIcons.userPlus;
    }
    if (action.startsWith('event.create')) {
      return LucideIcons.calendarPlus;
    }
    if (action.contains('update') ||
        action.contains('role') ||
        action.contains('link')) {
      return LucideIcons.pencil;
    }
    if (action.contains('restore')) {
      return LucideIcons.rotateCcw;
    }
    return LucideIcons.history;
  }

  static Color getActionColor(BuildContext context, String action) {
    if (action.contains('transfer_ownership')) {
      return context.primary;
    }
    if (action.contains('create') || action.contains('link')) {
      return Colors.green;
    }
    if (action.contains('update') || action.contains('role')) {
      return context.accent;
    }
    if (action.contains('delete') ||
        action.contains('purge') ||
        action.contains('dissolve')) {
      return AppColors.error;
    }
    if (action.contains('restore')) {
      return context.primary;
    }
    return context.textSecondary;
  }
}

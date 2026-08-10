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

  void _reload() {
    if (_familyId != null) {
      context
          .read<AuditLogsBloc>()
          .add(LoadAuditLogsEvent(familyId: _familyId));
    }
  }

  List<AuditLogEntity> _filterLogs(List<AuditLogEntity> logs) {
    if (_selectedFilter == 'all') return logs;
    return logs.where((log) {
      if (_selectedFilter == 'create') return log.action == 'member.create';
      if (_selectedFilter == 'update') return log.action == 'member.update';
      if (_selectedFilter == 'delete') {
        return log.action == 'member.soft_delete' ||
            log.action == 'member.purge_trash';
      }
      if (_selectedFilter == 'restore') return log.action == 'member.restore';
      return true;
    }).toList();
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
                if (log.actorEmail != null && log.actorEmail!.isNotEmpty)
                  _buildDetailRow(ctx, l10n.auditEmailLabel, log.actorEmail!),
                _buildDetailRow(ctx, l10n.auditActionLabel, _AuditLogItem.getActionText(log, l10n)),
                if (targetName.isNotEmpty)
                  _buildDetailRow(ctx, l10n.auditTargetLabel, targetName),
                if (log.createdAt != null)
                  _buildDetailRow(ctx, l10n.auditTimeLabel, log.createdAt!.replaceAll('T', ' ').split('.').first),

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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '• ${e.key}: ${e.value}',
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
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.auditLogsTitle,
      ),
      body: AppBackgroundBody(
        child: SafeArea(
          child: Column(
            children: [
              // ── Filter Chips ──
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('all', l10n.allLabel),
                    const SizedBox(width: 8),
                    _buildFilterChip('create', l10n.filterCreate),
                    const SizedBox(width: 8),
                    _buildFilterChip('update', l10n.filterUpdate),
                    const SizedBox(width: 8),
                    _buildFilterChip('delete', l10n.deleteLabel),
                    const SizedBox(width: 8),
                    _buildFilterChip('restore', l10n.restoreLabel),
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
                    final filteredLogs = _filterLogs(logs);
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

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : context.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedColor: context.primary,
      backgroundColor: context.surface,
      elevation: isSelected ? 2 : 0,
      pressElevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? context.primary
              : context.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = key);
        }
      },
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.textSecondary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Icon căn giữa dòng
          children: [
            // Icon trực tiếp, KHÔNG dùng background circle
            Icon(
              getActionIcon(log.action),
              size: 20,
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
                      fontSize: 13,
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
    switch (log.action) {
      case 'member.create':
        return l10n.auditActionCreate(actor);
      case 'member.update':
        return l10n.auditActionUpdate(actor);
      case 'member.soft_delete':
        return l10n.auditActionDelete(actor);
      case 'member.restore':
        return l10n.auditActionRestore(actor);
      case 'member.purge_trash':
        return l10n.auditActionPurge(actor);
      default:
        return l10n.auditActionGeneric(actor, log.action);
    }
  }

  String _detailText(AppLocalizations l10n) {
    final name = log.detail?['name'] as String?;
    final changes = log.detail?['changes'];
    if (name != null && changes is Map && changes.isNotEmpty) {
      return l10n.auditChangedFields(name, changes.keys.join(', '));
    }
    return name ?? '';
  }

  String _formatDate(String value) {
    return value.replaceAll('T', ' ').split('.').first;
  }

  static IconData getActionIcon(String action) {
    switch (action) {
      case 'member.create':
        return LucideIcons.userPlus;
      case 'member.update':
        return LucideIcons.pencil;
      case 'member.soft_delete':
        return LucideIcons.trash2;
      case 'member.restore':
        return LucideIcons.rotateCcw;
      case 'member.purge_trash':
        return LucideIcons.archiveRestore;
      default:
        return LucideIcons.history;
    }
  }

  static Color getActionColor(BuildContext context, String action) {
    switch (action) {
      case 'member.create':
        return Colors.green;
      case 'member.update':
        return context.accent;
      case 'member.soft_delete':
      case 'member.purge_trash':
        return AppColors.error;
      case 'member.restore':
        return context.primary;
      default:
        return context.textSecondary;
    }
  }
}
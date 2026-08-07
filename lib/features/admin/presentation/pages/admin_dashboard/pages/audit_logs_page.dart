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
import 'package:giatocviet/features/admin/presentation/bloc/audit_logs/audit_logs_bloc.dart';

/// Màn hình "Nhật ký biên soạn": lịch sử thêm/sửa/xóa trong gia tộc.
class AuditLogsPage extends StatefulWidget {
  const AuditLogsPage({super.key});

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  int? _familyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        _familyId = authState.user.familyId;
        context.read<AuditLogsBloc>().add(LoadAuditLogsEvent(familyId: _familyId));
      }
    });
  }

  void _reload() {
    if (_familyId != null) {
      context.read<AuditLogsBloc>().add(LoadAuditLogsEvent(familyId: _familyId));
    }
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
              if (logs.isEmpty) {
                return AppEmptyState(
                  icon: LucideIcons.clipboardList,
                  message: l10n.auditLogsEmpty,
                );
              }
              return RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _AuditLogItem(log: logs[index]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AuditLogItem extends StatelessWidget {
  final AuditLogEntity log;

  const _AuditLogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _actionColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(
              _actionIcon(),
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _actionText(l10n),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                if (_detailText(l10n).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _detailText(l10n),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
                if (log.createdAt != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 12,
                        color: context.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _formatDate(log.createdAt!),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: context.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _actionText(AppLocalizations l10n) {
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

  IconData _actionIcon() {
    switch (log.action) {
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

  Color _actionColor(BuildContext context) {
    switch (log.action) {
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/resources/app_localizations.dart';
import 'package:giatocviet/features/auth/auth.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import 'package:giatocviet/features/admin/presentation/bloc/member_trash/member_trash_bloc.dart';

/// Màn hình "Thùng rác": danh sách thành viên đã xóa (soft delete) để khôi phục.
class MemberTrashPage extends StatefulWidget {
  const MemberTrashPage({super.key});

  @override
  State<MemberTrashPage> createState() => _MemberTrashPageState();
}

class _MemberTrashPageState extends State<MemberTrashPage> {
  int? _familyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        _familyId = authState.user.familyId;
        context
            .read<MemberTrashBloc>()
            .add(LoadMemberTrashEvent(familyId: _familyId));
      }
    });
  }

  void _reload() {
    if (_familyId != null) {
      context.read<MemberTrashBloc>().add(LoadMemberTrashEvent(familyId: _familyId));
    }
  }

  Future<void> _confirmRestore(MemberEntity member) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.trashRestoreTitle,
      message: l10n.trashRestoreMessage(member.fullName),
    );
    if (confirmed == true && mounted) {
      context.read<MemberTrashBloc>().add(RestoreMemberEvent(member.id));
    }
  }

  Future<void> _confirmPurge() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.trashPurgeTitle,
      message: l10n.trashPurgeMessage,
    );
    if (confirmed == true && mounted) {
      context.read<MemberTrashBloc>().add(const PurgeTrashEvent(days: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.trashTitle,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            tooltip: l10n.trashPurgeButton,
            onPressed: _confirmPurge,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AppBackgroundBody(
        child: SafeArea(
          child: BlocConsumer<MemberTrashBloc, MemberTrashState>(
            listener: (context, state) {
              if (state is MemberRestoredState) {
                AppSnackBar.success(
                  context,
                  l10n.trashRestoreSuccess(state.member.fullName),
                );
                _reload();
              } else if (state is TrashPurgedState) {
                AppSnackBar.success(
                  context,
                  l10n.trashPurgeSuccess(state.removed),
                );
                _reload();
              } else if (state is MemberTrashFailure) {
                AppSnackBar.error(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is MemberTrashLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: ListPageSkeleton(itemCount: 8),
                );
              }
              if (state is MemberTrashFailure) {
                return AppErrorState(
                  message: state.message,
                  onRetry: _reload,
                );
              }
              final members =
                  state is MemberTrashLoaded ? state.members : const <MemberEntity>[];
              if (members.isEmpty) {
                return AppEmptyState(
                  icon: LucideIcons.trash,
                  message: l10n.trashEmpty,
                  subMessage: l10n.trashAutoCleanNote,
                );
              }
              return RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  itemCount: members.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return _TrashItem(
                      member: member,
                      onRestore: () => _confirmRestore(member),
                    );
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

class _TrashItem extends StatelessWidget {
  final MemberEntity member;
  final VoidCallback onRestore;

  const _TrashItem({required this.member, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final genderColor = member.gender == Gender.male
        ? context.genderMale
        : member.gender == Gender.female
            ? context.genderFemale
            : Colors.grey;

    return CustomPaint(
      painter: TraditionalOrnamentalBorderPainter(
        borderColor: context.textSecondary.withValues(alpha: 0.2),
        fillColor: context.surface,
        leftAccentColor: genderColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          children: [
            AppAvatar(
              avatarUrl: member.avatarUrl,
              fullName: member.fullName,
              radius: 26,
              fontSize: 18,
              backgroundColor:
                  context.resolve(Colors.grey.shade100, const Color(0xFF2C2C2C)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.user,
                        size: 12,
                        color: genderColor,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.trashDeletedAt(_formatDate(member.deletedAt)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.trashStatusDeleted,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                AppButton(
                  label: l10n.trashRestoreButton,
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.small,
                  prefixIcon: const Icon(LucideIcons.rotateCcw, size: 14),
                  onPressed: onRestore,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '-';
    return value.replaceAll('T', ' ').split('.').first;
  }
}
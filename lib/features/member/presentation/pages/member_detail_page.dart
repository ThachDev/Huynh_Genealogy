import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/features/tree/presentation/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/member/presentation/bloc/member_bloc.dart';
import 'package:app_family_tree/features/member/presentation/widgets/add_member_dialog.dart';
import 'package:app_family_tree/features/member/presentation/widgets/member_detail_skeleton.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/components/dialog/delete_confirm_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:resources/resources.dart';

class MemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const MemberDetailPage({super.key, required this.member});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MemberBloc>(
          create: (context) => di.sl<MemberBloc>(),
        ),
      ],
      child: BlocListener<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberSuccess && state.isDeleted) {
            context.read<TreeBloc>().add(LoadTreeEvent(force: true));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).deleteMemberSuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is MemberError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TreeBloc, TreeState>(
          builder: (context, state) {
            final member =
                state is TreeLoaded
                    ? state.allMembers.firstWhere(
                      (m) => m.id == widget.member.id,
                      orElse: () => widget.member,
                    )
                    : widget.member;

            return Scaffold(
              backgroundColor: AppColors.parchment,
              appBar: CommonAppBar(
                titleText: member.fullName,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.gold,
                    ),
                    onPressed: () {
                      final treeBloc = context.read<TreeBloc>();
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.6),
                        builder:
                            (ctx) => MultiBlocProvider(
                               providers: [
                                 BlocProvider<MemberBloc>(
                                   create: (_) => di.sl<MemberBloc>(),
                                 ),
                                 BlocProvider.value(value: treeBloc),
                               ],
                               child: AddMemberDialog(memberToEdit: member),
                             ),
                      );
                    },
                  ),
                ],
              ),
              body:
                  state is TreeLoading || state is TreeInitial
                      ? const MemberDetailSkeleton()
                      : AnimationConfiguration.synchronized(
                        child: SlideAnimation(
                          verticalOffset: 30.0,
                          child: FadeInAnimation(
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _buildHeader(member),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: _buildMainInfo(member),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _buildDeleteButton(context, member),
                                  ),
                                ),
                                const SliverPadding(
                                  padding: EdgeInsets.only(bottom: 32),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, MemberEntity member) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        return OutlinedButton.icon(
          onPressed: state is MemberLoading
              ? null
              : () async {
                  final confirm = await showDeleteConfirmDialog(
                    context: context,
                    title: S.of(context).confirmDelete,
                    content: S.of(context).confirmDeleteContent(member.fullName),
                  );
                  if (confirm == true && context.mounted) {
                    context.read<MemberBloc>().add(
                      DeleteMemberEvent(member.id),
                    );
                  }
                },
          icon: state is MemberLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.crimson,
                ),
              )
              : const Icon(Icons.delete_outline, color: AppColors.crimson),
          label: Text(
            S.of(context).deleteMemberButton,
            style: GoogleFonts.inter(
              color: AppColors.crimson,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: AppColors.crimson, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(MemberEntity member) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (member.fullAvatarUrl != null) {
                _showImagePreview(context, member.fullAvatarUrl!);
              }
            },
            child: Hero(
              tag: 'member_avatar_${member.id}',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: member.gender == Gender.male
                    ? AppColors.nodeMale
                    : AppColors.nodeFemale,
                backgroundImage: member.fullAvatarUrl != null
                    ? CachedNetworkImageProvider(member.fullAvatarUrl!)
                    : null,
                child: member.fullAvatarUrl == null
                    ? Icon(
                        member.gender == Gender.male ? Icons.man : Icons.woman,
                        size: 60,
                        color: AppColors.crimson.withValues(alpha: 0.5),
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          member.fullName.toUpperCase(),
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Text(
            S.of(context).generationLabelShort(member.generation?.toString() ?? "?"),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfo(MemberEntity member) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.account_tree_outlined,
              S.of(context).branch,
              member.branchName ?? 'Họ Huỳnh',
            ),
            const Divider(height: 32),
            _buildInfoRow(
              Icons.cake_outlined,
              S.of(context).dobLabel,
              member.dateOfBirth ?? S.of(context).maritalUnknown,
            ),
            const Divider(height: 32),
            _buildInfoRow(
              Icons.favorite_border,
              S.of(context).legend,
              member.isAlive ? S.of(context).stillAlive : S.of(context).deceased,
            ),
            if (!member.isAlive && member.dateOfDeath != null) ...[
              const Divider(height: 32),
              _buildInfoRow(
                Icons.event_available,
                S.of(context).dodLabel,
                member.dateOfDeath!,
              ),
            ],
            if (member.notes != null) ...[
              const Divider(height: 32),
              _buildInfoRow(Icons.notes_outlined, S.of(context).notesLabel, member.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.parchment,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.crimson, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(ctx),
            ),
          ),
          body: PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: const PhotoViewHeroAttributes(
              tag: "member_avatar_preview",
            ),
          ),
        ),
      ),
    );
  }
}

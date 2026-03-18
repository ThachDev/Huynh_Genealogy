import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/widgets/add_member_dialog.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/components/search/member_search_overlay.dart';
import 'package:resources/resources.dart';

class MemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const MemberDetailPage({super.key, required this.member});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocBuilder<TreeBloc, TreeState>(
      builder: (context, state) {
        final member = state is TreeLoaded
            ? state.allMembers.firstWhere((m) => m.id == widget.member.id, orElse: () => widget.member)
            : widget.member;

        return Scaffold(
          backgroundColor: AppColors.parchment,
          appBar: CommonAppBar(
            titleText: member.fullName,
            isSearching: _isSearching,
            searchController: _searchController,
            searchHint: l10n.searchHint,
            onSearchChanged: (val) => setState(() => _searchQuery = val),
            onSearchToggle: () => setState(() => _isSearching = true),
            onSearchClear: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _isSearching = false;
              });
            },
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: AppColors.gold),
                onPressed: () {
                  final treeBloc = context.read<TreeBloc>();
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.6),
                    builder: (ctx) => MultiBlocProvider(
                      providers: [
                        BlocProvider<MemberFormBloc>(create: (_) => di.sl<MemberFormBloc>()),
                        BlocProvider.value(value: treeBloc),
                      ],
                      child: AddMemberDialog(memberToEdit: member),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildHeader(member),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildMainInfo(member),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                ],
              ),
              MemberSearchOverlay(
                searchQuery: _searchQuery,
                allMembers: state is TreeLoaded ? state.allMembers : [],
                onMemberTap: (m) {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _isSearching = false;
                  });
                  context.pushReplacement('/members/${m.id}', extra: m);
                },
                onClose: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _isSearching = false;
                  });
                },
              ),
            ],
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
          child: Hero(
            tag: 'member_avatar_${member.id}',
            child: CircleAvatar(
              radius: 60,
              backgroundColor: member.gender == Gender.male ? AppColors.nodeMale : AppColors.nodeFemale,
              backgroundImage: member.fullAvatarUrl != null ? NetworkImage(member.fullAvatarUrl!) : null,
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
            'Đời thứ ${member.generation ?? "?"}',
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
            _buildInfoRow(Icons.account_tree_outlined, 'Chi tộc', member.branchName ?? 'Họ Huỳnh'),
            const Divider(height: 32),
            _buildInfoRow(Icons.cake_outlined, 'Ngày sinh', member.dateOfBirth ?? 'Chưa rõ'),
            const Divider(height: 32),
            _buildInfoRow(Icons.favorite_border, 'Trạng thái', member.isAlive ? 'Còn sống' : 'Đã mất'),
            if (!member.isAlive && member.dateOfDeath != null) ...[
              const Divider(height: 32),
              _buildInfoRow(Icons.event_available, 'Ngày mất', member.dateOfDeath!),
            ],
            if (member.notes != null) ...[
              const Divider(height: 32),
              _buildInfoRow(Icons.notes_outlined, 'Ghi chú', member.notes!),
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
}

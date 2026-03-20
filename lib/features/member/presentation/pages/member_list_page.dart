import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/tree/presentation/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:go_router/go_router.dart';
import 'package:app_family_tree/features/member/presentation/bloc/member_bloc.dart';
import 'package:app_family_tree/features/member/presentation/widgets/add_member_dialog.dart';
import 'package:app_family_tree/features/member/presentation/widgets/member_list_skeleton.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:resources/resources.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedGender;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(
        titleText: S.of(context).memberListTitle,
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val),
        onSearchToggle: () => setState(() => _isSearching = true),
        onSearchClear: () {
          _searchController.clear();
          setState(() {
            _searchQuery = '';
            _isSearching = false;
          });
        },
        onFilterToggle: _showFilterMenu,
        isFilterActive: _selectedGender != null,
        actions: const [],
      ),
      body: BlocBuilder<TreeBloc, TreeState>(
        builder: (context, state) {
          if (state is TreeLoading || state is TreeInitial) {
            return const MemberListSkeleton();
          }

          if (state is TreeError) return Center(child: Text(state.message));

          if (state is TreeLoaded) {
            final filteredMembers =
                state.allMembers.where((m) {
                  final matchesSearch = m.fullName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  final matchesGender =
                      _selectedGender == null ||
                      (_selectedGender == S.of(context).male && m.gender == Gender.male) ||
                      (_selectedGender == S.of(context).female && m.gender == Gender.female);
                  return matchesSearch && matchesGender;
                }).toList()..sort((a, b) {
                  final genComp = (a.generation ?? 0).compareTo(
                    b.generation ?? 0,
                  );
                  if (genComp != 0) return genComp;
                  return a.fullName.compareTo(b.fullName);
                });

            if (filteredMembers.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).noMemberData,
                  style: GoogleFonts.inter(color: AppColors.textSecondary),
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildMemberTile(context, member),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          final treeBloc = context.read<TreeBloc>();
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.6),
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider<MemberBloc>(
                  create: (_) => di.sl<MemberBloc>(),
                ),
                BlocProvider.value(value: treeBloc),
              ],
              child: const AddMemberDialog(),
            ),
          );
        },
        backgroundColor: AppColors.crimson,
        elevation: 4,
        child: const Icon(
          Icons.person_add_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).selectGenderTitle,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.crimson,
              ),
            ),
            const Divider(),
            _buildFilterOption(null, Icons.all_inclusive, S.of(context).all),
            _buildFilterOption(S.of(context).male, Icons.male_rounded, S.of(context).male),
            _buildFilterOption(S.of(context).female, Icons.female_rounded, S.of(context).female),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String? value, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColors.crimson),
      title: Text(
        label,
        style: GoogleFonts.inter(
        ),
      ),
      trailing: _selectedGender == value
          ? const Icon(Icons.check, color: AppColors.crimson)
          : null,
      onTap: () {
        setState(() => _selectedGender = value);
        Navigator.pop(context);
      },
    );
  }


  Widget _buildMemberTile(BuildContext context, MemberEntity m) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(right: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.5),
          ),
          child: CircleAvatar(
            backgroundColor: m.gender == Gender.male
                ? AppColors.nodeMale
                : AppColors.nodeFemale,
            radius: 20,
            backgroundImage: m.fullAvatarUrl != null
                ? CachedNetworkImageProvider(m.fullAvatarUrl!)
                : null,
            child: m.fullAvatarUrl == null
                ? Icon(
                    m.gender == Gender.male ? Icons.man : Icons.woman,
                    color: AppColors.crimson,
                    size: 20,
                  )
                : null,
          ),
        ),
        title: Text(
          m.fullName,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          '${S.of(context).generation} ${m.generation ?? "?"} • ${m.branchName ?? "Họ Huỳnh"} • ${m.isAlive ? S.of(context).stillAlive : S.of(context).deceased}',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
        onTap: () => context.push('/members/${m.id}', extra: m),
      ),
    );
  }
}

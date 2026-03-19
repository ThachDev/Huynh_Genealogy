import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/widgets/branch_card.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/widgets/branch_list_skeleton.dart';
import 'package:go_router/go_router.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/bloc/branch_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/widgets/add_branch_dialog.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:resources/resources.dart';

class BranchListPage extends StatefulWidget {
  const BranchListPage({super.key});

  @override
  State<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
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
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(
        titleText: S.of(context).branchListTitle,
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
      ),
      body: BlocBuilder<TreeBloc, TreeState>(
        builder: (context, state) {
          if (state is TreeLoading || state is TreeInitial) {
            return const BranchListSkeleton();
          }
          if (state is TreeError) return Center(child: Text(state.message));

          if (state is TreeLoaded) {
            final filteredBranches = state.branches.where((b) {
              return b.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  (b.founderName?.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ) ??
                      false);
            }).toList()..sort((a, b) => a.name.compareTo(b.name));

            if (filteredBranches.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: AppColors.gold.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchQuery.isEmpty
                          ? S.of(context).noBranchData
                          : S.of(context).branchNotFound,
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: filteredBranches.length,
                itemBuilder: (context, index) {
                  final branch = filteredBranches[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BranchCard(
                            branch: branch,
                            isSelected: false,
                            onTap: () => context.push(
                              '/branches/${branch.id}',
                              extra: branch,
                            ),
                          ),
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
          final treeBloc = context.read<TreeBloc>();
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.6),
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider<BranchFormBloc>(
                  create: (_) => di.sl<BranchFormBloc>(),
                ),
                BlocProvider.value(value: treeBloc),
              ],
              child: const AddBranchDialog(),
            ),
          );
        },
        backgroundColor: AppColors.crimson,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

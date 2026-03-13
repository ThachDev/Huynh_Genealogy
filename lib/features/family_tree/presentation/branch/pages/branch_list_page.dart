import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/widgets/branch_card.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/widgets/dashboard_skeleton.dart';
import 'package:go_router/go_router.dart';

class BranchListPage extends StatelessWidget {
  const BranchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(
          'DANH SÁCH CHI TỘC',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.gold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.wood,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/wood_dragon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.wood),
              ),
              Container(color: Colors.black.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
      body: BlocBuilder<TreeBloc, TreeState>(
        builder: (context, state) {
          if (state is TreeLoading || state is TreeInitial) {
            return const SliverDashboardSkeleton();
          }

          if (state is TreeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.crimson),
                  const SizedBox(height: 16),
                  Text(state.message, style: GoogleFonts.inter()),
                  ElevatedButton(
                    onPressed: () => context.read<TreeBloc>().add(LoadTreeEvent()),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is TreeLoaded) {
            if (state.branches.isEmpty) {
              return Center(
                child: Text(
                  'Chưa có dữ liệu chi tộc',
                  style: GoogleFonts.inter(color: AppColors.textSecondary),
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.branches.length,
                itemBuilder: (context, index) {
                  final branch = state.branches[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BranchCard(
                            branch: branch,
                            isSelected: false,
                            onTap: () {
                              context.push('/branches/${branch.id}', extra: branch);
                            },
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
    );
  }
}

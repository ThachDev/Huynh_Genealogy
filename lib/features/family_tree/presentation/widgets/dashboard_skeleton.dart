import 'package:flutter/material.dart';
import 'package:app_family_tree/resource/app_theme.dart';

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              // Header Skeleton
              SliverToBoxAdapter(
                child: Container(
                  height: 190,
                  decoration: const BoxDecoration(
                    color: AppColors.wood,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),

              // Branches Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
                  child: Row(
                    children: [
                      Container(width: 4, height: 18, color: Colors.grey[300]),
                      const SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      const Spacer(),
                      Container(width: 60, height: 12, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ),

              // Branches Cards
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, __) {
                      return Container(
                        width: 350,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Members Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
                  child: Row(
                    children: [
                      Container(width: 4, height: 18, color: Colors.grey[300]),
                      const SizedBox(width: 10),
                      Container(
                        width: 120,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      const Spacer(),
                      Container(width: 60, height: 12, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ),

              // Members Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 90,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                    );
                  }, childCount: 5),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        );
      },
    );
  }
}

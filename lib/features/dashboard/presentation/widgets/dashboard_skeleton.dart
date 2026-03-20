import 'package:flutter/material.dart';
import 'package:app_family_tree/components/shimmer/sliver_shimmer_loading.dart';

class SliverDashboardSkeleton extends StatelessWidget {
  const SliverDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverShimmerLoading(
      sliver: SliverMainAxisGroup(
        slivers: [
          // Branches Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
              child: Row(
                children: [
                  Container(width: 4, height: 18, color: Colors.grey[300]),
                  const SizedBox(width: 10),
                  Container(width: 100, height: 14, color: Colors.grey[300]),
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
                itemBuilder: (_, _) {
                  return Container(
                    width: 350,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  Container(width: 120, height: 14, color: Colors.grey[300]),
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
        ],
      ),
    );
  }
}

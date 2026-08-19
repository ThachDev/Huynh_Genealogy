import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton cho content panel của User Family Dashboard (branch rail + member list).
class UserFamilyDashboardSkeleton extends StatelessWidget {
  const UserFamilyDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SkeletonBox(height: 46, borderRadius: 14),
          const SizedBox(height: 20),
          const SkeletonLine(width: 100, height: 15),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) => const SkeletonBox(
                width: 180,
                borderRadius: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SkeletonLine(width: 110, height: 15),
          const SizedBox(height: 12),
          for (var i = 0; i < 4; i++) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SkeletonListTile(),
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

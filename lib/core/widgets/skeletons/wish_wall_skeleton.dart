import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton cho Wish Wall page (danh sách wish cards).
class WishWallSkeleton extends StatelessWidget {
  const WishWallSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(16).copyWith(bottom: 100),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonCircle(radius: 18),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 120, height: 13),
                        SizedBox(height: 6),
                        SkeletonLine(width: 80, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SkeletonLine(width: double.infinity, height: 12),
              SizedBox(height: 8),
              SkeletonLine(width: double.infinity, height: 12),
              SizedBox(height: 8),
              SkeletonLine(width: 180, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

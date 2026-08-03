import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton cho Family Tree view khi đang load (mô phỏng các node phân cấp).
class FamilyTreeSkeleton extends StatelessWidget {
  const FamilyTreeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TreeNodeSkeleton(width: 160),
          SizedBox(height: 20),
          SkeletonBox(width: 2, height: 26),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TreeNodeSkeleton(width: 130),
              SizedBox(width: 40),
              _TreeNodeSkeleton(width: 130),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TreeNodeSkeleton(width: 100),
              SizedBox(width: 24),
              _TreeNodeSkeleton(width: 100),
              SizedBox(width: 24),
              _TreeNodeSkeleton(width: 100),
            ],
          ),
        ],
      ),
    );
  }
}

class _TreeNodeSkeleton extends StatelessWidget {
  final double width;

  const _TreeNodeSkeleton({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SkeletonCircle(radius: 16),
          const SizedBox(height: 8),
          SkeletonLine(width: width * 0.7, height: 11),
        ],
      ),
    );
  }
}

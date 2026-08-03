import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton cho User Events page (2 horizontal rails + event card list).
class UserEventsSkeleton extends StatelessWidget {
  const UserEventsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _RailSectionSkeleton(),
          SizedBox(height: 16),
          _RailSectionSkeleton(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SkeletonLine(width: 120, height: 15),
                SizedBox(height: 12),
                _EventListCardSkeleton(),
                SizedBox(height: 12),
                _EventListCardSkeleton(),
                SizedBox(height: 12),
                _EventListCardSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RailSectionSkeleton extends StatelessWidget {
  const _RailSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SkeletonLine(width: 140, height: 15),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 124,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => const SkeletonBox(
              width: 170,
              borderRadius: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _EventListCardSkeleton extends StatelessWidget {
  const _EventListCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: SkeletonBox(height: null)),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 160, height: 14),
                SizedBox(height: 8),
                SkeletonLine(width: 220, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

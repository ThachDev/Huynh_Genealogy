import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton cho trang danh sách sự kiện (admin) khi đang load.
class EventsListSkeleton extends StatelessWidget {
  const EventsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) => const SkeletonBox(
                width: 88,
                height: 36,
                borderRadius: 18,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SkeletonBox(height: 48, borderRadius: 14),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SkeletonLine(width: 120, height: 15),
          ),
          const SizedBox(height: 12),
          const Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _EventCardSkeleton(),
                  SizedBox(height: 12),
                  _EventCardSkeleton(),
                  SizedBox(height: 12),
                  _EventCardSkeleton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card skeleton với banner 16:9 giống EventItemCard.
class _EventCardSkeleton extends StatelessWidget {
  const _EventCardSkeleton();

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
          AspectRatio(aspectRatio: 16 / 9, child: SkeletonBox()),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 180, height: 15),
                SizedBox(height: 10),
                SkeletonLine(width: 240, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

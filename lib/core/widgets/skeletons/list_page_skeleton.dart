import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton dùng chung cho trang danh sách ListTile (search bar + rows).
class ListPageSkeleton extends StatelessWidget {

  const ListPageSkeleton({
    super.key,
    this.showBottomButton = false,
    this.itemCount = 8,
  });
  final bool showBottomButton;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SkeletonBox(height: 46, borderRadius: 14),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SkeletonListTile(avatarRadius: 22),
              ),
            ),
          ),
          if (showBottomButton)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SkeletonBox(height: 52),
            ),
        ],
      ),
    );
  }
}

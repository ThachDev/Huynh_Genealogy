import 'package:flutter/material.dart';
import '../app_shimmer.dart';

/// Skeleton cho trang form (member/branch form) khi đang load dữ liệu ban đầu.
class FormSkeleton extends StatelessWidget {
  const FormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar placeholder
            Center(
              child: Column(
                children: [
                  SkeletonCircle(radius: 44),
                  SizedBox(height: 12),
                  SkeletonLine(width: 120),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Avatar ring / section header
            SkeletonLine(width: 110, height: 14),
            SizedBox(height: 10),
            _FieldSkeleton(),
            SizedBox(height: 14),
            _FieldSkeleton(),
            SizedBox(height: 14),
            _FieldSkeleton(),
            SizedBox(height: 14),
            _FieldSkeleton(),
            SizedBox(height: 24),
            SkeletonLine(width: 130, height: 14),
            SizedBox(height: 10),
            _FieldSkeleton(),
            SizedBox(height: 14),
            _FieldSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _FieldSkeleton extends StatelessWidget {
  const _FieldSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(width: 90, height: 10),
        SizedBox(height: 6),
        SkeletonBox(height: 48, borderRadius: 12),
      ],
    );
  }
}

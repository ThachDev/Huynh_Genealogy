import 'package:flutter/material.dart';
import 'package:app_family_tree/components/shimmer/shimmer_loading.dart';

class MemberListSkeleton extends StatelessWidget {
  const MemberListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
          );
        },
      ),
    );
  }
}

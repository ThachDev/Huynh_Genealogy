import 'package:flutter/material.dart';
import 'package:app_family_tree/components/shimmer/shimmer_loading.dart';

class TreeViewSkeleton extends StatelessWidget {
  const TreeViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Root node
            _buildNode(),
            const SizedBox(height: 60),
            // Child level 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(),
                const SizedBox(width: 80),
                _buildNode(),
              ],
            ),
            const SizedBox(height: 60),
            // Child level 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNode(),
                const SizedBox(width: 40),
                _buildNode(),
                const SizedBox(width: 40),
                _buildNode(),
                const SizedBox(width: 40),
                _buildNode(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNode() {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
    );
  }
}

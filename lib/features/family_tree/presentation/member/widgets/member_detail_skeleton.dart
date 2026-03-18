import 'package:flutter/material.dart';
import 'package:app_family_tree/components/shimmer/shimmer_loading.dart';

class MemberDetailSkeleton extends StatelessWidget {
  const MemberDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 16),
              // Name
              Container(width: 200, height: 24, color: Colors.white),
              const SizedBox(height: 8),
              // Generation label
              Container(width: 100, height: 16, color: Colors.white),
              const SizedBox(height: 32),
              // Main Info Card
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

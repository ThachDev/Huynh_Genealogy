import 'package:flutter/material.dart';

class SliverShimmerLoading extends StatefulWidget {
  final Widget sliver;
  final bool isLoading;

  const SliverShimmerLoading({
    super.key,
    required this.sliver,
    this.isLoading = true,
  });

  @override
  State<SliverShimmerLoading> createState() => _SliverShimmerLoadingState();
}

class _SliverShimmerLoadingState extends State<SliverShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.sliver;

    return SliverOpacity(
      opacity: _animation.value,
      sliver: widget.sliver,
    );
  }
}

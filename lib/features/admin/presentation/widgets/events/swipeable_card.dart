import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final String deleteLabel;

  const SwipeableCard({
    super.key,
    required this.child,
    required this.onDelete,
    required this.onTap,
    required this.deleteLabel,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;
  static const double _maxDragExtent = 85.0; // Độ rộng của phần nút đỏ bên dưới

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller.addListener(() {
      setState(() {
        _dragExtent = _controller.value * -_maxDragExtent;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent =
          (_dragExtent + details.delta.dx).clamp(-_maxDragExtent, 0.0);
      _controller.value = _dragExtent / -_maxDragExtent;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragExtent < -_maxDragExtent / 2) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void close() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Delete Button
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: _maxDragExtent,
              height: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    _controller.reverse();
                    widget.onDelete();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.trash2,
                        color: AppColors.error,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.deleteLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Foreground Card
        GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

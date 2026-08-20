import 'package:flutter/material.dart';

/// Kích thước / giãn cách dùng chung cho layout và vẽ cây gia phả.
class TreeLayoutMetrics {
  TreeLayoutMetrics._();

  static const double nodeWidth = 140.0;
  static const double hSpacing = 40.0;
  static const double vSpacing =
      220.0; // Phải > nodeHeight (160) để nodes không chồng lên nhau
  static const double rootSpacing = 60.0;
  static const double padding = 40.0;
  static const double spouseGap = 16.0;
}

class TreeEdgeData {
  TreeEdgeData({required this.parentId, required this.childId});
  final int parentId;
  final int childId;
}

class TreeSpouseEdge {
  TreeSpouseEdge({
    required this.leftMemberId,
    required this.rightMemberId,
    this.isDivorced = false,
  });
  final int leftMemberId;
  final int rightMemberId;
  final bool isDivorced;
}

/// Nhóm tất cả con của một cặp đôi để vẽ T-bar junction thay vì bezier rời rạc
class TreeCoupleEdge {
  TreeCoupleEdge({
    required this.primaryId,
    this.spouseId,
    required this.childIds,
  });
  final int primaryId;
  final int? spouseId;
  final List<int> childIds;
}

/// Vẽ các đường nối giữa các node trong cây gia phả: T-bar junction cho cặp
/// đôi - con, bezier cho node cô lập, và cặp nhẫn cưới cho vợ chồng.
class TreeEdgePainter extends CustomPainter {
  TreeEdgePainter({
    required this.coupleEdges,
    required this.orphanEdges,
    required this.spouseEdges,
    required this.positions,
    required this.generationLevels,
    required this.linePaint,
    required this.spousePaint,
    required this.nodeHeight,
    required this.primaryColor,
    required this.accentColor,
    required this.surfaceColor,
    required this.textColor,
  });
  final List<TreeCoupleEdge> coupleEdges;
  final List<TreeEdgeData> orphanEdges;
  final List<TreeSpouseEdge> spouseEdges;
  final Map<int, Offset> positions;
  final Map<int, double> generationLevels;
  final Paint linePaint;
  final Paint spousePaint;
  final double nodeHeight;
  final Color primaryColor;
  final Color accentColor;
  final Color surfaceColor;
  final Color textColor;

  static String toRoman(int gen) {
    const map = {
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I'
    };
    var res = '';
    var n = gen;
    for (final e in map.entries) {
      while (n >= e.key) {
        res += e.value;
        n -= e.key;
      }
    }
    return res.isEmpty ? '$gen' : res;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // ── Couple edges — T-bar junction style ──────────────────────────────
    for (final ce in coupleEdges) {
      final primary = positions[ce.primaryId];
      if (primary == null) continue;
      // Điểm xuất phát X = từ chính thành viên gốc, nhưng nếu là nhánh của cụ thể 1 người mẹ (đa thê) thì xuất phát từ người mẹ.
      double sourceX = primary.dx;
      if (ce.spouseId != null) {
        final spouse = positions[ce.spouseId!];
        if (spouse != null) {
          sourceX = spouse.dx;
        }
      }
      final sourceY = primary.dy + nodeHeight / 2;

      final childPositions =
          ce.childIds.map((id) => positions[id]).whereType<Offset>().toList();
      if (childPositions.isEmpty) continue;

      final childTopY = childPositions.first.dy - nodeHeight / 2;
      final junctionY = (sourceY + childTopY) / 2;

      final path = Path();
      const radius = 16.0;

      for (final childPos in childPositions) {
        final start = Offset(sourceX, sourceY);
        final end = Offset(childPos.dx, childTopY);

        if ((start.dx - end.dx).abs() < 1.0) {
          path.moveTo(start.dx, start.dy);
          path.lineTo(end.dx, end.dy);
        } else {
          final direction = (end.dx > start.dx) ? 1.0 : -1.0;
          final maxRX = (start.dx - end.dx).abs() / 2;
          final maxRY = (junctionY - start.dy < end.dy - junctionY)
              ? (junctionY - start.dy)
              : (end.dy - junctionY);
          final r = radius < maxRX
              ? (radius < maxRY ? radius : maxRY)
              : (maxRX < maxRY ? maxRX : maxRY);

          path.moveTo(start.dx, start.dy);
          path.lineTo(start.dx, junctionY - r);
          path.quadraticBezierTo(
              start.dx, junctionY, start.dx + direction * r, junctionY);
          path.lineTo(end.dx - direction * r, junctionY);
          path.quadraticBezierTo(end.dx, junctionY, end.dx, junctionY + r);
          path.lineTo(end.dx, end.dy);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // ── Orphan edges — bezier (fallback cho nodes ngoài layout chính) ────
    for (final edge in orphanEdges) {
      final parent = positions[edge.parentId];
      final child = positions[edge.childId];
      if (parent == null || child == null) continue;

      final start = Offset(parent.dx, parent.dy + nodeHeight / 2);
      final end = Offset(child.dx, child.dy - nodeHeight / 2);
      final midY = (start.dy + end.dy) / 2;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(start.dx, midY, end.dx, midY, end.dx, end.dy);
      canvas.drawPath(path, linePaint);
    }

    // ── Spouse edges — cặp nhẫn cưới lồng nhau (Interlocking Rings ⚭) ──
    const ringRadius = 4.5;
    const ringSpacing = 2.8;

    for (final se in spouseEdges) {
      final left = positions[se.leftMemberId];
      final right = positions[se.rightMemberId];
      if (left == null || right == null) continue;

      final start = Offset(left.dx + TreeLayoutMetrics.nodeWidth / 2, left.dy);
      final end =
          Offset(right.dx - TreeLayoutMetrics.nodeWidth / 2, right.dy);
      final midX = (start.dx + end.dx) / 2;
      final midY = start.dy;

      // Vẽ 2 chiếc nhẫn cưới lồng nhau màu Crimson
      final ringColor = se.isDivorced ? Colors.grey : primaryColor;
      final ringPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Nhẫn trái & nhẫn phải lồng nhau
      canvas.drawCircle(
          Offset(midX - ringSpacing, midY), ringRadius, ringPaint);
      canvas.drawCircle(
          Offset(midX + ringSpacing, midY), ringRadius, ringPaint);

      // Nếu ly hôn: Vẽ vạch gạch chéo
      if (se.isDivorced) {
        final slashPaint = Paint()
          ..color = Colors.grey.shade600
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(midX - 6.0, midY - 5.5),
          Offset(midX + 6.0, midY + 5.5),
          slashPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TreeEdgePainter oldDelegate) {
    return oldDelegate.coupleEdges != coupleEdges ||
        oldDelegate.orphanEdges != orphanEdges ||
        oldDelegate.spouseEdges != spouseEdges ||
        oldDelegate.positions != positions ||
        oldDelegate.generationLevels != generationLevels ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.surfaceColor != surfaceColor;
  }
}
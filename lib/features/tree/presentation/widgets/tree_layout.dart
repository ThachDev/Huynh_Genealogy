import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';

class LayoutNode {
  final MemberEntity member;
  double x = 0;
  double y = 0;
  
  LayoutNode(this.member);
}

class FamilyUnit {
  final LayoutNode primary;
  LayoutNode? spouse;
  final List<FamilyUnit> children = [];
  
  double width = 0;
  double x = 0;
  double y = 0;
  
  FamilyUnit(this.primary);
}

class TreeLayoutCalculator {
  static const double nodeWidth = 150.0;
  static const double nodeHeight = 140.0;
  static const double horizontalGap = 80.0;
  static const double verticalGap = 120.0;
  static const double spouseGap = 20.0;
  
  final List<FamilyUnit> roots = [];
  final List<LayoutNode> allNodes = [];
  double treeWidth = 0;
  double treeHeight = 0;
  
  TreeLayoutCalculator(List<MemberEntity> members) {
    _buildTree(members);
    _calculateLayout();
  }
  
  void _buildTree(List<MemberEntity> members) {
    final Map<int, LayoutNode> nodeMap = {};
    for (var m in members) {
      final node = LayoutNode(m);
      nodeMap[m.id] = node;
      allNodes.add(node);
    }
    
    final Map<int, FamilyUnit> unitMap = {};
    final Set<int> processedSpouses = {};
    
    for (var m in members) {
      if (processedSpouses.contains(m.id)) continue;
      
      var primaryNode = nodeMap[m.id]!;
      LayoutNode? spouseNode;
      
      if (m.spouseId != null && nodeMap.containsKey(m.spouseId)) {
         spouseNode = nodeMap[m.spouseId];
         processedSpouses.add(m.spouseId!);
         // Put bloodline as primary if possible
         if (spouseNode!.member.parentId != null && primaryNode.member.parentId == null) {
            final temp = primaryNode;
            primaryNode = spouseNode;
            spouseNode = temp;
         }
      }
      
      final unit = FamilyUnit(primaryNode);
      unit.spouse = spouseNode;
      
      unitMap[primaryNode.member.id] = unit;
      if (spouseNode != null) {
        unitMap[spouseNode.member.id] = unit;
      }
      
      processedSpouses.add(primaryNode.member.id);
    }
    
    for (var unit in unitMap.values.toSet()) {
      final primaryParentId = unit.primary.member.parentId;
      final spouseParentId = unit.spouse?.member.parentId;
      
      FamilyUnit? parentUnit;
      if (primaryParentId != null && unitMap.containsKey(primaryParentId)) {
        parentUnit = unitMap[primaryParentId];
      } else if (spouseParentId != null && unitMap.containsKey(spouseParentId)) {
        parentUnit = unitMap[spouseParentId];
      }
      
      if (parentUnit != null && parentUnit != unit) {
        if (!parentUnit.children.contains(unit)) {
          parentUnit.children.add(unit);
        }
      } else {
        if (!roots.contains(unit)) {
          roots.add(unit);
        }
      }
    }
  }

  void _calculateLayout() {
    double currentX = 0;
    
    for (var root in roots) {
      _computeWidth(root);
      _assignPositions(root, currentX, 0);
      currentX += root.width + horizontalGap;
    }
    
    treeWidth = currentX > 0 ? currentX - horizontalGap : 0;
    
    double maxY = 0;
    for (var node in allNodes) {
      if (node.y > maxY) maxY = node.y;
    }
    treeHeight = maxY + nodeHeight;
  }
  
  void _computeWidth(FamilyUnit unit) {
    double childrenWidth = 0;
    for (var child in unit.children) {
      _computeWidth(child);
      childrenWidth += child.width;
    }
    if (unit.children.isNotEmpty) {
      childrenWidth += (unit.children.length - 1) * horizontalGap;
    }
    
    double parentsWidth = nodeWidth;
    if (unit.spouse != null) {
      parentsWidth = nodeWidth * 2 + spouseGap;
    }
    
    unit.width = max(parentsWidth, childrenWidth);
  }
  
  void _assignPositions(FamilyUnit unit, double leftX, double topY) {
    unit.x = leftX;
    unit.y = topY;
    
    double centerX = leftX + unit.width / 2;
    
    if (unit.spouse == null) {
      unit.primary.x = centerX - nodeWidth / 2;
      unit.primary.y = topY;
    } else {
      double totalParentWidth = nodeWidth * 2 + spouseGap;
      double startX = centerX - totalParentWidth / 2;
      
      unit.primary.x = startX;
      unit.primary.y = topY;
      
      unit.spouse!.x = startX + nodeWidth + spouseGap;
      unit.spouse!.y = topY;
    }
    
    if (unit.children.isNotEmpty) {
      double childrenTotalWidth = 0;
      for (var child in unit.children) {
        childrenTotalWidth += child.width;
      }
      childrenTotalWidth += (unit.children.length - 1) * horizontalGap;
      
      double childStartX = centerX - childrenTotalWidth / 2;
      double childTopY = topY + nodeHeight + verticalGap;
      
      for (var child in unit.children) {
        _assignPositions(child, childStartX, childTopY);
        childStartX += child.width + horizontalGap;
      }
    }
  }
}

class TreeEdgePainter extends CustomPainter {
  final List<LayoutNode> nodes;
  final Map<int, LayoutNode> nodeMap;

  TreeEdgePainter(this.nodes) : nodeMap = {for (var n in nodes) n.member.id: n};

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
      
    final spousePaint = Paint()
      ..color = Colors.pinkAccent.withValues(alpha: 0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Set<String> drawnSpouseEdges = {};

    for (var node in nodes) {
      if (node.member.parentId != null && nodeMap.containsKey(node.member.parentId)) {
        final parent = nodeMap[node.member.parentId]!;
        final startX = parent.x + TreeLayoutCalculator.nodeWidth / 2;
        final startY = parent.y + TreeLayoutCalculator.nodeHeight - 15;
        
        final endX = node.x + TreeLayoutCalculator.nodeWidth / 2;
        final endY = node.y + 10;
        
        final path = Path();
        path.moveTo(startX, startY);
        final controlPoint1Y = startY + (endY - startY) / 2;
        final controlPoint2Y = startY + (endY - startY) / 2;
        
        path.cubicTo(
          startX, controlPoint1Y,
          endX, controlPoint2Y,
          endX, endY
        );
        canvas.drawPath(path, edgePaint);
      }
      
      if (node.member.spouseId != null && nodeMap.containsKey(node.member.spouseId)) {
        final spouseId = node.member.spouseId!;
        final edgeId1 = '${node.member.id}-$spouseId';
        final edgeId2 = '$spouseId-${node.member.id}';
        
        if (!drawnSpouseEdges.contains(edgeId1) && !drawnSpouseEdges.contains(edgeId2)) {
           final spouse = nodeMap[spouseId]!;
           final startX = node.x + TreeLayoutCalculator.nodeWidth / 2;
           final startY = node.y + TreeLayoutCalculator.nodeHeight / 2 - 20;
           
           final endX = spouse.x + TreeLayoutCalculator.nodeWidth / 2;
           final endY = spouse.y + TreeLayoutCalculator.nodeHeight / 2 - 20;
           
           canvas.drawLine(Offset(startX, startY), Offset(endX, endY), spousePaint);
           drawnSpouseEdges.add(edgeId1);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant TreeEdgePainter oldDelegate) => true;
}

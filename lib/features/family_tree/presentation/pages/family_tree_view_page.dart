import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/auth.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../bloc/family_tree_bloc.dart';
import '../widgets/family_member_node_widget.dart';
import '../widgets/add_member_option_dialog.dart';
import '../widgets/select_unlinked_member_sheet.dart';
import 'family_member_detail_page.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_member_form_page.dart';
import '../../../admin/domain/usecase/save_member.dart';
import '../../../../core/di/injection_container.dart';

const double _nodeWidth = 140.0;
const double _hSpacing = 40.0;
const double _vSpacing =
    220.0; // Phải > _nodeHeight (160) để nodes không chồng lên nhau
const double _rootSpacing = 60.0;
const double _padding = 40.0;
const double _spouseGap = 16.0;

class _EdgeData {
  _EdgeData({required this.parentId, required this.childId});
  final int parentId;
  final int childId;
}

class _SpouseEdge {
  _SpouseEdge({
    required this.leftMemberId,
    required this.rightMemberId,
    this.isDivorced = false,
  });
  final int leftMemberId;
  final int rightMemberId;
  final bool isDivorced;
}

/// Nhóm tất cả con của một cặp đôi để vẽ T-bar junction thay vì bezier rời rạc
class _CoupleEdge {
  _CoupleEdge({
    required this.primaryId,
    this.spouseId,
    required this.childIds,
  });
  final int primaryId;
  final int? spouseId;
  final List<int> childIds;
}

class FamilyTreeViewPage extends StatefulWidget {
  const FamilyTreeViewPage({super.key});

  @override
  State<FamilyTreeViewPage> createState() => _FamilyTreeViewPageState();
}

class _FamilyTreeViewPageState extends State<FamilyTreeViewPage>
    with TickerProviderStateMixin {
  double get _nodeHeight {
    final authState = context.read<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;
    return canEdit ? 160.0 : 125.0;
  }

  final TransformationController _transformationController =
      TransformationController();
  AnimationController? _matrixAnimationController;
  Animation<Matrix4>? _matrixAnimation;

  bool _hasFitTree = false;
  bool _showGenerationBadges = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  Map<int, Offset>? _lastPositions;
  Size? _lastViewportSize;
  Size _lastTreeSize = Size.zero;

  Timer? _searchDebounceTimer;

  void _onTransformChanged() {
    if (mounted) setState(() {});
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.trim();
        });
      }
    });
  }

  void _animateMatrixTo(Matrix4 targetMatrix) {
    _matrixAnimationController?.stop();
    _matrixAnimationController?.dispose();

    _matrixAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    final matrixTween = Matrix4Tween(
      begin: _transformationController.value,
      end: targetMatrix,
    );

    _matrixAnimation = matrixTween.animate(CurvedAnimation(
      parent: _matrixAnimationController!,
      curve: Curves.easeInOutCubic,
    ));

    _matrixAnimation!.addListener(() {
      _transformationController.value = _matrixAnimation!.value;
    });

    _matrixAnimationController!.forward();
  }

  void _fitTreeOverview() {
    final viewport = _lastViewportSize;
    final treeSize = _lastTreeSize;
    if (viewport == null || treeSize == Size.zero) return;

    final scaleX = viewport.width / treeSize.width;
    final scaleY = viewport.height / treeSize.height;
    final scale = (scaleX < scaleY ? scaleX : scaleY).clamp(0.2, 1.0);

    final contentCenterX = (_padding + treeSize.width) / 2;
    final contentCenterY = (_padding + treeSize.height) / 2;

    final dx = viewport.width / 2 - contentCenterX * scale;
    final dy = viewport.height / 2 - contentCenterY * scale;

    final matrix = Matrix4.identity();
    matrix.setEntry(0, 0, scale);
    matrix.setEntry(1, 1, scale);
    matrix.setEntry(2, 2, 1.0);
    matrix.setEntry(0, 3, dx);
    matrix.setEntry(1, 3, dy);

    _animateMatrixTo(matrix);
  }

  void _centerOnNode(int memberId) {
    final pos = _lastPositions?[memberId];
    final viewport = _lastViewportSize;
    if (pos == null || viewport == null) return;

    const scale = 1.0;
    final tx = viewport.width / 2 - pos.dx * scale;
    final ty = viewport.height / 2 - pos.dy * scale;

    final matrix = Matrix4.identity();
    matrix.setEntry(0, 0, scale);
    matrix.setEntry(1, 1, scale);
    matrix.setEntry(2, 2, 1.0);
    matrix.setEntry(0, 3, tx);
    matrix.setEntry(1, 3, ty);

    _animateMatrixTo(matrix);
  }

  /// Reload cây gia phả sau khi thêm thành viên/vợ chồng.
  void _reloadTree() {
    if (!mounted) return;
    final authState = context.read<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;
    context.read<FamilyTreeBloc>().add(FamilyTreeLoadEvent(familyId: familyId));
  }

  @override
  void dispose() {
    _matrixAnimationController?.stop();
    _matrixAnimationController?.dispose();
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    _searchDebounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authState = context.read<AuthBloc>().state;
      final familyId =
          authState is Authenticated ? authState.user.familyId : null;
      context
          .read<FamilyTreeBloc>()
          .add(FamilyTreeLoadEvent(familyId: familyId));
    });
  }

  Map<int, Offset> _calculateLayout(
    List<MemberEntity> rawMembers,
    List<_CoupleEdge>
        coupleEdges, // Junction edges: 1 entry = 1 cặp + tất cả con
    List<_EdgeData>
        orphanEdges, // Fallback bezier cho nodes không qua layout chính
    List<_SpouseEdge> spouseEdges,
  ) {
    // Tách danh sách con theo cha/mẹ
    final childrenMap = <int?, List<MemberEntity>>{};
    for (final m in rawMembers) {
      if (m.parentId != null) {
        childrenMap.putIfAbsent(m.parentId, () => []).add(m);
      }
    }

    // Lọc bỏ những member hoàn toàn cô lập: không cha mẹ, không vợ chồng, không con, không chi tộc
    final members = rawMembers.where((m) {
      final hasParent = m.parentId != null || m.motherId != null;
      final hasSpouse = m.spouseId != null;
      final hasChildren = (childrenMap[m.id] ?? []).isNotEmpty;
      final hasBranch = m.branchId != null;

      // Nếu có ít nhất 1 mối liên kết -> Giữ lại để vẽ cây
      return hasParent || hasSpouse || hasChildren || hasBranch;
    }).toList();

    final memberMap = {for (final m in members) m.id: m};
    final childrenOf = <int?, List<MemberEntity>>{};
    for (final m in members) {
      childrenOf.putIfAbsent(m.parentId, () => []).add(m);
    }

    int minGen = 999;
    for (final m in members) {
      if (m.generation != null && m.generation! < minGen) {
        minGen = m.generation!;
      }
    }
    if (minGen == 999) minGen = 1;

    final visited = <int>{};

    (Map<int, Offset>, double) layoutSubtree(int nodeId, int gen) {
      if (visited.contains(nodeId)) return (<int, Offset>{}, 0.0);
      visited.add(nodeId);

      final member = memberMap[nodeId]!;
      final currentGen = member.generation ?? gen;
      final y = (currentGen - minGen) * _vSpacing;

      final spouseIds = <int>[];
      if (member.spouseId != null && memberMap.containsKey(member.spouseId)) {
        spouseIds.add(member.spouseId!);
      }
      // Tìm xem có ai trỏ spouseId vào member này không
      for (final m in members) {
        if (m.spouseId == member.id && !spouseIds.contains(m.id)) {
          spouseIds.add(m.id);
        }
      }

      // Lọc các spouse đã được vẽ (do data lỗi cyclic)
      spouseIds.removeWhere((id) => visited.contains(id));
      visited.addAll(spouseIds);

      // Children linked to primary parent
      final primaryChildren = childrenOf[nodeId] ?? <MemberEntity>[];
      // Children linked to spouses
      final spouseChildren = <MemberEntity>[];
      for (final sId in spouseIds) {
        final children = childrenOf[sId];
        if (children != null) {
          spouseChildren.addAll(children);
        }
      }

      // Gộp và loại bỏ các con bị lặp lại hoặc đã được xử lý
      final allChildrenMap = <int, MemberEntity>{};
      for (final c in primaryChildren) {
        if (!visited.contains(c.id)) allChildrenMap[c.id] = c;
      }
      for (final c in spouseChildren) {
        if (!visited.contains(c.id)) allChildrenMap[c.id] = c;
      }
      final allChildren = allChildrenMap.values.toList();

      // Layout each side's subtrees
      final allResults =
          allChildren.map((c) => layoutSubtree(c.id, currentGen + 1)).toList();

      // Chỉ giữ lại những con thực sự được vẽ (width > 0)
      final validChildren = <MemberEntity>[];
      final validResults = <(Map<int, Offset>, double)>[];
      for (int i = 0; i < allChildren.length; i++) {
        if (allResults[i].$2 > 0) {
          validChildren.add(allChildren[i]);
          validResults.add(allResults[i]);
        }
      }

      // Spouse center X coordinates relative to primary (0 = primary center)
      final spouseCenterXList = <double>[];
      for (int i = 0; i < spouseIds.length; i++) {
        spouseCenterXList.add((i + 1) * (_nodeWidth + _spouseGap));
      }
      final maxSpouseCenterX =
          spouseIds.isNotEmpty ? spouseCenterXList.last : 0.0;

      // Midpoint giữa toàn bộ nhóm cha/mẹ (local coords) — dùng để căn giữa tất cả con
      final coupleCenter = maxSpouseCenterX / 2;

      // Tổng chiều rộng của tất cả con
      double totalChildWidth = 0;
      for (final r in validResults) {
        totalChildWidth += r.$2;
      }
      if (validResults.length > 1) {
        totalChildWidth += _hSpacing * (validResults.length - 1);
      }

      // Tính bounding box của toàn bộ subtree
      double minX = -_nodeWidth / 2;
      double maxX = _nodeWidth / 2;
      if (spouseIds.isNotEmpty) {
        maxX = maxSpouseCenterX + _nodeWidth / 2;
      }
      if (totalChildWidth > 0) {
        final childLeft = coupleCenter - totalChildWidth / 2;
        final childRight = coupleCenter + totalChildWidth / 2;
        if (childLeft < minX) minX = childLeft;
        if (childRight > maxX) maxX = childRight;
      }

      final totalWidth = maxX - minX;
      final shift = -minX; // Shift to map minX → 0

      final allPos = <int, Offset>{};
      allPos[nodeId] = Offset(shift, y);

      int prevId = nodeId;
      for (int i = 0; i < spouseIds.length; i++) {
        final sId = spouseIds[i];
        allPos[sId] = Offset(shift + spouseCenterXList[i], y);

        final isDivorced =
            memberMap[sId]?.maritalStatus == MaritalStatus.divorced ||
                memberMap[prevId]?.maritalStatus == MaritalStatus.divorced;

        spouseEdges.add(_SpouseEdge(
          leftMemberId: prevId,
          rightMemberId: sId,
          isDivorced: isDivorced,
        ));
        prevId = sId;
      }

      // Đặt tất cả con căn giữa tại coupleCenter (midpoint cha+mẹ)
      // cx = vị trí bắt đầu của bộ con, trong local coords (không có shift)
      double cx = coupleCenter - totalChildWidth / 2;
      for (int i = 0; i < validResults.length; i++) {
        final cPos = validResults[i].$1;
        final cWidth = validResults[i].$2;
        for (final entry in cPos.entries) {
          // entry.value.dx đo từ left-edge của subtree bounding box
          // shift + cx đặt left-edge đó đúng vị trí
          allPos[entry.key] = Offset(
            entry.value.dx + shift + cx,
            entry.value.dy,
          );
        }
        cx += cWidth + _hSpacing;
      }

      if (validChildren.isNotEmpty) {
        final Map<int?, List<MemberEntity>> childrenByMother = {};
        for (final child in validChildren) {
          final mId = child.motherId;
          childrenByMother.putIfAbsent(mId, () => []).add(child);
        }

        for (final entry in childrenByMother.entries) {
          final mId = entry.key;
          final children = entry.value;

          int? edgeSpouseId;
          if (mId != null && spouseIds.contains(mId)) {
            edgeSpouseId = mId;
          }

          coupleEdges.add(_CoupleEdge(
            primaryId: nodeId,
            spouseId: edgeSpouseId,
            childIds: children.map((c) => c.id).toList(),
          ));
        }
      }

      return (allPos, totalWidth);
    }

    final roots = members
        .where(
          (m) => m.parentId == null || !memberMap.containsKey(m.parentId),
        )
        .toList();

    final allPositions = <int, Offset>{};
    double rootX = 0;

    if (roots.isEmpty && members.isNotEmpty) {
      // Nếu không tìm thấy root nào khớp điều kiện trên nhưng danh sách không rỗng (ví dụ data cũ)
      final firstWithLink = members.firstWhere(
        (m) =>
            m.generation == 1 ||
            m.spouseId != null ||
            (childrenOf[m.id] ?? []).isNotEmpty,
        orElse: () => members.first,
      );
      final (positions, _) = layoutSubtree(firstWithLink.id, minGen);
      for (final entry in positions.entries) {
        allPositions[entry.key] = entry.value;
      }
    } else {
      for (final root in roots) {
        // Nếu đã được đặt vị trí (ví dụ là spouse của root trước) → bỏ qua
        // tránh layout lại gây overwrite positions và duplicate coupleEdges
        if (allPositions.containsKey(root.id)) continue;
        final gen = root.generation ?? minGen;
        final (positions, width) = layoutSubtree(root.id, gen);
        for (final entry in positions.entries) {
          allPositions[entry.key] =
              Offset(entry.value.dx + rootX + width / 2, entry.value.dy);
        }
        rootX += width + _rootSpacing;
      }
    }

    // Chỉ tạo spouseEdges cho các cặp không qua coupleEdges (nếu có)
    for (final m in members) {
      if (allPositions.containsKey(m.id)) {
        if (m.spouseId != null && allPositions.containsKey(m.spouseId)) {
          spouseEdges.add(_SpouseEdge(
            leftMemberId: m.id < m.spouseId! ? m.id : m.spouseId!,
            rightMemberId: m.id < m.spouseId! ? m.spouseId! : m.id,
          ));
        }
      }
    }

    if (allPositions.isEmpty) return allPositions;

    double minX = double.infinity, minY = double.infinity;
    for (final entry in allPositions.entries) {
      final left = entry.value.dx - _nodeWidth / 2;
      final top = entry.value.dy - _nodeHeight / 2;
      if (left < minX) minX = left;
      if (top < minY) minY = top;
    }

    final shift = Offset(-minX + _padding, -minY + _padding);
    for (final entry in allPositions.entries) {
      allPositions[entry.key] = entry.value + shift;
    }

    return allPositions;
  }

  Widget _buildSearchTitleWidget(BuildContext context, String appBarTitle) {
    final l10n = AppLocalizations.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          ),
        );
      },
      child: _isSearching
          ? Container(
              key: const ValueKey('search_input_active'),
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: context.resolve(
                  Colors.white.withValues(alpha: 0.95),
                  context.surface.withValues(alpha: 0.95),
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textPrimary,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.searchMemberHint,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: context.textSecondary.withValues(alpha: 0.6),
                    height: 1.2,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      LucideIcons.search,
                      size: 16,
                      color: context.accent,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12, left: 4),
                            child: Icon(
                              LucideIcons.x,
                              size: 16,
                              color: context.textSecondary,
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )
          : Text(
              appBarTitle,
              key: const ValueKey('search_title_inactive'),
              style: GoogleFonts.beVietnamPro(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
    );
  }

  Widget _buildSearchDropdownOverlay(
      BuildContext context, List<MemberEntity> members) {
    final l10n = AppLocalizations.of(context);
    final filteredMembers = members.where((m) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = m.fullName.toLowerCase();
      final phone = (m.phone ?? '').toLowerCase();
      return name.contains(q) || phone.contains(q);
    }).toList();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: _isSearching ? 8 : -45,
      left: 16,
      right: 16,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        opacity: _isSearching ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !_isSearching,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            color: context.surface,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 340),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filteredMembers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 18,
                            color: context.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.emptyMembers,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: filteredMembers.length > 8
                            ? 8
                            : filteredMembers.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: context.textSecondary.withValues(alpha: 0.1),
                        ),
                        itemBuilder: (context, index) {
                          final m = filteredMembers[index];
                          final genText = m.generation != null
                              ? l10n.generationLevelFormat(
                                  _TreeEdgePainter.toRoman(m.generation!))
                              : '';

                          return ListTile(
                            dense: true,
                            leading: AppAvatar(
                              avatarUrl: m.avatarUrl,
                              fullName: m.fullName,
                              radius: 18,
                            ),
                            title: Text(
                              m.fullName,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              [genText, if (!m.isAlive) l10n.deceasedLabel]
                                  .where((s) => s.isNotEmpty)
                                  .join(' • '),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: context.textSecondary,
                              ),
                            ),
                            trailing: Icon(
                              LucideIcons.focus,
                              size: 16,
                              color: context.accent,
                            ),
                            onTap: () {
                              _centerOnNode(m.id);
                              context.read<FamilyTreeBloc>().add(
                                    FamilyTreeSelectMemberEvent(m.id),
                                  );
                              setState(() {
                                _isSearching = false;
                                _searchQuery = '';
                                _searchController.clear();
                              });
                              _searchFocusNode.unfocus();
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;
    final treeState = context.watch<FamilyTreeBloc>().state;
    String appBarTitle = l10n.familyTreeTitle;
    List<Widget> appBarActions = [];

    if (treeState is FamilyTreeLoaded) {
      if (treeState.family != null) {
        appBarTitle = l10n.familyTreeNameFormat(treeState.family!.name);
      }
      if (treeState.members.isNotEmpty) {
        appBarActions = [
          IconButton(
            icon: Icon(
              _isSearching ? LucideIcons.x : LucideIcons.search,
              color: context.textPrimary,
            ),
            tooltip: _isSearching
                ? l10n.closeSearchTooltip
                : l10n.searchMemberTooltip,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                  _searchFocusNode.unfocus();
                } else {
                  _searchFocusNode.requestFocus();
                }
              });
            },
          ),
        ];
      }
    }

    return Scaffold(
      backgroundColor: context.appBarBg,
      appBar: AppAppBar(
        titleWidget: _buildSearchTitleWidget(context, appBarTitle),
        actions: appBarActions,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'toggle_badges_fab',
            tooltip:
                _showGenerationBadges ? l10n.hideGenBadges : l10n.showGenBadges,
            onPressed: () {
              setState(() {
                _showGenerationBadges = !_showGenerationBadges;
              });
            },
            backgroundColor:
                context.resolve(Colors.white, const Color(0xFF2A2A2A)),
            mini: true,
            child: Icon(
              LucideIcons.tag,
              color: _showGenerationBadges
                  ? context.primary
                  : context.textSecondary.withValues(alpha: 0.4),
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'fit_overview_fab',
            tooltip: l10n.treeOverviewTooltip,
            onPressed: _fitTreeOverview,
            backgroundColor:
                context.resolve(Colors.white, const Color(0xFF2A2A2A)),
            mini: true,
            child: Icon(
              LucideIcons.maximize2,
              color: context.primary,
              size: 18,
            ),
          ),
        ],
      ),
      body: AppBackgroundBody(
        child: Stack(
          children: [
            BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
              builder: (context, state) {
                if (state is FamilyTreeLoading) {
                  _hasFitTree = false; // Reset to auto-fit on next load
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: FamilyTreeSkeleton(),
                  );
                }

                if (state is FamilyTreeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: GoogleFonts.inter(color: context.primary),
                    ),
                  );
                }

                if (state is FamilyTreeLoaded) {
                  if (state.members.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noTreeDataMessage,
                        style: GoogleFonts.inter(
                          color: context.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final coupleEdges = <_CoupleEdge>[];
                  final orphanEdges = <_EdgeData>[];
                  final spouseEdges = <_SpouseEdge>[];
                  final positions = _calculateLayout(
                    state.members,
                    coupleEdges,
                    orphanEdges,
                    spouseEdges,
                  );

                  double maxX = _padding * 2, maxY = _padding * 2;
                  for (final entry in positions.entries) {
                    final right = entry.value.dx + _nodeWidth / 2;
                    final bottom = entry.value.dy + _nodeHeight / 2;
                    maxX = maxX > right ? maxX : right;
                    maxY = maxY > bottom ? maxY : bottom;
                  }
                  final treeSize = Size(maxX, maxY);

                  final generationLevels = <int, double>{};
                  for (final m in state.members) {
                    final pos = positions[m.id];
                    if (pos != null && m.generation != null) {
                      generationLevels.putIfAbsent(m.generation!, () => pos.dy);
                    }
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth == 0 ||
                          constraints.maxHeight == 0) {
                        return const SizedBox.shrink();
                      }

                      // Update positions & viewport sizes for search node centering
                      _lastPositions = positions;
                      _lastViewportSize =
                          Size(constraints.maxWidth, constraints.maxHeight);
                      _lastTreeSize = treeSize;

                      final authState = context.read<AuthBloc>().state;
                      final userMemberId = authState is Authenticated
                          ? authState.user.memberId
                          : null;

                      // Auto fit or zoom to user's node on load
                      if (!_hasFitTree) {
                        _hasFitTree = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (userMemberId != null &&
                              positions.containsKey(userMemberId)) {
                            _centerOnNode(userMemberId);
                          } else {
                            _fitTreeOverview();
                          }
                        });
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InteractiveViewer(
                            transformationController: _transformationController,
                            constrained: false,
                            boundaryMargin:
                                const EdgeInsets.all(double.infinity),
                            minScale:
                                0.1, // Allow zooming out further for overview
                            maxScale: 3.0,
                            child: SizedBox(
                              width: treeSize.width,
                              height: treeSize.height,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  RepaintBoundary(
                                    child: CustomPaint(
                                      size: treeSize,
                                      painter: _TreeEdgePainter(
                                        coupleEdges: coupleEdges,
                                        orphanEdges: orphanEdges,
                                        spouseEdges: spouseEdges,
                                        positions: positions,
                                        generationLevels: generationLevels,
                                        nodeHeight: _nodeHeight,
                                        primaryColor: context.primary,
                                        accentColor: context.accent,
                                        surfaceColor: context.surface,
                                        textColor: context.textPrimary,
                                        linePaint: Paint()
                                          ..color = context.resolve(
                                              context.accent,
                                              Colors.grey.shade700)
                                          ..strokeWidth = 3.0
                                          ..strokeCap = StrokeCap.round
                                          ..style = PaintingStyle.stroke,
                                        spousePaint: Paint()
                                          ..color = context.resolve(
                                              context.primary
                                                  .withValues(alpha: 0.6),
                                              Colors.grey.shade700
                                                  .withValues(alpha: 0.6))
                                          ..strokeWidth = 2.0
                                          ..strokeCap = StrokeCap.round
                                          ..style = PaintingStyle.stroke,
                                      ),
                                    ),
                                  ),
                                  ...state.members.map((member) {
                                    final pos = positions[member.id];
                                    if (pos == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Positioned(
                                      left: pos.dx - _nodeWidth / 2,
                                      top: pos.dy - _nodeHeight / 2,
                                      child: FamilyMemberNodeWidget(
                                        member: member,
                                        isSelected:
                                            state.selectedMemberId == member.id,
                                        isCurrentUser:
                                            userMemberId == member.id,
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          context.read<FamilyTreeBloc>().add(
                                              FamilyTreeSelectMemberEvent(
                                                  member.id));
                                          Navigator.push(
                                            context,
                                            SereneFadeSlidePageRoute(
                                              page: FamilyMemberDetailPage(
                                                member: member,
                                                allMembers: state.members,
                                              ),
                                            ),
                                          );
                                        },
                                        onAddChildTap: canEdit
                                            ? () => _onAddChild(
                                                member, state.members)
                                            : null,
                                        onAddSpouseTap: canEdit
                                            ? () => _onAddSpouse(
                                                member, state.members)
                                            : null,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),

                          // ── Sticky Pinned Floating Generation Badges (Ghim mép trái màn hình) ──
                          if (_showGenerationBadges)
                            AnimatedBuilder(
                              animation: _transformationController,
                              builder: (context, _) {
                                final matrix = _transformationController.value;
                                final sortedGens =
                                    generationLevels.keys.toList()..sort();

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: sortedGens.map((gen) {
                                    final canvasY = generationLevels[gen]!;
                                    final screenY = MatrixUtils.transformPoint(
                                            matrix, Offset(0, canvasY))
                                        .dy;

                                    // Ẩn badge nếu nằm ngoài khung nhìn màn hình
                                    if (screenY < -30 ||
                                        screenY > constraints.maxHeight + 30) {
                                      return const SizedBox.shrink();
                                    }

                                    return Positioned(
                                      left: 14,
                                      top: screenY - 7,
                                      child: Text(
                                        l10n
                                            .generationLevelFormat(
                                                _TreeEdgePainter.toRoman(gen))
                                            .toUpperCase(),
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: context.accent,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            _buildSearchDropdownOverlay(context,
                treeState is FamilyTreeLoaded ? treeState.members : []),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddChild(
      MemberEntity parentMember, List<MemberEntity> allMembers) async {
    final l10n = AppLocalizations.of(context);
    final candidateMembers = allMembers.where((m) {
      if (m.id == parentMember.id) return false;
      return m.parentId == null && m.motherId == null;
    }).toList();

    AddMemberOption? option;
    if (candidateMembers.isNotEmpty) {
      option = await AddMemberOptionDialog.show(
        context,
        title: l10n.addChildForFormat(parentMember.fullName),
        availableCount: candidateMembers.length,
      );
      if (option == null) return;
    } else {
      option = AddMemberOption.createNew;
    }

    if (!mounted) return;

    if (option == AddMemberOption.createNew) {
      final result = await Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: AdminMemberFormPage(
            initialParentId: parentMember.id,
            initialGeneration: (parentMember.generation ?? 0) + 1,
            isLockedContext: true,
          ),
        ),
      );
      if (result == true && mounted) {
        _reloadTree();
      }
    } else if (option == AddMemberOption.selectExisting) {
      final selectedMember = await SelectUnlinkedMemberSheet.show(
        context,
        candidateMembers: candidateMembers,
        title: l10n.selectChildMemberTitle,
        subtitle: l10n.linkAsChildFormat(parentMember.fullName),
      );
      if (selectedMember == null || !mounted) return;

      final confirm = await AppDialog.confirm(
        context,
        title: l10n.confirmConnectionLabel,
        message: l10n.confirmLinkChildMessage(
            selectedMember.fullName, parentMember.fullName),
        confirmLabel: l10n.confirmConnectionLabel,
        cancelLabel: l10n.cancelLabel,
        type: AppDialogType.info,
      );

      if (confirm == true && mounted) {
        final isMother = parentMember.gender == Gender.female;
        final updatedMember = selectedMember.copyWith(
          parentId: isMother ? selectedMember.parentId : parentMember.id,
          motherId: isMother ? parentMember.id : selectedMember.motherId,
          generation: (parentMember.generation ?? 0) + 1,
        );

        final saveMemberUsecase = sl<SaveMember>();
        final result =
            await saveMemberUsecase(SaveMemberParams(member: updatedMember));
        if (!mounted) return;

        result.fold(
          (failure) {
            AppSnackBar.error(context, failure.message);
          },
          (saved) {
            AppSnackBar.success(
                context, l10n.memberConnectedSuccessFormat(saved.fullName));
            _reloadTree();
          },
        );
      }
    }
  }

  Future<void> _onAddSpouse(
      MemberEntity spouseMember, List<MemberEntity> allMembers) async {
    final l10n = AppLocalizations.of(context);
    final candidateMembers = allMembers.where((m) {
      if (m.id == spouseMember.id) return false;
      return m.spouseId == null;
    }).toList();

    AddMemberOption? option;
    if (candidateMembers.isNotEmpty) {
      option = await AddMemberOptionDialog.show(
        context,
        title: l10n.addSpouseForFormat(spouseMember.fullName),
        availableCount: candidateMembers.length,
      );
      if (option == null) return;
    } else {
      option = AddMemberOption.createNew;
    }

    if (!mounted) return;

    if (option == AddMemberOption.createNew) {
      final result = await Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: AdminMemberFormPage(
            initialSpouseId: spouseMember.id,
            initialGeneration: spouseMember.generation,
            isLockedContext: true,
          ),
        ),
      );
      if (result == true && mounted) {
        _reloadTree();
      }
    } else if (option == AddMemberOption.selectExisting) {
      final selectedMember = await SelectUnlinkedMemberSheet.show(
        context,
        candidateMembers: candidateMembers,
        title: l10n.selectSpouseMemberTitle,
        subtitle: l10n.linkSpouseFormat(spouseMember.fullName),
      );
      if (selectedMember == null || !mounted) return;

      final confirm = await AppDialog.confirm(
        context,
        title: l10n.confirmConnectionLabel,
        message: l10n.confirmLinkSpouseMessage(
            selectedMember.fullName, spouseMember.fullName),
        confirmLabel: l10n.confirmConnectionLabel,
        cancelLabel: l10n.cancelLabel,
        type: AppDialogType.info,
      );

      if (confirm == true && mounted) {
        final updatedSelected = selectedMember.copyWith(
          spouseId: spouseMember.id,
          generation: spouseMember.generation ?? selectedMember.generation,
          maritalStatus: MaritalStatus.married,
        );

        final saveMemberUsecase = sl<SaveMember>();
        final result1 =
            await saveMemberUsecase(SaveMemberParams(member: updatedSelected));

        if (spouseMember.spouseId == null) {
          final updatedSpouse = spouseMember.copyWith(
            spouseId: selectedMember.id,
            maritalStatus: MaritalStatus.married,
          );
          await saveMemberUsecase(SaveMemberParams(member: updatedSpouse));
        }

        if (!mounted) return;

        result1.fold(
          (failure) {
            AppSnackBar.error(context, failure.message);
          },
          (saved) {
            AppSnackBar.success(context, l10n.spouseConnectedSuccess);
            _reloadTree();
          },
        );
      }
    }
  }
}

class _TreeEdgePainter extends CustomPainter {

  _TreeEdgePainter({
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
  final List<_CoupleEdge> coupleEdges;
  final List<_EdgeData> orphanEdges;
  final List<_SpouseEdge> spouseEdges;
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

      final start = Offset(left.dx + _nodeWidth / 2, left.dy);
      final end = Offset(right.dx - _nodeWidth / 2, right.dy);
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
  bool shouldRepaint(covariant _TreeEdgePainter oldDelegate) {
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

class MemberSearchDelegate extends SearchDelegate<int?> {

  MemberSearchDelegate(this.members);
  final List<MemberEntity> members;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(LucideIcons.x),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(LucideIcons.arrowLeft),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestions(context);
  }

  Widget _buildSuggestions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final matches = members
        .where((m) => m.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final member = matches[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: member.avatarUrl != null
                ? CachedNetworkImageProvider(member.avatarUrl!)
                : null,
            child: member.avatarUrl == null ? const Icon(Icons.person) : null,
          ),
          title: Text(member.fullName),
          subtitle: Text(l10n.generationLabel('${member.generation ?? 0}')),
          onTap: () {
            close(context, member.id);
          },
        );
      },
    );
  }
}

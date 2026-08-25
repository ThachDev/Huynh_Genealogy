import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_branch_detail_page.dart';
import '../../../admin/presentation/widgets/admin_dashboard/branch_item_widget.dart';
import '../../../family_tree/domain/entities/branch_entity.dart';
import '../../../family_tree/domain/entities/member_entity.dart';

/// Trang danh sách Chi Tộc / Nhánh dòng họ dùng 100% Core System Widgets.
class UserBranchListPage extends StatefulWidget {
  const UserBranchListPage({
    super.key,
    required this.branches,
    required this.members,
  });

  final List<BranchEntity> branches;
  final List<MemberEntity> members;

  @override
  State<UserBranchListPage> createState() => _UserBranchListPageState();
}

class _UserBranchListPageState extends State<UserBranchListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _countMembers(int? branchId) {
    if (branchId == null) return widget.members.length;
    return widget.members.where((m) => m.branchId == branchId).length;
  }

  List<BranchEntity> get _filteredBranches {
    if (_searchQuery.isEmpty) return widget.branches;
    return widget.branches.where((b) {
      final name = b.name.toLowerCase();
      final founder = (b.founderName ?? '').toLowerCase();
      final region = (b.region ?? '').toLowerCase();
      final desc = (b.description ?? '').toLowerCase();
      return name.contains(_searchQuery) ||
          founder.contains(_searchQuery) ||
          region.contains(_searchQuery) ||
          desc.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _filteredBranches;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.branchTabLabel,
      ),
      body: AppBackgroundBody(
        child: Column(
          children: [
            // ── System Search Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: AppSearchBar(
                controller: _searchController,
                hintText: l10n.searchBranchesHint,
              ),
            ),

            // ── System Branch List ──
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.gitBranch,
                            size: 48,
                            color: context.textSecondary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.emptyBranches,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final branch = filtered[index];
                        final memberCount = _countMembers(branch.id);

                        return BranchItemWidget(
                          branch: branch,
                          memberCount: memberCount,
                          onTap: () {
                            Navigator.push(
                              context,
                              SereneFadeSlidePageRoute(
                                page: AdminBranchDetailPage(
                                  branch: branch,
                                  members: widget.members,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

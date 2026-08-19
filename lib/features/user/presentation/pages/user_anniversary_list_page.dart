import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../models/upcoming_anniversary.dart';
import '../widgets/anniversary_card.dart';

/// Trang hiển thị danh sách Ngày Giỗ & Ngày Sinh Nhật theo 2 Tab.
class UserAnniversaryListPage extends StatefulWidget {
  final List<UpcomingAnniversary> deathAnniversaries;
  final List<UpcomingAnniversary> birthdays;
  final int initialTabIndex;

  const UserAnniversaryListPage({
    super.key,
    required this.deathAnniversaries,
    required this.birthdays,
    this.initialTabIndex = 0,
  });

  @override
  State<UserAnniversaryListPage> createState() =>
      _UserAnniversaryListPageState();
}

class _UserAnniversaryListPageState extends State<UserAnniversaryListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedSort = 'nearest';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<UpcomingAnniversary> _filterAndSort(List<UpcomingAnniversary> source) {
    final q = _query.trim().toLowerCase();
    var list = source;
    if (q.isNotEmpty) {
      list = list
          .where((a) =>
              a.title.toLowerCase().contains(q) || a.solarDateLabel.contains(q))
          .toList();
    }

    if (_selectedSort == 'nearest') {
      list.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    } else {
      list.sort((a, b) => b.daysRemaining.compareTo(a.daysRemaining));
    }

    return list;
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDeathTab = _tabController.index == 0;
    final hint = isDeathTab ? 'Tìm kiếm ngày giỗ...' : 'Tìm kiếm ngày sinh nhật...';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: AppSearchBar(
            controller: _searchController,
            hintText: hint,
            height: 38,
            onChanged: (value) => setState(() => _query = value),
            trailing: [
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: context.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 4,
                  offset: const Offset(0, 30),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    LucideIcons.listFilter,
                    size: 18,
                    color: context.textSecondary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'clear_all',
                      height: 38,
                      child: Row(
                        children: [
                          Icon(LucideIcons.filterX,
                              color: context.textPrimary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Bỏ chọn tất cả',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: context.textPrimary),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedSort = 'nearest';
                        });
                      },
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      enabled: false,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: StatefulBuilder(
                        builder: (context, setPopupState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Sắp xếp',
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: context.textPrimary)),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: CupertinoSlidingSegmentedControl<String>(
                                  backgroundColor: context.isDarkMode
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade200,
                                  thumbColor: context.isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.white,
                                  groupValue: _selectedSort,
                                  children: {
                                    'nearest': Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Gần nhất',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                    'furthest': Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Xa nhất',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                  },
                                  onValueChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedSort = value);
                                      setPopupState(() {});
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView({
    required List<UpcomingAnniversary> list,
    required bool isBirthday,
    required AppLocalizations l10n,
  }) {
    final filtered = _filterAndSort(list);

    if (filtered.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: list.isEmpty
              ? (isBirthday ? LucideIcons.cake : LucideIcons.flame)
              : LucideIcons.searchX,
          message: list.isEmpty
              ? (isBirthday
                  ? l10n.noBirthdaysMessage
                  : l10n.noDeathAnniversariesMessage)
              : l10n.noSearchResultsMessage,
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final data = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnniversaryCard(data: data, fullWidth: true),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Giỗ & Sinh Nhật',
      ),
      body: AppBackgroundBody(
        child: Column(
          children: [
            // ── Tab Bar Container chuẩn thiết kế hệ thống ──
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.resolve(
                      Colors.black.withValues(alpha: 0.04),
                      Colors.black.withValues(alpha: 0.2),
                    ),
                    blurRadius: 6,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: SizedBox(
                height: 34,
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    color: context.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: context.primary.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: context.textSecondary,
                  labelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.beVietnamPro(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.flame, size: 14),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Ngày giỗ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.cake, size: 14),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Sinh nhật',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Search Bar ──
            _buildSearchBar(context),

            // ── Tab Bar Views ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildListView(
                    list: widget.deathAnniversaries,
                    isBirthday: false,
                    l10n: l10n,
                  ),
                  _buildListView(
                    list: widget.birthdays,
                    isBirthday: true,
                    l10n: l10n,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

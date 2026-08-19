import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminHelpCenterPage extends StatefulWidget {

  const AdminHelpCenterPage({
    super.key,
    this.initialTabIndex = 0,
  });
  final int initialTabIndex;

  @override
  State<AdminHelpCenterPage> createState() => _AdminHelpCenterPageState();
}

class _AdminHelpCenterPageState extends State<AdminHelpCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _expandedFaqKeys = {};
  final Set<int> _expandedRegKeys = {};
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _appVersion = info.version);
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.helpAndInfoHubLabel,
      ),
      body: AppBackgroundBody(
        child: Column(
          children: [
            // ── Segmented Navigation Tabs ──
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.resolve(
                      Colors.black.withValues(alpha: 0.04),
                      Colors.black.withValues(alpha: 0.2),
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: context.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: context.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: context.textSecondary,
                labelStyle: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.helpCircle, size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l10n.tabFaqLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.scale, size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l10n.tabRegulationsLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.info, size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l10n.tabAboutLabel,
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

            // ── Tab Views ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFaqTab(context, l10n),
                  _buildRegulationsTab(context, l10n),
                  _buildAboutUsTab(context, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1: FAQ & TRỢ GIÚP
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFaqTab(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, l10n.contactSection),
          const SizedBox(height: 12),
          _buildContactRow(context),
          const SizedBox(height: 12),
          // ── Phả Hệ & Liên Kết ──
          _buildSectionTitle(context, l10n.genealogyMemberSection),
          const SizedBox(height: 12),
          _buildFaqItem(
            context: context,
            keyId: 'gene_add_member',
            question: l10n.faqAddMemberQuestion,
            answer: l10n.faqAddMemberAnswer,
          ),
          _buildFaqItem(
            context: context,
            keyId: 'gene_add_branch',
            question: l10n.faqAddBranchQuestion,
            answer: l10n.faqAddBranchAnswer,
          ),
          _buildFaqItem(
            context: context,
            keyId: 'gene_edit_member',
            question: l10n.faqEditMemberQuestion,
            answer: l10n.faqEditMemberAnswer,
          ),
          _buildFaqItem(
            context: context,
            keyId: 'gene_delete_member',
            question: l10n.faqDeleteMemberQuestion,
            answer: l10n.faqDeleteMemberAnswer,
          ),
          const SizedBox(height: 20),

          // ── Phân Quyền & Quản Trị Dòng Họ ──
          _buildSectionTitle(context, l10n.clanAndRolesSection),
          const SizedBox(height: 12),
          _buildFaqItem(
            context: context,
            keyId: 'clan_invite',
            question: l10n.faqInviteCodeQuestion,
            answer: l10n.faqInviteCodeAnswer,
          ),
          _buildFaqItem(
            context: context,
            keyId: 'clan_roles',
            question: l10n.faqRolesQuestion,
            answer: l10n.faqRolesAnswer,
          ),
          _buildFaqItem(
            context: context,
            keyId: 'clan_transfer',
            question: l10n.faqTransferOwnershipQuestion,
            answer: l10n.faqTransferOwnershipAnswer,
          ),
          const SizedBox(height: 20),

          // ── An Toàn Dữ Liệu & Tài Khoản ──
          _buildSectionTitle(context, l10n.techSecuritySection),
          const SizedBox(height: 12),
          _buildFaqItem(
            context: context,
            keyId: 'tech_security',
            question: l10n.faqDataSecurityQuestion,
            answer: l10n.faqDataSecurityAnswer,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2: QUY ĐỊNH & ĐIỀU KHOẢN
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildRegulationsTab(BuildContext context, AppLocalizations l10n) {
    final sections = [
      (l10n.regSection1Title, l10n.regSection1Content),
      (l10n.regSection2Title, l10n.regSection2Content),
      (l10n.regSection3Title, l10n.regSection3Content),
      (l10n.regSection4Title, l10n.regSection4Content),
      (l10n.regSection5Title, l10n.regSection5Content),
      (l10n.regSection6Title, l10n.regSection6Content),
      (l10n.regSection7Title, l10n.regSection7Content),
      (l10n.regSection8Title, l10n.regSection8Content),
      (l10n.regSection9Title, l10n.regSection9Content),
      (l10n.regSection10Title, l10n.regSection10Content),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        children: [
          _buildLegalHeader(context, l10n),
          const SizedBox(height: 16),
          ...List.generate(sections.length, (i) {
            return _buildRegulationSection(
              context,
              index: i,
              number: '${i + 1}',
              title: sections[i].$1,
              content: sections[i].$2,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegalHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.04),
              Colors.black.withValues(alpha: 0.2),
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/logo_launcher.png',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.regulationTitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.regulationLastUpdated,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: context.resolve(
                      context.textSecondary,
                      context.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3: VỀ CHÚNG TÔI
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildAboutUsTab(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/logo_launcher.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.appTitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: context.resolve(context.primary, context.textPrimary),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.aboutUsTagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: context.resolve(
                  context.textSecondary,
                  context.textSecondary.withValues(alpha: 0.85),
                ),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.accent.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.resolve(
                    Colors.black.withValues(alpha: 0.04),
                    Colors.black.withValues(alpha: 0.2),
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoTile(
                  context,
                  icon: LucideIcons.info,
                  label: l10n.versionLabel,
                  value: _appVersion,
                ),
                _buildDivider(context),
                _buildInfoTile(
                  context,
                  icon: LucideIcons.code2,
                  label: l10n.developerLabel,
                  value: 'ThachDev',
                ),
                _buildDivider(context),
                _buildInfoTile(
                  context,
                  icon: LucideIcons.mail,
                  label: l10n.contactEmailLabel,
                  value: 'thachhuynh.dev@gmail.com',
                  isLink: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.copyrightText,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: context.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER WIDGETS & ACCORDION
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 3.5,
          height: 15,
          decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.04),
              Colors.black.withValues(alpha: 0.2),
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => launchUrl(
            Uri(
              scheme: 'mailto',
              path: 'thachhuynh.dev@gmail.com',
              query: 'subject=${Uri.encodeComponent(l10n.emailSubjectHelp)}',
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Center(
                    child: Icon(LucideIcons.mail,
                        color: context.primary, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.supportEmailTitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.supportEmailValue,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: context.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.supportEmailSubtitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.resolve(
                            context.textSecondary,
                            context.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: context.textSecondary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required BuildContext context,
    required String keyId,
    required String question,
    required String answer,
  }) {
    final isExpanded = _expandedFaqKeys.contains(keyId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded
                ? context.primary.withValues(alpha: 0.3)
                : context.accent.withValues(alpha: 0.12),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: context.primary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedFaqKeys.remove(keyId);
                } else {
                  _expandedFaqKeys.add(keyId);
                }
              });
            },
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isExpanded
                                ? context.primary
                                : context.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: isExpanded
                              ? context.primary
                              : context.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity, height: 0),
                  secondChild: _buildDetailsContent(context, answer),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                  sizeCurve: Curves.easeInOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegulationSection(
    BuildContext context, {
    required int index,
    required String number,
    required String title,
    required String content,
  }) {
    final isExpanded = _expandedRegKeys.contains(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded
                ? context.primary.withValues(alpha: 0.3)
                : context.accent.withValues(alpha: 0.12),
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: context.primary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedRegKeys.remove(index);
                } else {
                  _expandedRegKeys.add(index);
                }
              });
            },
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: isExpanded
                              ? context.primary
                              : context.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            number,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color:
                                  isExpanded ? Colors.white : context.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isExpanded
                                ? context.primary
                                : context.textPrimary,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: isExpanded
                              ? context.primary
                              : context.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity, height: 0),
                  secondChild: _buildDetailsContent(context, content),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                  sizeCurve: Curves.easeInOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: context.accent.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 10),
          _buildRichContent(context, text),
        ],
      ),
    );
  }

  Widget _buildRichContent(BuildContext context, String text) {
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty) continue;

      widgets.add(_buildLine(context, line));
      if (i < lines.length - 1) {
        widgets.add(const SizedBox(height: 4));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildLine(BuildContext context, String line) {
    final cleanLine = line.startsWith('• ') ? line.substring(2) : line;
    final hasBold = cleanLine.contains('**');

    final spans = <InlineSpan>[];
    if (hasBold) {
      final boldRegex = RegExp(r'\*\*(.+?)\*\*');
      int lastEnd = 0;

      for (final match in boldRegex.allMatches(cleanLine)) {
        if (match.start > lastEnd) {
          spans.add(TextSpan(text: cleanLine.substring(lastEnd, match.start)));
        }
        spans.add(TextSpan(
          text: match.group(1),
          style: GoogleFonts.inter(
            fontSize: 12.5,
            height: 1.5,
            fontWeight: FontWeight.bold,
            color: context.primary,
          ),
        ));
        lastEnd = match.end;
      }

      if (lastEnd < cleanLine.length) {
        spans.add(TextSpan(text: cleanLine.substring(lastEnd)));
      }
    } else {
      spans.add(TextSpan(text: cleanLine));
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: context.accent.withValues(alpha: 0.6),
            width: 3,
          ),
        ),
      ),
      child: Text.rich(
        TextSpan(children: spans),
        style: GoogleFonts.inter(
          fontSize: 12.5,
          height: 1.5,
          color: context.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: context.primary.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isLink ? context.primary : context.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 18,
      endIndent: 18,
      color: context.textSecondary.withValues(alpha: 0.1),
    );
  }
}

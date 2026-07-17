import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminRegulationsPage extends StatefulWidget {
  const AdminRegulationsPage({super.key});

  @override
  State<AdminRegulationsPage> createState() => _AdminRegulationsPageState();
}

class _AdminRegulationsPageState extends State<AdminRegulationsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerFade;
  final Set<int> _expanded = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: l10n.regulationsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          children: [
            // ── Header ──
            FadeTransition(
              opacity: _headerFade,
              child: _buildHeader(context, l10n),
            ),
            const SizedBox(height: 24),

            // ── Sections ──
            ...List.generate(sections.length, (i) {
              return _buildSection(
                context,
                index: i,
                number: '${i + 1}',
                title: sections[i].$1,
                content: sections[i].$2,
              );
            }),

            const SizedBox(height: 16),

            // ── Copyright ──
            Text(
              l10n.copyrightText,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: context.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primary,
            context.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.accent.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo_launcher.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.regulationTitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.regulationLastUpdated,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: context.accent.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required int index,
    required String number,
    required String title,
    required String content,
  }) {
    final isExpanded = _expanded.contains(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                    blurRadius: 10,
                    offset: const Offset(0, 3),
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
                  _expanded.remove(index);
                } else {
                  _expanded.add(index);
                }
              });
            },
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      // Number badge
                      Container(
                        width: 28,
                        height: 28,
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
                      const SizedBox(width: 12),
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
                              : context.textSecondary
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity, height: 0),
                  secondChild: _buildContent(context, content),
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

  Widget _buildContent(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: context.accent.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 12),
          _buildRichContent(context, text),
        ],
      ),
    );
  }

  Widget _buildRichContent(BuildContext context, String text) {
    // Split by \n to handle bullet lines separately
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty) continue;

      widgets.add(_buildLine(context, line));
      if (i < lines.length - 1) {
        widgets.add(const SizedBox(height: 6));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildLine(BuildContext context, String line) {
    final bool isBullet = line.startsWith('•');
    final hasBold = line.contains('**');

    if (!hasBold) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBullet)
            Padding(
              padding: const EdgeInsets.only(top: 3, right: 6),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: context.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Expanded(
            child: Text(
              isBullet ? line.substring(2) : line,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.6,
                color: context.textPrimary,
              ),
            ),
          ),
        ],
      );
    }

    // Handle **bold** inline markers
    final spans = <InlineSpan>[];
    final boldRegex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(line)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: line.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.inter(
          fontSize: 12,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: context.primary,
        ),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < line.length) {
      spans.add(TextSpan(text: line.substring(lastEnd)));
    }

    // Role-line: has leading **Role** – description pattern
    final isRoleLine = line.trimLeft().startsWith('**');

    return Container(
      margin: isRoleLine ? const EdgeInsets.only(bottom: 2) : EdgeInsets.zero,
      padding: isRoleLine
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
          : EdgeInsets.zero,
      decoration: isRoleLine
          ? BoxDecoration(
              color: context.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: context.accent.withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
            )
          : null,
      child: Text.rich(
        TextSpan(children: spans),
        style: GoogleFonts.inter(
          fontSize: 12,
          height: 1.6,
          color: context.textPrimary,
        ),
      ),
    );
  }
}

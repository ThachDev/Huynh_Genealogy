import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/models/family_book_config.dart';
import '../../domain/models/family_tree_poster_config.dart';
import '../widgets/family_book_config_tab.dart';
import '../widgets/family_poster_config_tab.dart';
import 'family_book_preview_page.dart';
import 'family_tree_poster_preview_page.dart';

class FamilyBookConfigPage extends StatefulWidget {
  const FamilyBookConfigPage({
    super.key,
    required this.members,
    this.initialFamilyName,
  });

  final List<MemberEntity> members;
  final String? initialFamilyName;

  @override
  State<FamilyBookConfigPage> createState() => _FamilyBookConfigPageState();
}

class _FamilyBookConfigPageState extends State<FamilyBookConfigPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ── Phả Ký (Book Config) ──
  late final FamilyBookConfig _config;
  late final TextEditingController _titleController;
  late final TextEditingController _ancestorController;
  late final TextEditingController _addressController;
  late final TextEditingController _compilerController;
  late final TextEditingController _yearController;
  late final TextEditingController _prefaceController;
  late final TextEditingController _rulesController;
  late final TextEditingController _epilogueController;

  // ── Phả Đồ (Poster Config) ──
  late final FamilyTreePosterConfig _posterConfig;
  late final TextEditingController _posterTitleController;
  late final TextEditingController _posterLeftCoupletController;
  late final TextEditingController _posterRightCoupletController;

  int _maxGeneration = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    _config = FamilyBookConfig();
    _posterConfig = FamilyTreePosterConfig();

    // Tìm cụ đời 1 và thế hệ lớn nhất
    MemberEntity? founder;
    for (final m in widget.members) {
      if ((m.generation ?? 1) == 1 && founder == null) {
        founder = m;
      }
      if ((m.generation ?? 1) > _maxGeneration) {
        _maxGeneration = m.generation!;
      }
    }

    String defaultTitle = 'PHẢ KÝ ĐẠI TÔN';
    String defaultPosterTitle = 'PHẢ HỆ ĐỒ ĐẠI TÔN';
    if (widget.initialFamilyName != null &&
        widget.initialFamilyName!.trim().isNotEmpty) {
      final name = widget.initialFamilyName!.trim().toUpperCase();
      defaultTitle =
          name.startsWith('HỌ') ? 'PHẢ KÝ $name' : 'PHẢ KÝ HỌ $name';
      defaultPosterTitle =
          name.startsWith('HỌ') ? 'PHẢ HỆ ĐỒ $name' : 'PHẢ HỆ ĐỒ HỌ $name';
    }

    final founderText = founder != null ? 'Thủy Tổ: ${founder.fullName}' : '';
    final now = DateTime.now();
    final yearText = 'Năm ${now.year} - Lưu hành nội bộ';

    _config.bookTitle = defaultTitle;
    _config.ancestorName = founderText;
    _config.publishYear = yearText;
    _config.endGeneration = _maxGeneration;

    _posterConfig.title = defaultPosterTitle;
    _posterConfig.ancestorName = founderText;
    _posterConfig.publishYear = yearText;
    _posterConfig.endGeneration = _maxGeneration;

    _titleController = TextEditingController(text: defaultTitle);
    _ancestorController = TextEditingController(text: founderText);
    _addressController = TextEditingController(text: _config.originAddress);
    _compilerController = TextEditingController(text: _config.compilerName);
    _yearController = TextEditingController(text: yearText);
    _prefaceController = TextEditingController(text: _config.preface);
    _rulesController = TextEditingController(text: _config.clanRules);
    _epilogueController = TextEditingController(text: _config.epilogue);

    _posterTitleController = TextEditingController(text: defaultPosterTitle);
    _posterLeftCoupletController =
        TextEditingController(text: _posterConfig.leftCouplet);
    _posterRightCoupletController =
        TextEditingController(text: _posterConfig.rightCouplet);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _ancestorController.dispose();
    _addressController.dispose();
    _compilerController.dispose();
    _yearController.dispose();
    _prefaceController.dispose();
    _rulesController.dispose();
    _epilogueController.dispose();

    _posterTitleController.dispose();
    _posterLeftCoupletController.dispose();
    _posterRightCoupletController.dispose();
    super.dispose();
  }

  void _syncConfigValues() {
    // Sync Phả Ký
    _config.bookTitle = _titleController.text.trim();
    _config.ancestorName = _ancestorController.text.trim();
    _config.originAddress = _addressController.text.trim();
    _config.compilerName = _compilerController.text.trim();
    _config.publishYear = _yearController.text.trim();
    _config.preface = _prefaceController.text.trim();
    _config.clanRules = _rulesController.text.trim();
    _config.epilogue = _epilogueController.text.trim();

    // Sync Phả Đồ
    _posterConfig.title = _posterTitleController.text.trim();
    _posterConfig.leftCouplet = _posterLeftCoupletController.text.trim();
    _posterConfig.rightCouplet = _posterRightCoupletController.text.trim();
    _posterConfig.ancestorName = _ancestorController.text.trim();
    _posterConfig.originAddress = _addressController.text.trim();
    _posterConfig.compilerName = _compilerController.text.trim();
    _posterConfig.publishYear = _yearController.text.trim();
  }

  void _goToPreview() {
    _syncConfigValues();
    if (_tabController.index == 0) {
      Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: FamilyBookPreviewPage(
            members: widget.members,
            config: _config,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: FamilyTreePosterPreviewPage(
            members: widget.members,
            config: _posterConfig,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPhaKyTab = _tabController.index == 0;

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.familyBookConfigTitle,
        actions: [
          IconButton(
            tooltip: isPhaKyTab ? 'Xem trước Phả Ký' : 'Xem trước Phả Đồ',
            icon: const Icon(LucideIcons.eye, size: 20),
            onPressed: _goToPreview,
          ),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.primary,
          indicatorWeight: 2.5,
          labelColor: context.primary,
          unselectedLabelColor: context.textSecondary,
          labelStyle: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(
              icon: Icon(LucideIcons.bookOpen, size: 18),
              text: 'Phả Ký (Sách A4)',
            ),
            Tab(
              icon: Icon(LucideIcons.image, size: 18),
              text: 'Phả Đồ (Tranh)',
            ),
          ],
        ),
      ),
      body: AppBackgroundBody(
        child: TabBarView(
          controller: _tabController,
          children: [
            FamilyBookConfigTab(
              config: _config,
              maxGeneration: _maxGeneration,
              titleController: _titleController,
              ancestorController: _ancestorController,
              addressController: _addressController,
              compilerController: _compilerController,
              yearController: _yearController,
              prefaceController: _prefaceController,
              rulesController: _rulesController,
              epilogueController: _epilogueController,
              onConfigChanged: () => setState(() {}),
            ),
            FamilyPosterConfigTab(
              posterConfig: _posterConfig,
              maxGeneration: _maxGeneration,
              posterTitleController: _posterTitleController,
              posterLeftCoupletController: _posterLeftCoupletController,
              posterRightCoupletController: _posterRightCoupletController,
              onConfigChanged: () => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }
}

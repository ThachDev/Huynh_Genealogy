import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import '../../../../features/auth/auth.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_member_form_page.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_link_and_roles_page.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../heritage_map/domain/entities/heritage_place_entity.dart';
import '../../../heritage_map/domain/usecases/get_member_grave.dart';
import '../../../heritage_map/presentation/pages/heritage_place_form_page.dart';
import '../../../heritage_map/presentation/pages/heritage_place_detail_page.dart';
import '../../domain/entities/kinship_result_entity.dart';
import '../../domain/services/kinship_calculator_service.dart';

class FamilyMemberDetailPage extends StatefulWidget {
  const FamilyMemberDetailPage({
    super.key,
    required this.member,
    this.allMembers = const [],
  });
  final MemberEntity member;
  final List<MemberEntity> allMembers;

  @override
  State<FamilyMemberDetailPage> createState() => _FamilyMemberDetailPageState();
}

class _FamilyMemberDetailPageState extends State<FamilyMemberDetailPage> {
  final _boundaryKey = GlobalKey();
  bool _isSharing = false;
  HeritagePlaceEntity? _gravePlace;

  @override
  void initState() {
    super.initState();
    _loadGraveInfo();
  }

  Future<void> _loadGraveInfo() async {
    if (!widget.member.isAlive) {
      final familyId = widget.member.familyId ?? 1;
      final result = await sl<GetMemberGrave>()(
        GetMemberGraveParams(familyId: familyId, memberId: widget.member.id),
      );
      if (mounted) {
        result.fold((_) => null, (grave) {
          setState(() => _gravePlace = grave);
        });
      }
    }
  }

  Future<void> _sharePage(BuildContext context, AppLocalizations l10n) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final sanitizedName =
          widget.member.fullName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
      final fileName =
          'thanh_vien_${sanitizedName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: '${widget.member.fullName} - ${l10n.memberDetailTitle}',
      );
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.error(context, l10n.qrSaveError);
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final isAdminMode = UserMainNavigationPage.adminModeNotifier.value;
    final canEdit = isAdminMode &&
        authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');

    // Tìm member node đại diện cho user hiện tại đã liên kết
    final myMember = (authState is Authenticated)
        ? (widget.allMembers
                .where((m) => m.id == authState.user.memberId)
                .firstOrNull ??
            widget.allMembers
                .where((m) =>
                    m.linkedUserEmail != null &&
                    m.linkedUserEmail == authState.user.email)
                .firstOrNull ??
            widget.allMembers.where((m) => m.isLinked).firstOrNull)
        : null;

    KinshipResultEntity? kinshipResult;
    if (myMember != null && widget.allMembers.isNotEmpty) {
      try {
        kinshipResult = KinshipCalculatorService().calculate(
          fromMember: myMember,
          toMember: widget.member,
          allMembers: widget.allMembers,
        );
      } catch (_) {}
    }

    // Lấy thông tin gia đình
    final parentNode = widget.allMembers
        .where((m) => m.id == widget.member.parentId)
        .firstOrNull;
    final spouseNode = (parentNode != null && parentNode.spouseId != null)
        ? widget.allMembers
            .where((m) => m.id == parentNode.spouseId)
            .firstOrNull
        : null;

    MemberEntity? father;
    MemberEntity? mother;

    if (parentNode != null) {
      if (parentNode.gender == Gender.female) {
        mother = parentNode;
        father = spouseNode;
      } else {
        father = parentNode;
        mother = spouseNode;
      }
    }

    if (mother == null && widget.member.motherId != null) {
      mother = widget.allMembers
          .where((m) => m.id == widget.member.motherId)
          .firstOrNull;
    }

    final spouse = widget.allMembers
        .where((m) => m.id == widget.member.spouseId)
        .firstOrNull;

    return Scaffold(
        backgroundColor: context.background,
        appBar: AppAppBar(
          title: l10n.memberDetailTitle,
          actions: [
            IconButton(
              icon: Icon(LucideIcons.share2, color: context.textPrimary),
              tooltip: l10n.shareLabel,
              onPressed: _isSharing ? null : () => _sharePage(context, l10n),
            ),
            if (canEdit) ...[
              IconButton(
                icon: Icon(LucideIcons.link2, color: context.textPrimary),
                tooltip: l10n.linkAccountsLabel,
                onPressed: () {
                  Navigator.push(
                    context,
                    SereneFadeSlidePageRoute(
                      page: AdminLinkAndRolesPage(
                        memberId: widget.member.id,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(LucideIcons.edit3, color: context.textPrimary),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    SereneFadeSlidePageRoute(
                      page: AdminMemberFormPage(
                        memberId: widget.member.id,
                      ),
                    ),
                  );
                  if (result == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
          ],
        ),
        body: RepaintBoundary(
          key: _boundaryKey,
          child: AppBackgroundBody(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // ── Khối thông tin gộp chung ──
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 48), // Chừa chỗ cho avatar nổi lên
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 64, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Họ và tên + (Xưng hô)
                          Center(
                            child: Column(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: widget.member.fullName.toUpperCase(),
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: context.primary,
                                      letterSpacing: 0.8,
                                    ),
                                    children: [
                                      if (kinshipResult != null &&
                                          kinshipResult.fromCallsTo.isNotEmpty &&
                                          kinshipResult.fromCallsTo !=
                                              KinshipCalculatorService.unknownRelation)
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.top,
                                          child: Transform.translate(
                                            offset: const Offset(3, -5),
                                            child: Text(
                                              kinshipResult.isSamePerson
                                                  ? l10n.selfRelationTag
                                                  : '(${kinshipResult.fromCallsTo})',
                                              style: GoogleFonts.beVietnamPro(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: context.accent,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (widget.member.linkedUserEmail != null &&
                                    widget.member.linkedUserEmail!
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.mail,
                                        size: 13,
                                        color: context.textSecondary,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.member.linkedUserEmail!,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: context.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildBadge(
                                      l10n.generationLabel(
                                          '${widget.member.generation ?? "?"}'),
                                      context.accent,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildBadge(
                                      widget.member.isAlive
                                          ? l10n.aliveLabel
                                          : l10n.deceasedLabel,
                                      widget.member.isAlive
                                          ? Colors.green
                                          : context.textSecondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // Section 1: Thông tin cá nhân
                          _buildSectionHeader(l10n.personalInfoSectionTitle),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            LucideIcons.cake,
                            l10n.dateOfBirthLabel,
                            DateFormatter.formatForDisplay(
                                    widget.member.dateOfBirth) ??
                                l10n.unknownLabel,
                          ),
                          if (!widget.member.isAlive)
                            _buildInfoRow(
                              LucideIcons.skull,
                              l10n.dateOfDeathLabel,
                              DateFormatter.formatForDisplay(
                                      widget.member.dateOfDeath) ??
                                  l10n.unknownLabel,
                            ),
                          _buildInfoRow(
                            LucideIcons.user,
                            l10n.genderLabel,
                            widget.member.gender == Gender.male
                                ? l10n.genderMale
                                : l10n.genderFemale,
                          ),
                          _buildInfoRow(
                            LucideIcons.mapPin,
                            l10n.placeOfBirthLabel,
                            (widget.member.placeOfBirth?.isNotEmpty == true)
                                ? widget.member.placeOfBirth!
                                : l10n.unknownLabel,
                          ),
                          _buildInfoRow(
                            LucideIcons.phone,
                            l10n.phoneLabel,
                            (widget.member.phone?.isNotEmpty == true)
                                ? widget.member.phone!
                                : l10n.unknownLabel,
                          ),
                          _buildInfoRow(
                            LucideIcons.heart,
                            l10n.maritalStatusShortLabel,
                            _getMaritalStatusText(
                                widget.member.maritalStatus, l10n),
                          ),
                          _buildInfoRow(
                            LucideIcons.bookOpen,
                            l10n.educationLabel,
                            (widget.member.education?.isNotEmpty == true)
                                ? widget.member.education!
                                : l10n.unknownLabel,
                          ),
                          _buildInfoRow(
                            LucideIcons.briefcase,
                            l10n.occupationLabel,
                            (widget.member.occupation?.isNotEmpty == true)
                                ? widget.member.occupation!
                                : l10n.unknownLabel,
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // Section 2: Quan hệ gia đình
                          _buildSectionHeader(l10n.familyRelationSectionTitle),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            LucideIcons.user,
                            l10n.fatherLabel,
                            father?.fullName ?? l10n.unknownLabel,
                          ),
                          _buildInfoRow(
                            LucideIcons.user,
                            l10n.motherLabel,
                            mother?.fullName ?? l10n.unknownLabel,
                          ),
                          _buildInfoRow(
                            LucideIcons.heart,
                            l10n.spouseLabel,
                            spouse?.fullName ?? l10n.unknownLabel,
                          ),
                          _buildInfoRow(
                            LucideIcons.gitCommit,
                            l10n.branchLabel,
                            (widget.member.branchName?.isNotEmpty == true)
                                ? widget.member.branchName!
                                : l10n.unknownLabel,
                          ),
                          // Section 3: Vị trí Mộ phần & Dẫn đường (Dành cho thành viên đã khuất)
                          if (!widget.member.isAlive) ...[
                            _buildSectionHeader('Vị trí Mộ phần'),
                            const SizedBox(height: 10),
                            if (_gravePlace != null)
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: context.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.amber.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(LucideIcons.flame, color: Colors.amber, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _gravePlace!.name,
                                            style: GoogleFonts.beVietnamPro(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: context.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_gravePlace!.landmarkGuide != null &&
                                        _gravePlace!.landmarkGuide!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Mốc nhận diện: ${_gravePlace!.landmarkGuide}',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          fontStyle: FontStyle.italic,
                                          color: context.textSecondary,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            icon: const Icon(LucideIcons.map, size: 15),
                                            label: Text(
                                              'Xem trên Bản đồ',
                                              style: GoogleFonts.beVietnamPro(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: context.primary,
                                              side: BorderSide(color: context.primary),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                SereneFadeSlidePageRoute(
                                                  page: HeritagePlaceDetailPage(place: _gravePlace!),
                                                ),
                                              ).then((_) => _loadGraveInfo());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            else if (canEdit)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: context.surface.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: context.accent.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Chưa có dữ liệu vị trí mộ phần của cụ',
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12.5,
                                        color: context.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    OutlinedButton.icon(
                                      icon: const Icon(LucideIcons.plus, size: 14),
                                      label: Text(
                                        'Gắn vị trí mộ trên Bản đồ',
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: context.primary,
                                        side: BorderSide(color: context.primary.withValues(alpha: 0.5)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          SereneFadeSlidePageRoute(
                                            page: HeritagePlaceFormPage(
                                              familyId: widget.member.familyId ?? 1,
                                              initialMemberId: widget.member.id,
                                              initialMemberName: widget.member.fullName,
                                              initialGeneration: widget.member.generation,
                                            ),
                                          ),
                                        ).then((_) => _loadGraveInfo());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 24),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                          ],

                          // Section 4: Tiểu sử
                          _buildSectionHeader(l10n.biographySectionTitle),
                          const SizedBox(height: 12),
                          Text(
                            widget.member.notes != null &&
                                    widget.member.notes!.isNotEmpty
                                ? widget.member.notes!
                                : l10n.noBiographyMessage,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Avatar nổi ở mép trên ──
                  Positioned(
                    top: 0,
                    child: AppAvatar(
                      avatarUrl: widget.member.avatarUrl,
                      fullName: widget.member.fullName,
                      radius: 48,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.beVietnamPro(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.primary,
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.accent),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getMaritalStatusText(MaritalStatus status, AppLocalizations l10n) {
    switch (status) {
      case MaritalStatus.single:
        return l10n.maritalSingle;
      case MaritalStatus.married:
        return l10n.maritalMarried;
      case MaritalStatus.divorced:
        return l10n.maritalDivorcedStatus;
      case MaritalStatus.widowed:
        return l10n.maritalWidowedShort;
      case MaritalStatus.unknown:
        return l10n.unknownLabel;
    }
  }
}

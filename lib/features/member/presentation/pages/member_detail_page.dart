import 'dart:ui';
import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/features/tree/presentation/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/member/presentation/bloc/member_bloc.dart';
import 'package:app_family_tree/features/member/presentation/widgets/add_member_dialog.dart';
import 'package:app_family_tree/features/member/presentation/widgets/member_detail_skeleton.dart';
import 'package:app_family_tree/components/dialog/delete_confirm_dialog.dart';
import 'package:app_family_tree/components/background/app_background.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:resources/resources.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class MemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const MemberDetailPage({super.key, required this.member});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MemberBloc>(create: (context) => di.sl<MemberBloc>()),
      ],
      child: BlocListener<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberSuccess && state.isDeleted) {
            context.read<TreeBloc>().add(LoadTreeEvent(force: true));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).deleteMemberSuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is MemberError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TreeBloc, TreeState>(
          builder: (context, state) {
            final member = state is TreeLoaded
                ? state.allMembers.firstWhere(
                    (m) => m.id == widget.member.id,
                    orElse: () => widget.member,
                  )
                : widget.member;

            return Scaffold(
              backgroundColor: AppColors.parchment,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: AppBackground(animation: _bgAnimation),
                  ),
                  if (state is TreeLoading || state is TreeInitial)
                    const MemberDetailSkeleton()
                  else
                    CustomScrollView(
                      slivers: [
                        _buildSliverAppBar(context, member),
                        SliverToBoxAdapter(
                          child: AnimationConfiguration.synchronized(
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildDetailCards(context, member),
                                      const SizedBox(height: 32),
                                      _buildDeleteButton(context, member),
                                      const SizedBox(height: 48),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, MemberEntity member) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.wood,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: AppColors.gold,
                size: 24,
              ),
            ),
            onPressed: () {
              final treeBloc = context.read<TreeBloc>();
              showDialog(
                context: context,
                barrierColor: Colors.black.withValues(alpha: 0.6),
                builder: (ctx) => MultiBlocProvider(
                  providers: [
                    BlocProvider<MemberBloc>(
                      create: (_) => di.sl<MemberBloc>(),
                    ),
                    BlocProvider.value(value: treeBloc),
                  ],
                  child: AddMemberDialog(memberToEdit: member),
                ),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        title: Text(
          member.fullName.toUpperCase(),
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black45, blurRadius: 4)],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/wood_dragon.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (member.fullAvatarUrl != null) {
                      _showImagePreview(context, member.fullAvatarUrl!);
                    }
                  },
                  child: Hero(
                    tag: 'member_avatar_${member.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.transparent, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.transparent.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: member.gender == Gender.male
                            ? AppColors.nodeMale
                            : AppColors.nodeFemale,
                        backgroundImage: member.fullAvatarUrl != null
                            ? CachedNetworkImageProvider(member.fullAvatarUrl!)
                            : null,
                        child: member.fullAvatarUrl == null
                            ? Icon(
                                member.gender == Gender.male
                                    ? Icons.man
                                    : Icons.woman,
                                size: 65,
                                color: AppColors.crimson.withValues(alpha: 0.5),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 240,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    S
                        .of(context)
                        .generationLabelShort(
                          member.generation?.toString() ?? "?",
                        ),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCards(BuildContext context, MemberEntity member) {
    bool isNotEmpty(String? s) => s != null && s.trim().isNotEmpty;

    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.trim().isEmpty) return '';
      try {
        final dt = DateTime.parse(dateStr);
        return DateFormat('dd/MM/yyyy').format(dt);
      } catch (_) {
        return dateStr;
      }
    }

    String formatGender(Gender g) {
      switch (g) {
        case Gender.male:
          return S.of(context).male;
        case Gender.female:
          return S.of(context).female;
        default:
          return '';
      }
    }

    String formatMarital(MaritalStatus s) {
      switch (s) {
        case MaritalStatus.single:
          return S.of(context).maritalSingle;
        case MaritalStatus.married:
          return S.of(context).maritalMarried;
        case MaritalStatus.divorced:
          return S.of(context).maritalDivorced;
        case MaritalStatus.widowed:
          return S.of(context).maritalWidowed;
        default:
          return '';
      }
    }

    IconData getMaritalIcon(MaritalStatus s) {
      switch (s) {
        case MaritalStatus.single:
          return Icons.person_outline;
        case MaritalStatus.married:
          return Icons.favorite;
        case MaritalStatus.divorced:
          return Icons.heart_broken;
        case MaritalStatus.widowed:
          return Icons.eco;
        default:
          return Icons.favorite_border;
      }
    }

    final personalRows = <Widget>[];
    final familyRows = <Widget>[];

    void addRow(
      List<Widget> dest,
      IconData icon,
      String label,
      String value,
      Color color,
    ) {
      if (value.trim().isNotEmpty) {
        dest.add(_buildInfoRow(icon, label, value, color));
      }
    }

    final genderStr = formatGender(member.gender);
    if (genderStr.isNotEmpty) {
      addRow(
        personalRows,
        member.gender == Gender.male ? Icons.male : Icons.female,
        S.of(context).genderLabel,
        genderStr,
        member.gender == Gender.male
            ? const Color(0xFF1976D2)
            : const Color(0xFFC2185B),
      );
    }

    final dob = formatDate(member.dateOfBirth);
    if (dob.isNotEmpty) {
      addRow(
        personalRows,
        Icons.cake_outlined,
        S.of(context).dobLabel,
        dob,
        const Color(0xFF42A5F5),
      );
    }

    if (isNotEmpty(member.placeOfBirth)) {
      addRow(
        personalRows,
        Icons.place_outlined,
        S.of(context).birthPlaceLabel,
        member.placeOfBirth!,
        const Color(0xFF4CAF50),
      );
    }

    final marital = formatMarital(member.maritalStatus);
    if (marital.isNotEmpty) {
      addRow(
        personalRows,
        getMaritalIcon(member.maritalStatus),
        S.of(context).maritalStatusLabel,
        marital,
        const Color(0xFF9C27B0),
      );
    }

    if (isNotEmpty(member.branchName)) {
      addRow(
        familyRows,
        Icons.account_tree_outlined,
        S.of(context).branch,
        member.branchName!,
        const Color(0xFFFF9800),
      );
    }

    addRow(
      familyRows,
      member.isAlive ? Icons.favorite : Icons.local_florist,
      S.of(context).legend,
      member.isAlive ? S.of(context).stillAlive : S.of(context).deceased,
      member.isAlive ? const Color(0xFF4CAF50) : AppColors.nodeDeceased,
    );

    if (!member.isAlive) {
      final dod = formatDate(member.dateOfDeath);
      if (dod.isNotEmpty) {
        addRow(
          familyRows,
          Icons.event_available,
          S.of(context).dodLabel,
          dod,
          const Color(0xFF607D8B),
        );
      }
    }

    if (isNotEmpty(member.notes)) {
      addRow(
        familyRows,
        Icons.notes_outlined,
        S.of(context).notesLabel,
        member.notes!,
        AppColors.textSecondary,
      );
    }

    return Column(
      children: [
        if (personalRows.isNotEmpty)
          _buildGlassSection('Thông tin cá nhân', personalRows),
        if (personalRows.isNotEmpty && familyRows.isNotEmpty)
          const SizedBox(height: 24),
        if (familyRows.isNotEmpty)
          _buildGlassSection('Gia phả & Liên kết', familyRows),
      ],
    );
  }

  Widget _buildGlassSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    final formattedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      formattedChildren.add(children[i]);
      if (i < children.length - 1) {
        formattedChildren.add(
          Divider(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.crimson,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(children: formattedChildren),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, MemberEntity member) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        return OutlinedButton.icon(
          onPressed: state is MemberLoading
              ? null
              : () async {
                  final confirm = await showDeleteConfirmDialog(
                    context: context,
                    title: S.of(context).confirmDelete,
                    content: S
                        .of(context)
                        .confirmDeleteContent(member.fullName),
                  );
                  if (confirm == true && context.mounted) {
                    context.read<MemberBloc>().add(
                      DeleteMemberEvent(member.id),
                    );
                  }
                },
          icon: state is MemberLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.crimson,
                  ),
                )
              : const Icon(Icons.delete_outline, color: AppColors.crimson),
          label: Text(
            S.of(context).deleteMemberButton,
            style: GoogleFonts.inter(
              color: AppColors.crimson,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white.withValues(alpha: 0.5),
            side: const BorderSide(color: AppColors.crimson, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white, size: 20),
                onPressed: () async {
                  try {
                    var status = await Permission.storage.request();
                    if (!status.isGranted) {
                      status = await Permission.photos.request();
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đang xử lý tải ảnh...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                    final response = await Dio().get(
                      imageUrl,
                      options: Options(responseType: ResponseType.bytes),
                    );
                    final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                      quality: 100,
                      name: "avatar_${DateTime.now().millisecondsSinceEpoch}",
                    );
                    if (result != null && result['isSuccess'] == true) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lưu ảnh thành công vào thư viện!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Tải ảnh thất bại! Hãy cấp quyền truy cập bộ sưu tập.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi tải ảnh: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(ctx),
            ),
          ),
          body: PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: const PhotoViewHeroAttributes(
              tag: "member_avatar_preview",
            ),
          ),
        ),
      ),
    );
  }
}

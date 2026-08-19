import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../events/events.dart';

/// Card sự kiện phong cách Facebook / Bản tin Gia Tộc (Clan Feed).
/// Bao gồm:
/// - Header Crimson: Avatar chữ cái + Tên tác giả + Ngày/Âm lịch + Địa điểm
/// - Nội dung: Tiêu đề + Nội dung bài viết đầy đủ
/// - Banner Ảnh sắc nét, hiển thị trọn vẹn (có thể chạm để xem ảnh lớn)
/// - Footer Tương tác: Thích / Tim, Bình luận (Bottom Sheet), Chia sẻ thẻ ảnh (Card Snapshot Share)
class UserEventCard extends StatefulWidget {

  const UserEventCard({
    super.key,
    required this.event,
    required this.familyId,
    this.isAdminMode = false,
    this.onTap,
    this.onChanged,
    this.tappable = true,
    this.heroTag = '',
  });
  final EventEntity event;
  final int familyId;
  final bool isAdminMode;
  final VoidCallback? onTap;
  final VoidCallback? onChanged;
  final bool tappable;
  final String? heroTag;

  @override
  State<UserEventCard> createState() => _UserEventCardState();
}

class _UserEventCardState extends State<UserEventCard> {
  final GlobalKey _cardKey = GlobalKey();
  late final EventApiService _apiService;
  bool _isSharing = false;
  late bool _isLiked;
  late int _likeCount;
  bool _isExpanded = false;
  final List<EventInteractionModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _apiService = di.sl<EventApiService>();
    _isLiked = widget.event.isReacted;
    _likeCount = widget.event.reactionCount;
    _loadComments();
  }

  @override
  void didUpdateWidget(covariant UserEventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.id != widget.event.id ||
        oldWidget.event.isReacted != widget.event.isReacted ||
        oldWidget.event.reactionCount != widget.event.reactionCount) {
      _isLiked = widget.event.isReacted;
      _likeCount = widget.event.reactionCount;
    }
  }

  Future<void> _loadComments() async {
    final comments = await _apiService.getComments(widget.event.id);
    if (mounted) {
      setState(() {
        _comments.clear();
        _comments.addAll(comments);
      });
    }
  }

  void _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
      if (_likeCount < 0) _likeCount = 0;
    });

    final res = await _apiService.reactToEvent(widget.event.id);
    if (res != null && mounted) {
      setState(() {
        if (res['reactionCount'] != null) {
          _likeCount = (res['reactionCount'] as num).toInt();
        }
        if (res['reacted'] != null) {
          _isLiked = res['reacted'] as bool;
        }
      });
    }
  }

  Future<void> _shareEvent() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final file = await File(
                  '${tempDir.path}/su_kien_${widget.event.id}_${DateTime.now().millisecondsSinceEpoch}.png')
              .create();
          await file.writeAsBytes(pngBytes);

          // Chỉ gửi thuần file ảnh, không kèm bất kỳ đoạn text nào
          await Share.shareXFiles(
            [XFile(file.path, mimeType: 'image/png')],
          );
          if (mounted) setState(() => _isSharing = false);
          return;
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  void _showCommentsModal(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final l10n = AppLocalizations.of(ctx);
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.65,
                  child: Column(
                    children: [
                      // Header Modal
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ctx.textSecondary.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              l10n.commentsCountLabel(_comments.length),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ctx.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(LucideIcons.x, size: 20),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                      ),

                      // Danh sách bình luận
                      Expanded(
                        child: _comments.isEmpty
                            ? Center(
                                child: AppEmptyState(
                                  icon: LucideIcons.messageSquare,
                                  iconSize: 48,
                                  message: l10n.noCommentsMessage,
                                  subMessage: l10n.beFirstCommentMessage,
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(14),
                                itemCount: _comments.length,
                                itemBuilder: (c, i) {
                                  final item = _comments[i];
                                  final author = item.authorName.isNotEmpty
                                      ? item.authorName
                                      : l10n.anonymousLabel;
                                  final text = item.content;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: ctx.primary
                                              .withValues(alpha: 0.1),
                                          child: Text(
                                            author.isNotEmpty
                                                ? author[0].toUpperCase()
                                                : 'M',
                                            style: GoogleFonts.beVietnamPro(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: ctx.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: ctx.textSecondary
                                                  .withValues(alpha: 0.06),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  author,
                                                  style:
                                                      GoogleFonts.beVietnamPro(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: ctx.textPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  text,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    color: ctx.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Input bình luận
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: ctx.surface,
                          border: Border(
                            top: BorderSide(
                              color: ctx.textSecondary.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: l10n.writeCommentHint,
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: ctx.textSecondary,
                                  ),
                                  filled: true,
                                  fillColor:
                                      ctx.textSecondary.withValues(alpha: 0.08),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(LucideIcons.send,
                                  color: ctx.primary, size: 20),
                              onPressed: () async {
                                final text = controller.text.trim();
                                if (text.isNotEmpty) {
                                  controller.clear();
                                  final newComment = await _apiService
                                      .createComment(widget.event.id, text);
                                  if (newComment != null) {
                                    setModalState(() {
                                      _comments.add(newComment);
                                    });
                                    setState(() {});
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl, bool isNetwork) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isNetwork
                        ? AppNetworkImage(url: imageUrl, fit: BoxFit.contain)
                        : Image.file(File(imageUrl), fit: BoxFit.contain),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final event = widget.event;

    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    final organizerName =
        (event.organizer != null && event.organizer!.trim().isNotEmpty)
            ? event.organizer!.trim()
            : l10n.adminBoard;

    final displayContent = (event.content != null &&
            event.content!.trim().isNotEmpty)
        ? event.content!.trim()
        : (event.description != null && event.description!.trim().isNotEmpty)
            ? event.description!.trim()
            : null;

    Widget imageWidget = const SizedBox.shrink();
    if (hasImage) {
      imageWidget = GestureDetector(
        onTap: () => _showImageDialog(context, imageUrl, isNetworkImage),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
          ),
          child: isNetworkImage
              ? AppNetworkImage(
                  url: imageUrl,
                  width: double.infinity,
                )
              : Image.file(
                  File(imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  filterQuality: FilterQuality.high,
                ),
        ),
      );

      if (widget.heroTag != null && widget.heroTag!.isNotEmpty) {
        imageWidget = Hero(tag: widget.heroTag!, child: imageWidget);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: context.textSecondary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Phần nội dung được chụp khi bấm Chia sẻ (RepaintBoundary) ──
          RepaintBoundary(
            key: _cardKey,
            child: Container(
              color: context.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Post Header: Nền Crimson đỏ sẫm đồng bộ hệ thống ──
                  Container(
                    color: context.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            organizerName.trim().isNotEmpty
                                ? organizerName.trim()[0].toUpperCase()
                                : 'G',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                organizerName,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                event.eventDate +
                                    (event.isLunar
                                        ? ' (${l10n.lunarShortLabel})'
                                        : ''),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (event.location != null &&
                            event.location!.trim().isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.mapPin,
                                  size: 11,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 100),
                                  child: Text(
                                    event.location!.trim(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── 2. Nội dung sự kiện: Tiêu đề + Mô tả tóm tắt (maxLines: 2 + Xem thêm) ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: context.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        if (displayContent != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            displayContent,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color:
                                  context.textPrimary.withValues(alpha: 0.85),
                              height: 1.45,
                            ),
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          if (displayContent.length > 80 ||
                              displayContent.contains('\n')) ...[
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Text(
                                _isExpanded
                                    ? l10n.collapseLabel
                                    : l10n.viewMoreLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),

                  // ── 3. Ảnh sự kiện (Hiển thị trọn vẹn, chạm để zoom xem ảnh lớn) ──
                  if (hasImage) imageWidget,
                ],
              ),
            ),
          ),

          // ── 4. Thanh tương tác Facebook Feed: Thích, Bình luận, Chia sẻ (Nằm ngoài ảnh chụp) ──
          Divider(
            height: 1,
            thickness: 0.5,
            color: context.textSecondary.withValues(alpha: 0.12),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Nút Thích
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? LucideIcons.heart : LucideIcons.heart,
                          size: 18,
                          color: _isLiked
                              ? context.primary
                              : context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _likeCount > 0
                              ? l10n.likeCountLabel(_likeCount)
                              : l10n.likeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight:
                                _isLiked ? FontWeight.bold : FontWeight.w500,
                            color: _isLiked
                                ? context.primary
                                : context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Nút Bình luận
                InkWell(
                  onTap: () => _showCommentsModal(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.messageSquare,
                          size: 18,
                          color: context.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _comments.isNotEmpty
                              ? l10n.commentsCountLabel(_comments.length)
                              : (widget.event.commentCount > 0
                                  ? l10n
                                      .commentsCountLabel(widget.event.commentCount)
                                  : l10n.commentLabel),
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Nút Chia sẻ
                InkWell(
                  onTap: _shareEvent,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        _isSharing
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: context.primary,
                                ),
                              )
                            : Icon(
                                LucideIcons.share2,
                                size: 18,
                                color: context.textSecondary,
                              ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.shareLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
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
}

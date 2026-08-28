import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/heritage_place_entity.dart';
import '../../domain/usecases/delete_heritage_place.dart';
import '../../domain/usecases/get_heritage_places.dart';
import '../../domain/usecases/save_heritage_place.dart';
import '../bloc/heritage_map_bloc.dart';
import '../bloc/heritage_map_event.dart';
import 'heritage_place_form_page.dart';

class HeritagePlaceDetailPage extends StatelessWidget {
  const HeritagePlaceDetailPage({super.key, required this.place});
  final HeritagePlaceEntity place;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeritageMapBloc(
        getHeritagePlaces: sl<GetHeritagePlaces>(),
        saveHeritagePlace: sl<SaveHeritagePlace>(),
        deleteHeritagePlace: sl<DeleteHeritagePlace>(),
      ),
      child: _HeritagePlaceDetailView(place: place),
    );
  }
}

class _HeritagePlaceDetailView extends StatefulWidget {
  const _HeritagePlaceDetailView({required this.place});
  final HeritagePlaceEntity place;

  @override
  State<_HeritagePlaceDetailView> createState() =>
      _HeritagePlaceDetailViewState();
}

class _HeritagePlaceDetailViewState extends State<_HeritagePlaceDetailView> {
  late HeritagePlaceEntity _currentPlace;

  @override
  void initState() {
    super.initState();
    _currentPlace = widget.place;
  }

  Future<void> _openGoogleMapsDirections() async {
    final lat = _currentPlace.latitude;
    final lng = _currentPlace.longitude;
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = Uri.parse(
            'geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(_currentPlace.name)})');
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.error(context, 'Không thể mở ứng dụng bản đồ dẫn đường');
      }
    }
  }

  void _copyCoordinates() {
    Clipboard.setData(
      ClipboardData(
          text: '${_currentPlace.latitude}, ${_currentPlace.longitude}'),
    );
    AppSnackBar.info(context, 'Đã sao chép tọa độ GPS vào bộ nhớ tạm');
  }

  void _onEditPlace() {
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: HeritagePlaceFormPage(
          familyId: _currentPlace.familyId,
          placeToEdit: _currentPlace,
        ),
      ),
    ).then((result) {
      if (result is HeritagePlaceEntity) {
        setState(() {
          _currentPlace = result;
        });
      }
    });
  }

  Future<void> _onDeletePlace() async {
    final confirm = await AppDialog.confirm(
      context,
      title: 'Xóa địa điểm này?',
      message:
          'Bạn có chắc chắn muốn xóa thông tin "${_currentPlace.name}" khỏi bản đồ dòng họ?',
      confirmLabel: 'Xóa',
      type: AppDialogType.danger,
    );

    if (confirm == true && mounted) {
      context.read<HeritageMapBloc>().add(
            HeritageMapDeletePlaceEvent(
              familyId: _currentPlace.familyId,
              placeId: _currentPlace.id,
            ),
          );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;

    final typeInfo = _getTypeInfo(_currentPlace.type);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: 'Chi tiết Địa điểm',
        actions: [
          if (canEdit) ...[
            IconButton(
              icon: Icon(LucideIcons.edit3, color: context.textPrimary),
              tooltip: 'Chỉnh sửa',
              onPressed: _onEditPlace,
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
              tooltip: 'Xóa địa điểm',
              onPressed: _onDeletePlace,
            ),
          ],
        ],
      ),
      body: AppBackgroundBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Album ảnh / Thumbnail Hero
              if (_currentPlace.imageUrls.isNotEmpty)
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _currentPlace.imageUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, idx) {
                      final url = _currentPlace.imageUrls[idx];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          height: 220,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 260,
                            color: context.surface,
                            child: const Center(child: AppLoading(size: 40)),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 260,
                            color: context.surface,
                            child: Icon(LucideIcons.image,
                                size: 40, color: context.textSecondary),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              // 2. Phân loại & Thế hệ (Sử dụng AppBadge của hệ thống)
              Row(
                children: [
                  AppBadge(
                    label: typeInfo.label,
                    color: typeInfo.color,
                  ),
                  if (_currentPlace.generation != null) ...[
                    const SizedBox(width: 8),
                    AppBadge(
                      label: 'Đời thứ ${_currentPlace.generation}',
                      color: context.accent,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),

              // Tên địa điểm
              Text(
                _currentPlace.name,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),

              // 3. Nút Dẫn đường lớn nổi bật (Dùng AppButton của hệ thống)
              AppButton(
                label: 'Bắt đầu Chỉ đường (Google Maps)',
                prefixIcon: const Icon(LucideIcons.navigation,
                    color: Colors.white, size: 18),
                size: AppButtonSize.large,
                fullWidth: true,
                onPressed: _openGoogleMapsDirections,
              ),

              const SizedBox(height: 24),

              // 4. Chỉ dẫn mốc thực địa (Landmark Guidance)
              if (_currentPlace.landmarkGuide != null &&
                  _currentPlace.landmarkGuide!.isNotEmpty) ...[
                const AppSectionHeader(
                  title: 'Chỉ dẫn mốc thực địa',
                  description:
                      'Mô tả chi tiết nhận diện xung quanh (dân dã, dễ tìm khi về làng quê)',
                  titleSize: 16,
                  indicatorHeight: 16,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(LucideIcons.compass,
                          size: 20, color: context.accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _currentPlace.landmarkGuide!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.55,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 5. Thẻ Tọa độ GPS & Địa chỉ
              const AppSectionHeader(
                title: 'Thông tin Vị trí',
                titleSize: 16,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.resolve(
                      Colors.black.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: LucideIcons.mapPin,
                      title: 'Địa chỉ hành chính',
                      value: _currentPlace.address ??
                          'Chưa cập nhật địa chỉ cụ thể',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      icon: LucideIcons.crosshair,
                      title: 'Tọa độ GPS',
                      value:
                          '${_currentPlace.latitude.toStringAsFixed(6)}, ${_currentPlace.longitude.toStringAsFixed(6)}',
                      trailing: IconButton(
                        icon: Icon(LucideIcons.copy,
                            size: 16, color: context.accent),
                        tooltip: 'Sao chép tọa độ',
                        onPressed: _copyCoordinates,
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Mô tả / Tiểu sử di tích (nếu có)
              if (_currentPlace.description != null &&
                  _currentPlace.description!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const AppSectionHeader(
                  title: 'Mô tả & Lịch sử',
                  titleSize: 16,
                  indicatorHeight: 16,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.resolve(
                        Colors.black.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Text(
                    _currentPlace.description!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.6,
                      color: context.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _TypeInfo _getTypeInfo(HeritagePlaceType type) {
    switch (type) {
      case HeritagePlaceType.ancestralHouse:
        return const _TypeInfo('Nhà thờ họ / Từ đường', Color(0xFFD97706));
      case HeritagePlaceType.patriarchTomb:
        return const _TypeInfo('Lăng mộ tổ', Color(0xFF8B5CF6));
      case HeritagePlaceType.memberGrave:
        return const _TypeInfo('Mộ phần tiền nhân', Color(0xFFE11D48));
      case HeritagePlaceType.shrine:
        return const _TypeInfo('Miếu / Đình dòng họ', Color(0xFF059669));
      case HeritagePlaceType.unknown:
        return const _TypeInfo('Địa điểm', Colors.grey);
    }
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: context.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}

class _TypeInfo {
  const _TypeInfo(this.label, this.color);
  final String label;
  final Color color;
}

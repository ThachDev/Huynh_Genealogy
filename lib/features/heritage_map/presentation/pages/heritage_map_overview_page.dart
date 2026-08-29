import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
import '../bloc/heritage_map_state.dart';
import '../widgets/heritage_place_edit_sheet.dart';
import '../widgets/heritage_place_view_sheet.dart';
import '../widgets/map_view_widget.dart';

class HeritageMapOverviewPage extends StatelessWidget {
  const HeritageMapOverviewPage({
    super.key,
    required this.familyId,
    this.initialPlaceId,
    this.assignGraveForMemberId,
    this.assignGraveForMemberName,
    this.placeToEdit,
  });

  final int familyId;
  final int? initialPlaceId;
  final int? assignGraveForMemberId;
  final String? assignGraveForMemberName;
  final HeritagePlaceEntity? placeToEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeritageMapBloc(
        getHeritagePlaces: sl<GetHeritagePlaces>(),
        saveHeritagePlace: sl<SaveHeritagePlace>(),
        deleteHeritagePlace: sl<DeleteHeritagePlace>(),
      )..add(HeritageMapLoadEvent(familyId: familyId)),
      child: _HeritageMapOverviewView(
        familyId: familyId,
        initialPlaceId: initialPlaceId,
        assignGraveForMemberId: assignGraveForMemberId,
        assignGraveForMemberName: assignGraveForMemberName,
        placeToEdit: placeToEdit,
      ),
    );
  }
}

class _HeritageMapOverviewView extends StatefulWidget {
  const _HeritageMapOverviewView({
    required this.familyId,
    this.initialPlaceId,
    this.assignGraveForMemberId,
    this.assignGraveForMemberName,
    this.placeToEdit,
  });

  final int familyId;
  final int? initialPlaceId;
  final int? assignGraveForMemberId;
  final String? assignGraveForMemberName;
  final HeritagePlaceEntity? placeToEdit;

  @override
  State<_HeritageMapOverviewView> createState() =>
      _HeritageMapOverviewViewState();
}

class _HeritageMapOverviewViewState extends State<_HeritageMapOverviewView> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _landmarkGuideController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _geocodeSearchFocusNode = FocusNode();
  final Dio _dio = Dio();

  HeritagePlaceType? _activeFilterType;
  bool _handledInitialPlace = false;

  // Chế độ ghim / thêm / sửa trực tiếp trên bản đồ
  late bool _isPinningMode;
  late LatLng _pinnedLocation;
  late HeritagePlaceType _pinnedType;
  HeritagePlaceEntity? _editingPlace;
  bool _isLocating = false;
  bool _isGeocodingSearching = false;
  List<_GeocodingItem> _geocodingResults = [];
  Timer? _geocodeDebounce;

  bool get _isAssigningGrave => widget.assignGraveForMemberId != null;
  bool get _isEditing => widget.placeToEdit != null;

  @override
  void initState() {
    super.initState();
    _isPinningMode = _isAssigningGrave || _isEditing;

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        final currentSelected = context.read<HeritageMapBloc>().state;
        if (currentSelected is HeritageMapLoaded &&
            currentSelected.selectedPlace != null) {
          context
              .read<HeritageMapBloc>()
              .add(const HeritageMapSelectPlaceEvent(null));
        }
      }
    });

    _geocodeSearchFocusNode.addListener(() {
      setState(() {});
    });

    if (_isEditing) {
      final p = widget.placeToEdit!;
      _editingPlace = p;
      _pinnedLocation = LatLng(p.latitude, p.longitude);
      _landmarkGuideController.text = p.landmarkGuide ?? '';
      _pinnedType = p.type;
    } else if (_isAssigningGrave) {
      _pinnedLocation = const LatLng(21.028511, 105.854444);
      _pinnedType = HeritagePlaceType.memberGrave;
    } else {
      _pinnedLocation = const LatLng(21.028511, 105.854444);
      _pinnedType = HeritagePlaceType.ancestralHouse;
    }

    _fetchUserLocation();
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _searchController.dispose();
    _landmarkGuideController.dispose();
    _searchFocusNode.dispose();
    _geocodeSearchFocusNode.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position? pos;
        try {
          pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 6),
          );
        } catch (_) {
          pos = await Geolocator.getLastKnownPosition();
        }

        if (pos != null && mounted) {
          final loc = LatLng(pos.latitude, pos.longitude);
          context.read<HeritageMapBloc>().add(
                HeritageMapUpdateUserLocationEvent(
                  latitude: pos.latitude,
                  longitude: pos.longitude,
                ),
              );
          if (!_isEditing && _pinnedLocation.latitude == 21.028511) {
            setState(() => _pinnedLocation = loc);
            _mapController.move(loc, 16.5);
          }
        }
      }
    } catch (_) {}
  }

  void _onGeocodeSearchChanged(String query) {
    if (_geocodeDebounce?.isActive ?? false) _geocodeDebounce!.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _geocodingResults = [];
        _isGeocodingSearching = false;
      });
      return;
    }

    _geocodeDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchLocation(query.trim());
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    setState(() => _isGeocodingSearching = true);
    try {
      final url =
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&countrycodes=vn';
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'User-Agent': 'GiaTocViet-FamilyApp/1.0'},
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.data is List) {
        final list = (response.data as List).map((item) {
          final lat = double.tryParse(item['lat']?.toString() ?? '0') ?? 0.0;
          final lon = double.tryParse(item['lon']?.toString() ?? '0') ?? 0.0;
          final name = item['display_name']?.toString() ?? '';
          return _GeocodingItem(name: name, location: LatLng(lat, lon));
        }).toList();

        if (mounted) {
          setState(() {
            _geocodingResults = list;
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isGeocodingSearching = false);
    }
  }

  void _selectGeocodeResult(_GeocodingItem item) {
    setState(() {
      _pinnedLocation = item.location;
      _geocodingResults = [];
      _searchController.text = item.name.split(',').take(2).join(',').trim();
    });
    _mapController.move(item.location, 16.5);
    FocusScope.of(context).unfocus();
  }

  Future<void> _getCurrentGpsLocation() async {
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppSnackBar.warning(
              context, 'Vui lòng bật định vị GPS trên thiết bị');
        }
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          if (mounted) AppSnackBar.error(context, 'Chưa cấp quyền vị trí');
          return;
        }
      }

      if (perm == LocationPermission.deniedForever) {
        if (mounted) {
          AppSnackBar.error(context,
              'Quyền vị trí bị tắt trong Cài đặt. Vui lòng mở Cài đặt để bật.');
        }
        return;
      }

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 8),
        );
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }

      if (pos != null && mounted) {
        final newPoint = LatLng(pos.latitude, pos.longitude);
        setState(() => _pinnedLocation = newPoint);
        _mapController.move(newPoint, 17.0);
        context.read<HeritageMapBloc>().add(
              HeritageMapUpdateUserLocationEvent(
                latitude: pos.latitude,
                longitude: pos.longitude,
              ),
            );
        AppSnackBar.info(context, 'Đã lấy vị trí GPS hiện tại');
      } else if (mounted) {
        AppSnackBar.error(context, 'Không thể nhận diện tọa độ GPS');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Lỗi lấy GPS: $e');
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _loadPlaces() {
    context.read<HeritageMapBloc>().add(
          HeritageMapLoadEvent(
            familyId: widget.familyId,
            type: _activeFilterType,
            query: _searchController.text.trim().isNotEmpty
                ? _searchController.text.trim()
                : null,
          ),
        );
  }

  void _flyToPlace(HeritagePlaceEntity place) {
    context.read<HeritageMapBloc>().add(HeritageMapSelectPlaceEvent(place));
    _mapController.move(
      LatLng(place.latitude, place.longitude),
      16.5,
    );
  }

  void _onLocateMePressed(LatLng? userLocation) {
    if (userLocation != null) {
      _mapController.move(userLocation, 16.5);
    } else {
      _fetchUserLocation();
    }
  }

  void _cancelPinningMode() {
    if (_isAssigningGrave || _isEditing) {
      Navigator.pop(context);
    } else {
      setState(() {
        _isPinningMode = false;
        _editingPlace = null;
        _geocodingResults = [];
        _searchController.clear();
      });
      _loadPlaces();
    }
  }

  void _savePinnedPlace() {
    final targetPlace = _editingPlace ?? widget.placeToEdit;
    final isMemberGrave = _isAssigningGrave ||
        (targetPlace != null &&
            (targetPlace.memberId != null ||
                targetPlace.type == HeritagePlaceType.memberGrave));

    final String name;
    if (isMemberGrave) {
      name = targetPlace?.memberFullName ??
          widget.assignGraveForMemberName ??
          targetPlace?.name ??
          'Mộ người thân';
    } else {
      name = targetPlace?.name.isNotEmpty == true
          ? targetPlace!.name
          : _getPlaceTypeName(_pinnedType);
    }

    final entity = HeritagePlaceEntity(
      id: targetPlace?.id ?? 0,
      familyId: widget.familyId,
      memberId: targetPlace?.memberId ?? widget.assignGraveForMemberId,
      name: name,
      type: _pinnedType,
      latitude: _pinnedLocation.latitude,
      longitude: _pinnedLocation.longitude,
      landmarkGuide: _landmarkGuideController.text.trim().isNotEmpty
          ? _landmarkGuideController.text.trim()
          : null,
      imageUrls: targetPlace?.imageUrls ?? [],
    );

    context.read<HeritageMapBloc>().add(HeritageMapSavePlaceEvent(entity));
  }

  String _getPlaceTypeName(HeritagePlaceType type) {
    switch (type) {
      case HeritagePlaceType.ancestralHouse:
        return 'Nhà thờ họ';
      case HeritagePlaceType.patriarchTomb:
        return 'Lăng mộ tổ';
      case HeritagePlaceType.memberGrave:
        return 'Mộ tiền nhân';
      case HeritagePlaceType.shrine:
        return 'Miếu / Đình';
      case HeritagePlaceType.unknown:
        return 'Địa điểm di tích';
    }
  }

  void _editPlace(HeritagePlaceEntity place) {
    setState(() {
      _editingPlace = place;
      _isPinningMode = true;
      _pinnedLocation = LatLng(place.latitude, place.longitude);
      _landmarkGuideController.text = place.landmarkGuide ?? '';
      _pinnedType = place.type;
    });
    _mapController.move(_pinnedLocation, 16.5);
  }

  Future<void> _deletePlace(HeritagePlaceEntity place) async {
    final confirm = await AppDialog.confirm(
      context,
      title: 'Xóa địa điểm?',
      message: 'Bạn có chắc muốn xóa "${place.name}" khỏi bản đồ dòng họ?',
      confirmLabel: 'Xóa',
      type: AppDialogType.danger,
    );

    if (confirm == true && mounted) {
      context.read<HeritageMapBloc>().add(
            HeritageMapDeletePlaceEvent(
              familyId: widget.familyId,
              placeId: place.id,
            ),
          );
      _loadPlaces();
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

    return BlocConsumer<HeritageMapBloc, HeritageMapState>(
      listener: (context, state) {
        if (state is HeritageMapLoaded) {
          if (state.saveSuccessMessage != null) {
            AppSnackBar.success(context, state.saveSuccessMessage!);
            if (_isAssigningGrave || _isEditing) {
              Navigator.pop(context, state.selectedPlace ?? true);
            } else {
              setState(() => _isPinningMode = false);
              _loadPlaces();
            }
          }

          // Chỉ bay đến địa điểm khởi tạo một lần duy nhất lúc mở màn hình
          if (widget.initialPlaceId != null &&
              !_handledInitialPlace &&
              !_isPinningMode) {
            final target = state.places
                .where((p) => p.id == widget.initialPlaceId)
                .firstOrNull;
            if (target != null) {
              _handledInitialPlace = true;
              _flyToPlace(target);
            }
          }
        }
      },
      builder: (context, state) {
        if (state is HeritageMapLoading) {
          return Scaffold(
            backgroundColor: context.background,
            body: const AppBackgroundBody(
              enableMaxWidth: false,
              child: Center(child: AppLoading()),
            ),
          );
        }

        if (state is HeritageMapError) {
          return Scaffold(
            backgroundColor: context.background,
            body: AppBackgroundBody(
              enableMaxWidth: false,
              child: AppErrorState(
                message: state.message,
                onRetry: _loadPlaces,
              ),
            ),
          );
        }

        final loadedState = state is HeritageMapLoaded
            ? state
            : const HeritageMapLoaded(familyId: 1, places: []);

        final isSaving = state is HeritageMapLoaded && state.isSaving;

        final userLoc = loadedState.userLatitude != null &&
                loadedState.userLongitude != null
            ? LatLng(loadedState.userLatitude!, loadedState.userLongitude!)
            : null;

        return Scaffold(
          backgroundColor: context.background,
          body: AppBackgroundBody(
            enableMaxWidth: false,
            child: _isPinningMode
                ? _buildPinningModeLayout(loadedState, isSaving)
                : _buildOverviewModeLayout(loadedState, userLoc, canEdit),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. CHẾ ĐỘ XEM TỔNG QUAN (OVERVIEW MODE - GOOGLE MAPS STYLE)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildOverviewModeLayout(
    HeritageMapLoaded loadedState,
    LatLng? userLoc,
    bool canEdit,
  ) {
    final selectedPlace = loadedState.selectedPlace;

    return Stack(
      children: [
        // 1. BẢN ĐỒ TOÀN MÀN HÌNH
        MapViewWidget(
          mapController: _mapController,
          places: loadedState.places,
          selectedPlace: selectedPlace,
          isSatellite: loadedState.isSatellite,
          userLocation: userLoc,
          onSelectPlace: (p) => _flyToPlace(p),
          onMapTap: (_) {
            if (selectedPlace != null) {
              context
                  .read<HeritageMapBloc>()
                  .add(const HeritageMapSelectPlaceEvent(null));
            }
          },
        ),

        // 2. THANH TÌM KIẾM & NÚT BACK TÍCH HỢP TRÊN ĐẦU + BỘ LỌC CHIP KIỂU GOOGLE MAPS
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Nút Back
                      Container(
                        decoration: BoxDecoration(
                          color: context.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(LucideIcons.arrowLeft,
                              color: context.textPrimary, size: 20),
                          tooltip: 'Quay lại',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Thanh tìm kiếm Google Maps
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: context.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: context.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm di tích, mộ phần...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13,
                                color: context.textSecondary,
                              ),
                              prefixIcon: Icon(
                                LucideIcons.search,
                                size: 18,
                                color: context.primary,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(LucideIcons.x, size: 16),
                                      onPressed: () {
                                        _searchController.clear();
                                        _loadPlaces();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 13),
                            ),
                            onTap: () {
                              if (selectedPlace != null) {
                                context.read<HeritageMapBloc>().add(
                                    const HeritageMapSelectPlaceEvent(null));
                              }
                            },
                            onChanged: (_) {
                              if (selectedPlace != null) {
                                context.read<HeritageMapBloc>().add(
                                    const HeritageMapSelectPlaceEvent(null));
                              }
                              _loadPlaces();
                            },
                            onSubmitted: (_) => _loadPlaces(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Hàng chip phân loại danh mục (Filter Chips kiểu Google Maps)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'Tất cả',
                          icon: LucideIcons.layers,
                          iconColor: context.textSecondary,
                          type: null,
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'Nhà thờ họ',
                          icon: LucideIcons.landmark,
                          iconColor: const Color(0xFFD97706),
                          type: HeritagePlaceType.ancestralHouse,
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'Lăng mộ tổ',
                          icon: LucideIcons.crown,
                          iconColor: const Color(0xFF8B5CF6),
                          type: HeritagePlaceType.patriarchTomb,
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'Mộ tiền nhân',
                          icon: LucideIcons.flame,
                          iconColor: const Color(0xFFE11D48),
                          type: HeritagePlaceType.memberGrave,
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'Miếu / Đình',
                          icon: LucideIcons.building,
                          iconColor: const Color(0xFF059669),
                          type: HeritagePlaceType.shrine,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3. CÁC NÚT ĐIỀU KHIỂN BÊN PHẢI (FLOATING CONTROLS - KHÔNG BAO GIỜ BỊ CHE BỞI BOTTOM SHEET)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          right: 16,
          bottom: selectedPlace != null ? 230 : 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút Chuyển tầng Vệ tinh / Giao thông
              _buildFloatingCircleBtn(
                icon: loadedState.isSatellite
                    ? LucideIcons.map
                    : LucideIcons.satellite,
                tooltip: loadedState.isSatellite
                    ? 'Bản đồ giao thông'
                    : 'Ảnh vệ tinh',
                color:
                    loadedState.isSatellite ? context.accent : context.surface,
                iconColor: loadedState.isSatellite
                    ? Colors.black
                    : context.textPrimary,
                onPressed: () {
                  context
                      .read<HeritageMapBloc>()
                      .add(const HeritageMapToggleLayerEvent());
                },
              ),
              const SizedBox(height: 10),

              // Nút Vị trí của tôi (GPS)
              _buildFloatingCircleBtn(
                icon: _isLocating ? LucideIcons.loader2 : LucideIcons.crosshair,
                tooltip: 'Vị trí của tôi',
                color: context.surface,
                iconColor: context.primary,
                isLoading: _isLocating,
                onPressed: () => _onLocateMePressed(userLoc),
              ),
            ],
          ),
        ),

        // 4. BOTTOM SHEET GOOGLE MAPS CARD KHI CHỌN ĐỊA ĐIỂM
        if (selectedPlace != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HeritagePlaceViewSheet(
              place: selectedPlace,
              userLocation: userLoc,
              canEdit: canEdit,
              onClose: () {
                context.read<HeritageMapBloc>().add(
                      const HeritageMapSelectPlaceEvent(null),
                    );
              },
              onEdit: () => _editPlace(selectedPlace),
              onDelete: () => _deletePlace(selectedPlace),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. CHẾ ĐỘ CHẤM GHIM / CHỌN VỊ TRÍ (PINNING MODE - GOOGLE MAPS STYLE)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPinningModeLayout(HeritageMapLoaded loadedState, bool isSaving) {
    return Stack(
      children: [
        // 1. Bản đồ chấm ghim vệ tinh / giao thông
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _pinnedLocation,
            initialZoom: 16.5,
            minZoom: 4.0,
            maxZoom: 19.0,
            onTap: (_, point) {
              setState(() {
                _pinnedLocation = point;
                _geocodingResults = [];
              });
              FocusScope.of(context).unfocus();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: loadedState.isSatellite
                  ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                  : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
              userAgentPackageName: 'com.giatocviet.app',
              maxZoom: 19,
            ),
            // Các địa điểm đã có sẵn để tham chiếu
            MarkerLayer(
              markers: [
                ...loadedState.places.map((p) {
                  return Marker(
                    point: LatLng(p.latitude, p.longitude),
                    width: 32,
                    height: 32,
                    child: const Opacity(
                      opacity: 0.6,
                      child: Icon(LucideIcons.mapPin,
                          color: Colors.amber, size: 28),
                    ),
                  );
                }),
                // Điểm ghim đang chọn
                Marker(
                  point: _pinnedLocation,
                  width: 52,
                  height: 52,
                  alignment: Alignment.topCenter,
                  child: const Icon(
                    LucideIcons.mapPin,
                    color: Colors.redAccent,
                    size: 48,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // 2. THANH TÌM KIẾM ĐỊA DANH & NÚT BACK TRÊN CÙNG
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Nút Back
                      Container(
                        decoration: BoxDecoration(
                          color: context.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(LucideIcons.arrowLeft,
                              color: context.textPrimary, size: 20),
                          tooltip: 'Quay lại',
                          onPressed: _cancelPinningMode,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Thanh tìm kiếm địa danh
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: context.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _geocodeSearchFocusNode,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: context.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nhập địa danh để tìm...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13,
                                color: context.textSecondary,
                              ),
                              prefixIcon: Icon(
                                LucideIcons.search,
                                size: 18,
                                color: context.primary,
                              ),
                              suffixIcon: _isGeocodingSearching
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    )
                                  : (_searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(LucideIcons.x,
                                              size: 16),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(
                                                () => _geocodingResults = []);
                                          },
                                        )
                                      : null),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 13),
                            ),
                            onChanged: _onGeocodeSearchChanged,
                            onSubmitted: (val) => _searchLocation(val.trim()),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Gợi ý kết quả tìm kiếm
                  if (_geocodingResults.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _geocodingResults.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final item = _geocodingResults[idx];
                          return ListTile(
                            dense: true,
                            leading: Icon(LucideIcons.mapPin,
                                size: 16, color: context.primary),
                            title: Text(
                              item.name,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: context.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _selectGeocodeResult(item),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 3. Nút chuyển tầng bản đồ & Nút lấy GPS nổi bên phải
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          right: 16,
          bottom:
              (_geocodeSearchFocusNode.hasFocus || _geocodingResults.isNotEmpty)
                  ? 28
                  : 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFloatingCircleBtn(
                icon: loadedState.isSatellite
                    ? LucideIcons.map
                    : LucideIcons.satellite,
                tooltip: loadedState.isSatellite
                    ? 'Bản đồ giao thông'
                    : 'Ảnh vệ tinh',
                color: context.surface,
                iconColor: context.textPrimary,
                onPressed: () {
                  context
                      .read<HeritageMapBloc>()
                      .add(const HeritageMapToggleLayerEvent());
                },
              ),
              const SizedBox(height: 10),
              _buildFloatingCircleBtn(
                icon: _isLocating ? LucideIcons.loader2 : LucideIcons.crosshair,
                tooltip: 'Vị trí hiện tại',
                color: context.surface,
                iconColor: context.primary,
                isLoading: _isLocating,
                onPressed: _isLocating ? null : _getCurrentGpsLocation,
              ),
            ],
          ),
        ),

        // 4. Panel nhập & lưu vị trí đẩy lên từ đáy (ẩn đi khi đang nhập / tìm kiếm địa danh)
        if (!_geocodeSearchFocusNode.hasFocus && _geocodingResults.isEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HeritagePlaceEditSheet(
              place: _editingPlace ?? widget.placeToEdit,
              pinnedLocation: _pinnedLocation,
              landmarkGuideController: _landmarkGuideController,
              pinnedType: _pinnedType,
              onTypeChanged: (type) => setState(() => _pinnedType = type),
              isAssigningGrave: _isAssigningGrave,
              isEditing: _isEditing || _editingPlace != null,
              isSaving: isSaving,
              onClose: _cancelPinningMode,
              onSave: _savePinnedPlace,
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. HELPER WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required Color iconColor,
    required HeritagePlaceType? type,
  }) {
    final isSelected = _activeFilterType == type;

    return GestureDetector(
      onTap: () {
        setState(() => _activeFilterType = type);
        _loadPlaces();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? context.primary : context.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? context.primary
                : context.accent.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : iconColor,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircleBtn({
    required IconData icon,
    required String tooltip,
    required Color color,
    required Color iconColor,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, color: iconColor, size: 20),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}

class _GeocodingItem {
  const _GeocodingItem({required this.name, required this.location});
  final String name;
  final LatLng location;
}

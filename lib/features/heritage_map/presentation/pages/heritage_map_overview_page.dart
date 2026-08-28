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
import '../widgets/map_view_widget.dart';
import '../widgets/place_card_item.dart';
import 'heritage_place_detail_page.dart';
import 'heritage_place_form_page.dart';

class HeritageMapOverviewPage extends StatelessWidget {
  const HeritageMapOverviewPage({super.key, this.initialPlaceId});

  final int? initialPlaceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeritageMapBloc(
        getHeritagePlaces: sl<GetHeritagePlaces>(),
        saveHeritagePlace: sl<SaveHeritagePlace>(),
        deleteHeritagePlace: sl<DeleteHeritagePlace>(),
      ),
      child: _HeritageMapOverviewView(initialPlaceId: initialPlaceId),
    );
  }
}

class _HeritageMapOverviewView extends StatefulWidget {
  const _HeritageMapOverviewView({this.initialPlaceId});
  final int? initialPlaceId;

  @override
  State<_HeritageMapOverviewView> createState() => _HeritageMapOverviewViewState();
}

class _HeritageMapOverviewViewState extends State<_HeritageMapOverviewView> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  HeritagePlaceType? _activeFilterType;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _fetchUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadPlaces() {
    final authState = context.read<AuthBloc>().state;
    final familyId = authState is Authenticated ? authState.user.familyId : 1;
    if (familyId != null) {
      context.read<HeritageMapBloc>().add(
            HeritageMapLoadEvent(
              familyId: familyId,
              type: _activeFilterType,
              query: _searchController.text.trim(),
            ),
          );
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        if (mounted) {
          context.read<HeritageMapBloc>().add(
                HeritageMapUpdateUserLocationEvent(
                  latitude: pos.latitude,
                  longitude: pos.longitude,
                ),
              );
        }
      }
    } catch (_) {}
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

  void _openPlaceDetail(HeritagePlaceEntity place) {
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: HeritagePlaceDetailPage(place: place),
      ),
    ).then((_) => _loadPlaces());
  }

  void _openAddPlaceForm() {
    final authState = context.read<AuthBloc>().state;
    final familyId = authState is Authenticated ? (authState.user.familyId ?? 1) : 1;
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: HeritagePlaceFormPage(familyId: familyId),
      ),
    ).then((result) {
      if (result == true) {
        _loadPlaces();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR') &&
        UserMainNavigationPage.adminModeNotifier.value;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: 'Bản đồ Di tích & Mộ phần',
        actions: [
          IconButton(
            icon: Icon(
              _isSearchExpanded ? LucideIcons.x : LucideIcons.search,
              color: context.textPrimary,
            ),
            tooltip: _isSearchExpanded ? 'Đóng tìm kiếm' : 'Tìm kiếm địa điểm',
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  _loadPlaces();
                }
              });
            },
          ),
          if (canEdit)
            IconButton(
              icon: Icon(LucideIcons.plusCircle, color: context.primary),
              tooltip: 'Thêm địa điểm / Mộ phần',
              onPressed: _openAddPlaceForm,
            ),
        ],
      ),
      body: BlocConsumer<HeritageMapBloc, HeritageMapState>(
        listener: (context, state) {
          if (state is HeritageMapLoaded && widget.initialPlaceId != null) {
            final target = state.places.where((p) => p.id == widget.initialPlaceId).firstOrNull;
            if (target != null) {
              _flyToPlace(target);
            }
          }
        },
        builder: (context, state) {
          if (state is HeritageMapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HeritageMapError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.alertTriangle, size: 48, color: Colors.amber),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: GoogleFonts.beVietnamPro(fontSize: 14, color: context.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Tải lại',
                      prefixIcon: const Icon(LucideIcons.refreshCw, size: 16, color: Colors.white),
                      onPressed: _loadPlaces,
                    ),
                  ],
                ),
              ),
            );
          }

          final loadedState = state is HeritageMapLoaded
              ? state
              : const HeritageMapLoaded(familyId: 1, places: []);

          final userLoc = loadedState.userLatitude != null && loadedState.userLongitude != null
              ? LatLng(loadedState.userLatitude!, loadedState.userLongitude!)
              : null;

          return AppBackgroundBody(
            enableMaxWidth: false,
            child: Column(
              children: [
              // Thanh tìm kiếm mở rộng (nếu bật)
              if (_isSearchExpanded)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  color: context.appBarBg,
                  child: AppTextField(
                    label: 'Tìm kiếm địa điểm',
                    controller: _searchController,
                    hintText: 'Tìm theo tên cụ, địa danh, mốc nhận diện...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    onFieldSubmitted: (_) => _loadPlaces(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              _loadPlaces();
                            },
                          )
                        : null,
                  ),
                ),

              // ── NỬA TRÊN: BẢN ĐỒ TƯƠNG TÁC (MAP VIEW) ──
              Expanded(
                flex: 5,
                child: MapViewWidget(
                  mapController: _mapController,
                  places: loadedState.places,
                  selectedPlace: loadedState.selectedPlace,
                  isSatellite: loadedState.isSatellite,
                  userLocation: userLoc,
                  onSelectPlace: (p) => _flyToPlace(p),
                  onToggleLayer: () {
                    context.read<HeritageMapBloc>().add(const HeritageMapToggleLayerEvent());
                  },
                  onLocateMe: () => _onLocateMePressed(userLoc),
                ),
              ),

              // ── NỬA DƯỚI: THANH LỌC & DANH SÁCH ĐỊA ĐIỂM ──
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Bộ lọc loại địa điểm
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: 'Tất cả (${loadedState.places.length})',
                              isSelected: _activeFilterType == null,
                              onTap: () {
                                setState(() => _activeFilterType = null);
                                _loadPlaces();
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: '🏛️ Nhà thờ họ',
                              isSelected: _activeFilterType == HeritagePlaceType.ancestralHouse,
                              onTap: () {
                                setState(() => _activeFilterType = HeritagePlaceType.ancestralHouse);
                                _loadPlaces();
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: '👑 Lăng mộ tổ',
                              isSelected: _activeFilterType == HeritagePlaceType.patriarchTomb,
                              onTap: () {
                                setState(() => _activeFilterType = HeritagePlaceType.patriarchTomb);
                                _loadPlaces();
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: '🪦 Mộ tiền nhân',
                              isSelected: _activeFilterType == HeritagePlaceType.memberGrave,
                              onTap: () {
                                setState(() => _activeFilterType = HeritagePlaceType.memberGrave);
                                _loadPlaces();
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: '⛩️ Miếu / Đình',
                              isSelected: _activeFilterType == HeritagePlaceType.shrine,
                              onTap: () {
                                setState(() => _activeFilterType = HeritagePlaceType.shrine);
                                _loadPlaces();
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // Danh sách các điểm
                      Expanded(
                        child: loadedState.places.isEmpty
                            ? const AppEmptyState(
                                message: 'Chưa có dữ liệu địa điểm hoặc mộ phần',
                                subMessage: 'Bấm nút "+" để thêm địa điểm, lăng mộ tổ hoặc mộ tiền nhân.',
                                icon: LucideIcons.mapPinOff,
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                                itemCount: loadedState.places.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final place = loadedState.places[index];
                                  final isSelected = loadedState.selectedPlace?.id == place.id;
                                  return PlaceCardItem(
                                    place: place,
                                    isSelected: isSelected,
                                    userLocation: userLoc,
                                    onTap: () => _flyToPlace(place),
                                    onViewDetail: () => _openPlaceDetail(place),
                                  );
                                },
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
  );
}

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? context.primary : context.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? context.primary : context.accent.withValues(alpha: 0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : context.textPrimary,
          ),
        ),
      ),
    );
  }
}

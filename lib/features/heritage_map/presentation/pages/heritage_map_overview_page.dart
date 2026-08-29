import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/heritage_place_entity.dart';
import '../../domain/usecases/delete_heritage_place.dart';
import '../../domain/usecases/get_heritage_places.dart';
import '../../domain/usecases/save_heritage_place.dart';
import '../bloc/heritage_map_bloc.dart';
import '../bloc/heritage_map_event.dart';
import '../bloc/heritage_map_state.dart';
import '../widgets/heritage_map_filter_bar.dart';
import '../widgets/heritage_map_floating_controls.dart';
import '../widgets/heritage_map_search_bar.dart';
import '../widgets/heritage_pinning_map_view.dart';
import '../widgets/heritage_place_edit_sheet.dart';
import '../widgets/heritage_place_view_sheet.dart';
import '../widgets/map_view_widget.dart';

/// Trang Bản đồ Di tích dòng họ (Bản đồ tương tác kiểu Google Maps)
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
  final GeocodingService _geocodingService = GeocodingService();

  HeritagePlaceType? _activeFilterType;
  bool _handledInitialPlace = false;

  // Overview Search (Google Maps style Autocomplete)
  List<HeritagePlaceEntity> _placeSuggestions = [];

  // Pinning / Edit mode geocoding
  late bool _isPinningMode;
  late LatLng _pinnedLocation;
  late HeritagePlaceType _pinnedType;
  HeritagePlaceEntity? _editingPlace;
  bool _isLocating = false;
  bool _isGeocodingSearching = false;
  List<GeocodingResult> _geocodingResults = [];
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

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. LOCATION & GEOCODING SERVICES
  // ═══════════════════════════════════════════════════════════════════════════

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
      final list = await _geocodingService.search(query);
      if (mounted) {
        setState(() {
          _geocodingResults = list;
        });
      }
    } finally {
      if (mounted) setState(() => _isGeocodingSearching = false);
    }
  }

  void _selectGeocodeResult(GeocodingResult item) {
    setState(() {
      _pinnedLocation = item.location;
      _geocodingResults = [];
      _searchController.text = item.name.split(',').take(2).join(',').trim();
    });
    _mapController.move(item.location, 16.5);
    FocusScope.of(context).unfocus();
  }

  Future<void> _getCurrentGpsLocation() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppSnackBar.warning(context, l10n.heritageMapGpsTurnOnPrompt);
        }
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          if (mounted) {
            AppSnackBar.error(context, l10n.heritageMapGpsPermissionDenied);
          }
          return;
        }
      }

      if (perm == LocationPermission.deniedForever) {
        if (mounted) {
          AppSnackBar.error(
            context,
            l10n.heritageMapGpsPermissionPermanentlyDenied,
          );
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
        AppSnackBar.info(context, l10n.heritageMapGpsLocationFetched);
      } else if (mounted) {
        AppSnackBar.error(context, l10n.heritageMapGpsCannotIdentify);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, l10n.heritageMapGpsError(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. GOOGLE MAPS STYLE OVERVIEW SEARCH (AUTOCOMPLETE + INSTANT FLYTO)
  // ═══════════════════════════════════════════════════════════════════════════

  void _onOverviewSearchChanged(
    String query,
    List<HeritagePlaceEntity> allPlaces,
  ) {
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      setState(() {
        _placeSuggestions = [];
      });
      return;
    }

    final l10n = AppLocalizations.of(context);
    final matches = allPlaces.where((p) {
      final nameMatch = p.displayName.toLowerCase().contains(trimmed);
      final rawNameMatch = p.name.toLowerCase().contains(trimmed);
      final guideMatch =
          p.landmarkGuide?.toLowerCase().contains(trimmed) ?? false;
      final typeMatch = p.type.getLabel(l10n).toLowerCase().contains(trimmed);
      return nameMatch || rawNameMatch || guideMatch || typeMatch;
    }).toList();

    setState(() {
      _placeSuggestions = matches.take(6).toList();
    });
  }

  void _onSelectPlaceSuggestion(HeritagePlaceEntity place) {
    setState(() {
      _searchController.text = place.displayName;
      _placeSuggestions = [];
    });
    FocusScope.of(context).unfocus();
    _flyToPlace(place);
  }

  void _onSubmitOverviewSearch(
    String query,
    List<HeritagePlaceEntity> currentPlaces,
  ) {
    setState(() {
      _placeSuggestions = [];
    });
    FocusScope.of(context).unfocus();

    if (currentPlaces.isEmpty) {
      final l10n = AppLocalizations.of(context);
      AppSnackBar.info(context, l10n.heritageMapNoResultsFound);
      return;
    }

    if (currentPlaces.length == 1) {
      _flyToPlace(currentPlaces.first);
    } else {
      final points =
          currentPlaces.map((p) => LatLng(p.latitude, p.longitude)).toList();
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.only(
            top: 140,
            bottom: 80,
            left: 40,
            right: 40,
          ),
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. USER ACTIONS & NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

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
        _placeSuggestions = [];
        _searchController.clear();
      });
      _loadPlaces();
    }
  }

  void _savePinnedPlace() {
    final l10n = AppLocalizations.of(context);
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
          l10n.heritageMapRelativeGrave;
    } else {
      name = targetPlace?.name.isNotEmpty == true
          ? targetPlace!.name
          : _pinnedType.getLabel(l10n);
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
    final l10n = AppLocalizations.of(context);
    final confirm = await AppDialog.confirm(
      context,
      title: l10n.heritageMapDeleteConfirmTitle,
      message: l10n.heritageMapDeleteConfirmMessage(place.name),
      confirmLabel: l10n.heritageMapDeleteConfirmBtn,
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

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. MAIN BUILD METHOD
  // ═══════════════════════════════════════════════════════════════════════════

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
  // 5. OVERVIEW MODE LAYOUT (GOOGLE MAPS STYLE)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOverviewModeLayout(
    HeritageMapLoaded loadedState,
    LatLng? userLoc,
    bool canEdit,
  ) {
    final l10n = AppLocalizations.of(context);
    final selectedPlace = loadedState.selectedPlace;

    return Stack(
      children: [
        // 1. Bản đồ tương tác
        MapViewWidget(
          mapController: _mapController,
          places: loadedState.places,
          selectedPlace: selectedPlace,
          isSatellite: loadedState.isSatellite,
          userLocation: userLoc,
          onSelectPlace: (p) => _flyToPlace(p),
          onMapTap: (_) {
            if (_placeSuggestions.isNotEmpty) {
              setState(() => _placeSuggestions = []);
            }
            if (selectedPlace != null) {
              context
                  .read<HeritageMapBloc>()
                  .add(const HeritageMapSelectPlaceEvent(null));
            }
            FocusScope.of(context).unfocus();
          },
        ),

        // 2. Header: Nút Back + Thanh tìm kiếm + Bộ lọc Chips
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
                  HeritageMapSearchBar(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    hintText: l10n.heritageMapSearchHint,
                    userLocation: userLoc,
                    placeSuggestions: _placeSuggestions,
                    onSelectPlace: _onSelectPlaceSuggestion,
                    onBack: () => Navigator.pop(context),
                    onClear: () {
                      _searchController.clear();
                      setState(() => _placeSuggestions = []);
                      context
                          .read<HeritageMapBloc>()
                          .add(const HeritageMapSelectPlaceEvent(null));
                      _loadPlaces();
                    },
                    onTap: () {
                      if (selectedPlace != null) {
                        context
                            .read<HeritageMapBloc>()
                            .add(const HeritageMapSelectPlaceEvent(null));
                      }
                      if (_searchController.text.isNotEmpty) {
                        _onOverviewSearchChanged(
                          _searchController.text,
                          loadedState.places,
                        );
                      }
                    },
                    onChanged: (val) {
                      if (selectedPlace != null) {
                        context
                            .read<HeritageMapBloc>()
                            .add(const HeritageMapSelectPlaceEvent(null));
                      }
                      _onOverviewSearchChanged(val, loadedState.places);
                    },
                    onSubmitted: (val) => _onSubmitOverviewSearch(
                      val,
                      loadedState.places,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Thanh chip phân loại danh mục (ẩn khi đang hiện gợi ý)
                  if (_placeSuggestions.isEmpty)
                    HeritageMapFilterBar(
                      selectedType: _activeFilterType,
                      onTypeSelected: (type) {
                        setState(() => _activeFilterType = type);
                        _loadPlaces();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),

        // 3. Cụm nút điều khiển nổi bên phải
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          right: 16,
          bottom: selectedPlace != null ? 230 : 28,
          child: HeritageMapFloatingControls(
            isSatellite: loadedState.isSatellite,
            isLocating: _isLocating,
            onToggleLayer: () {
              context
                  .read<HeritageMapBloc>()
                  .add(const HeritageMapToggleLayerEvent());
            },
            onLocateMe: () => _onLocateMePressed(userLoc),
          ),
        ),

        // 4. Bottom Sheet chi tiết địa điểm khi chọn
        if (selectedPlace != null && _placeSuggestions.isEmpty)
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
  // 6. PINNING / EDIT MODE LAYOUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPinningModeLayout(HeritageMapLoaded loadedState, bool isSaving) {
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        // 1. Bản đồ chấm ghim vị trí
        HeritagePinningMapView(
          mapController: _mapController,
          pinnedLocation: _pinnedLocation,
          referencePlaces: loadedState.places,
          isSatellite: loadedState.isSatellite,
          onMapTap: (point) {
            setState(() {
              _pinnedLocation = point;
              _geocodingResults = [];
            });
            FocusScope.of(context).unfocus();
          },
        ),

        // 2. Header: Nút Back + Thanh tìm kiếm địa danh kèm gợi ý Nominatim
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: HeritageMapSearchBar(
                controller: _searchController,
                focusNode: _geocodeSearchFocusNode,
                hintText: l10n.heritageMapGeocodeSearchHint,
                onBack: _cancelPinningMode,
                isSearching: _isGeocodingSearching,
                geocodingResults: _geocodingResults,
                onClear: () {
                  _searchController.clear();
                  setState(() => _geocodingResults = []);
                },
                onChanged: _onGeocodeSearchChanged,
                onSubmitted: (val) => _searchLocation(val.trim()),
                onSelectGeocodeResult: _selectGeocodeResult,
              ),
            ),
          ),
        ),

        // 3. Cụm nút điều khiển nổi bên phải
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          right: 16,
          bottom:
              (_geocodeSearchFocusNode.hasFocus || _geocodingResults.isNotEmpty)
                  ? 28
                  : 300,
          child: HeritageMapFloatingControls(
            isSatellite: loadedState.isSatellite,
            isLocating: _isLocating,
            onToggleLayer: () {
              context
                  .read<HeritageMapBloc>()
                  .add(const HeritageMapToggleLayerEvent());
            },
            onLocateMe: _getCurrentGpsLocation,
          ),
        ),

        // 4. Panel nhập & lưu vị trí đẩy lên từ đáy
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
}

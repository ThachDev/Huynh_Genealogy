import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_heritage_place.dart';
import '../../domain/usecases/get_heritage_places.dart';
import '../../domain/usecases/save_heritage_place.dart';
import 'heritage_map_event.dart';
import 'heritage_map_state.dart';

class HeritageMapBloc extends Bloc<HeritageMapEvent, HeritageMapState> {
  HeritageMapBloc({
    required this.getHeritagePlaces,
    required this.saveHeritagePlace,
    required this.deleteHeritagePlace,
  }) : super(HeritageMapInitial()) {
    on<HeritageMapLoadEvent>(_onLoadPlaces);
    on<HeritageMapSelectPlaceEvent>(_onSelectPlace);
    on<HeritageMapToggleLayerEvent>(_onToggleLayer);
    on<HeritageMapUpdateUserLocationEvent>(_onUpdateUserLocation);
    on<HeritageMapSavePlaceEvent>(_onSavePlace);
    on<HeritageMapDeletePlaceEvent>(_onDeletePlace);
  }

  final GetHeritagePlaces getHeritagePlaces;
  final SaveHeritagePlace saveHeritagePlace;
  final DeleteHeritagePlace deleteHeritagePlace;

  Future<void> _onLoadPlaces(
    HeritageMapLoadEvent event,
    Emitter<HeritageMapState> emit,
  ) async {
    final currentState = state;
    final isSatellite =
        currentState is HeritageMapLoaded ? currentState.isSatellite : false;
    final userLat =
        currentState is HeritageMapLoaded ? currentState.userLatitude : null;
    final userLng =
        currentState is HeritageMapLoaded ? currentState.userLongitude : null;
    if (currentState is! HeritageMapLoaded) {
      emit(HeritageMapLoading());
    }

    final result = await getHeritagePlaces(
      GetHeritagePlacesParams(
        familyId: event.familyId,
        type: event.type,
        generation: event.generation,
        query: event.query,
      ),
    );

    result.fold(
      (failure) => emit(HeritageMapError(failure.message)),
      (places) => emit(
        HeritageMapLoaded(
          familyId: event.familyId,
          places: places,
          isSatellite: isSatellite,
          userLatitude: userLat,
          userLongitude: userLng,
          selectedType: event.type,
          selectedGeneration: event.generation,
          searchQuery: event.query ?? '',
        ),
      ),
    );
  }

  void _onSelectPlace(
    HeritageMapSelectPlaceEvent event,
    Emitter<HeritageMapState> emit,
  ) {
    if (state is HeritageMapLoaded) {
      final s = state as HeritageMapLoaded;
      emit(s.copyWith(selectedPlace: () => event.place));
    }
  }

  void _onToggleLayer(
    HeritageMapToggleLayerEvent event,
    Emitter<HeritageMapState> emit,
  ) {
    if (state is HeritageMapLoaded) {
      final s = state as HeritageMapLoaded;
      final newSatellite = event.isSatellite ?? !s.isSatellite;
      emit(s.copyWith(isSatellite: newSatellite));
    }
  }

  void _onUpdateUserLocation(
    HeritageMapUpdateUserLocationEvent event,
    Emitter<HeritageMapState> emit,
  ) {
    if (state is HeritageMapLoaded) {
      final s = state as HeritageMapLoaded;
      emit(s.copyWith(
        userLatitude: () => event.latitude,
        userLongitude: () => event.longitude,
      ));
    }
  }

  Future<void> _onSavePlace(
    HeritageMapSavePlaceEvent event,
    Emitter<HeritageMapState> emit,
  ) async {
    if (state is HeritageMapLoaded) {
      final s = state as HeritageMapLoaded;
      emit(s.copyWith(isSaving: true));

      final result = await saveHeritagePlace(
        SaveHeritagePlaceParams(place: event.place),
      );

      result.fold(
        (failure) => emit(s.copyWith(isSaving: false)),
        (savedPlace) {
          final updatedList = List.of(s.places);
          final idx = updatedList.indexWhere((p) => p.id == savedPlace.id);
          if (idx != -1) {
            updatedList[idx] = savedPlace;
          } else {
            updatedList.insert(0, savedPlace);
          }
          emit(s.copyWith(
            places: updatedList,
            selectedPlace: () => savedPlace,
            isSaving: false,
            saveSuccessMessage: () => 'Đã lưu thông tin địa điểm thành công',
          ));
        },
      );
    }
  }

  Future<void> _onDeletePlace(
    HeritageMapDeletePlaceEvent event,
    Emitter<HeritageMapState> emit,
  ) async {
    if (state is HeritageMapLoaded) {
      final s = state as HeritageMapLoaded;
      emit(s.copyWith(isSaving: true));

      final result = await deleteHeritagePlace(
        DeleteHeritagePlaceParams(
          familyId: event.familyId,
          placeId: event.placeId,
        ),
      );

      result.fold(
        (failure) => emit(s.copyWith(isSaving: false)),
        (_) {
          final updatedList =
              s.places.where((p) => p.id != event.placeId).toList();
          emit(s.copyWith(
            places: updatedList,
            selectedPlace: () =>
                updatedList.isNotEmpty ? updatedList.first : null,
            isSaving: false,
          ));
        },
      );
    }
  }
}

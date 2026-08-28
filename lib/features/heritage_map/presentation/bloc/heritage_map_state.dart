import 'package:equatable/equatable.dart';
import '../../domain/entities/heritage_place_entity.dart';

abstract class HeritageMapState extends Equatable {
  const HeritageMapState();

  @override
  List<Object?> get props => [];
}

class HeritageMapInitial extends HeritageMapState {}

class HeritageMapLoading extends HeritageMapState {}

class HeritageMapLoaded extends HeritageMapState {
  const HeritageMapLoaded({
    required this.familyId,
    required this.places,
    this.selectedPlace,
    this.isSatellite = false,
    this.userLatitude,
    this.userLongitude,
    this.selectedType,
    this.selectedGeneration,
    this.searchQuery = '',
    this.isSaving = false,
    this.saveSuccessMessage,
  });

  final int familyId;
  final List<HeritagePlaceEntity> places;
  final HeritagePlaceEntity? selectedPlace;
  final bool isSatellite;
  final double? userLatitude;
  final double? userLongitude;
  final HeritagePlaceType? selectedType;
  final int? selectedGeneration;
  final String searchQuery;
  final bool isSaving;
  final String? saveSuccessMessage;

  HeritageMapLoaded copyWith({
    int? familyId,
    List<HeritagePlaceEntity>? places,
    HeritagePlaceEntity? Function()? selectedPlace,
    bool? isSatellite,
    double? Function()? userLatitude,
    double? Function()? userLongitude,
    HeritagePlaceType? Function()? selectedType,
    int? Function()? selectedGeneration,
    String? searchQuery,
    bool? isSaving,
    String? Function()? saveSuccessMessage,
  }) {
    return HeritageMapLoaded(
      familyId: familyId ?? this.familyId,
      places: places ?? this.places,
      selectedPlace: selectedPlace != null ? selectedPlace() : this.selectedPlace,
      isSatellite: isSatellite ?? this.isSatellite,
      userLatitude: userLatitude != null ? userLatitude() : this.userLatitude,
      userLongitude: userLongitude != null ? userLongitude() : this.userLongitude,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      selectedGeneration: selectedGeneration != null ? selectedGeneration() : this.selectedGeneration,
      searchQuery: searchQuery ?? this.searchQuery,
      isSaving: isSaving ?? this.isSaving,
      saveSuccessMessage: saveSuccessMessage != null ? saveSuccessMessage() : this.saveSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        familyId,
        places,
        selectedPlace,
        isSatellite,
        userLatitude,
        userLongitude,
        selectedType,
        selectedGeneration,
        searchQuery,
        isSaving,
        saveSuccessMessage,
      ];
}

class HeritageMapError extends HeritageMapState {
  const HeritageMapError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

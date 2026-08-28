import 'package:equatable/equatable.dart';
import '../../domain/entities/heritage_place_entity.dart';

abstract class HeritageMapEvent extends Equatable {
  const HeritageMapEvent();

  @override
  List<Object?> get props => [];
}

class HeritageMapLoadEvent extends HeritageMapEvent {
  const HeritageMapLoadEvent({
    required this.familyId,
    this.type,
    this.generation,
    this.query,
  });

  final int familyId;
  final HeritagePlaceType? type;
  final int? generation;
  final String? query;

  @override
  List<Object?> get props => [familyId, type, generation, query];
}

class HeritageMapSelectPlaceEvent extends HeritageMapEvent {
  const HeritageMapSelectPlaceEvent(this.place);
  final HeritagePlaceEntity? place;

  @override
  List<Object?> get props => [place];
}

class HeritageMapToggleLayerEvent extends HeritageMapEvent {
  const HeritageMapToggleLayerEvent({this.isSatellite});
  final bool? isSatellite;

  @override
  List<Object?> get props => [isSatellite];
}

class HeritageMapUpdateUserLocationEvent extends HeritageMapEvent {
  const HeritageMapUpdateUserLocationEvent({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];
}

class HeritageMapSavePlaceEvent extends HeritageMapEvent {
  const HeritageMapSavePlaceEvent(this.place);
  final HeritagePlaceEntity place;

  @override
  List<Object?> get props => [place];
}

class HeritageMapDeletePlaceEvent extends HeritageMapEvent {
  const HeritageMapDeletePlaceEvent({
    required this.familyId,
    required this.placeId,
  });
  final int familyId;
  final int placeId;

  @override
  List<Object?> get props => [familyId, placeId];
}

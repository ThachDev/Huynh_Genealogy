import 'package:equatable/equatable.dart';

enum HeritagePlaceType {
  ancestralHouse, // Nhà thờ họ / Từ đường
  patriarchTomb,  // Lăng mộ tổ
  memberGrave,    // Mộ phần cá nhân
  shrine,         // Miếu / Đình làng dòng họ
  unknown,
}

extension HeritagePlaceTypeX on HeritagePlaceType {
  String toDbString() {
    switch (this) {
      case HeritagePlaceType.ancestralHouse:
        return 'ANCESTRAL_HOUSE';
      case HeritagePlaceType.patriarchTomb:
        return 'PATRIARCH_TOMB';
      case HeritagePlaceType.memberGrave:
        return 'MEMBER_GRAVE';
      case HeritagePlaceType.shrine:
        return 'SHRINE';
      case HeritagePlaceType.unknown:
        return 'UNKNOWN';
    }
  }

  static HeritagePlaceType fromDbString(String? val) {
    switch (val?.toUpperCase()) {
      case 'ANCESTRAL_HOUSE':
        return HeritagePlaceType.ancestralHouse;
      case 'PATRIARCH_TOMB':
        return HeritagePlaceType.patriarchTomb;
      case 'MEMBER_GRAVE':
        return HeritagePlaceType.memberGrave;
      case 'SHRINE':
        return HeritagePlaceType.shrine;
      default:
        return HeritagePlaceType.unknown;
    }
  }
}

class HeritagePlaceEntity extends Equatable {
  const HeritagePlaceEntity({
    required this.id,
    required this.familyId,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.memberId,
    this.address,
    this.landmarkGuide,
    this.imageUrls = const [],
    this.generation,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.memberFullName,
    this.memberAvatarUrl,
    this.memberLunarDeathDate,
  });

  final int id;
  final int familyId;
  final int? memberId;
  final String name;
  final HeritagePlaceType type;
  final double latitude;
  final double longitude;
  final String? address;
  final String? landmarkGuide;
  final List<String> imageUrls;
  final int? generation;
  final String? description;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Extra joined info from Member (nếu là mộ cá nhân)
  final String? memberFullName;
  final String? memberAvatarUrl;
  final String? memberLunarDeathDate;

  HeritagePlaceEntity copyWith({
    int? id,
    int? familyId,
    int? memberId,
    String? name,
    HeritagePlaceType? type,
    double? latitude,
    double? longitude,
    String? address,
    String? landmarkGuide,
    List<String>? imageUrls,
    int? generation,
    String? description,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? memberFullName,
    String? memberAvatarUrl,
    String? memberLunarDeathDate,
  }) {
    return HeritagePlaceEntity(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      landmarkGuide: landmarkGuide ?? this.landmarkGuide,
      imageUrls: imageUrls ?? this.imageUrls,
      generation: generation ?? this.generation,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      memberFullName: memberFullName ?? this.memberFullName,
      memberAvatarUrl: memberAvatarUrl ?? this.memberAvatarUrl,
      memberLunarDeathDate: memberLunarDeathDate ?? this.memberLunarDeathDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        familyId,
        memberId,
        name,
        type,
        latitude,
        longitude,
        address,
        landmarkGuide,
        imageUrls,
        generation,
        description,
        createdBy,
        createdAt,
        updatedAt,
        memberFullName,
        memberAvatarUrl,
        memberLunarDeathDate,
      ];
}

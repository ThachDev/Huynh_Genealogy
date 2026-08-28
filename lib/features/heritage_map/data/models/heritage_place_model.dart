import 'dart:convert';
import '../../domain/entities/heritage_place_entity.dart';

class HeritagePlaceModel {
  const HeritagePlaceModel({
    required this.id,
    required this.familyId,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.memberId,
    this.landmarkGuide,
    this.imageUrls = const [],
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.memberFullName,
    this.memberAvatarUrl,
  });

  factory HeritagePlaceModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['image_urls'] != null) {
      if (json['image_urls'] is List) {
        images = (json['image_urls'] as List).map((e) => e.toString()).toList();
      } else if (json['image_urls'] is String && json['image_urls'].toString().isNotEmpty) {
        try {
          final decoded = jsonDecode(json['image_urls']);
          if (decoded is List) {
            images = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {
          images = [json['image_urls'].toString()];
        }
      }
    } else if (json['imageUrls'] != null) {
      if (json['imageUrls'] is List) {
        images = (json['imageUrls'] as List).map((e) => e.toString()).toList();
      }
    }

    final memberObj = json['member'] is Map ? json['member'] as Map<String, dynamic> : null;

    return HeritagePlaceModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      familyId: json['family_id'] is int
          ? json['family_id']
          : (json['familyId'] is int
              ? json['familyId']
              : int.tryParse(json['family_id']?.toString() ?? json['familyId']?.toString() ?? '0') ?? 0),
      memberId: json['member_id'] != null
          ? (json['member_id'] is int ? json['member_id'] : int.tryParse(json['member_id'].toString()))
          : (json['memberId'] != null
              ? (json['memberId'] is int ? json['memberId'] : int.tryParse(json['memberId'].toString()))
              : null),
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'UNKNOWN',
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
      landmarkGuide: json['landmark_guide']?.toString() ?? json['landmarkGuide']?.toString(),
      imageUrls: images,
      createdBy: json['created_by'] != null
          ? (json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by'].toString()))
          : (json['createdBy'] != null
              ? (json['createdBy'] is int ? json['createdBy'] : int.tryParse(json['createdBy'].toString()))
              : null),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? json['updatedAt']?.toString(),
      memberFullName: memberObj != null
          ? (memberObj['fullName']?.toString() ?? memberObj['full_name']?.toString())
          : (json['member_full_name']?.toString() ?? json['memberFullName']?.toString()),
      memberAvatarUrl: memberObj != null
          ? (memberObj['avatarUrl']?.toString() ?? memberObj['avatar_url']?.toString())
          : (json['member_avatar_url']?.toString() ?? json['memberAvatarUrl']?.toString()),
    );
  }

  factory HeritagePlaceModel.fromEntity(HeritagePlaceEntity entity) {
    return HeritagePlaceModel(
      id: entity.id,
      familyId: entity.familyId,
      memberId: entity.memberId,
      name: entity.name,
      type: entity.type.toDbString(),
      latitude: entity.latitude,
      longitude: entity.longitude,
      landmarkGuide: entity.landmarkGuide,
      imageUrls: entity.imageUrls,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      memberFullName: entity.memberFullName,
      memberAvatarUrl: entity.memberAvatarUrl,
    );
  }

  final int id;
  final int familyId;
  final int? memberId;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String? landmarkGuide;
  final List<String> imageUrls;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  final String? memberFullName;
  final String? memberAvatarUrl;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      if (memberId != null) 'memberId': memberId,
      if (landmarkGuide != null) 'landmarkGuide': landmarkGuide,
      'imageUrls': imageUrls,
    };
  }

  HeritagePlaceEntity toEntity() {
    return HeritagePlaceEntity(
      id: id,
      familyId: familyId,
      memberId: memberId,
      name: name,
      type: HeritagePlaceTypeX.fromDbString(type),
      latitude: latitude,
      longitude: longitude,
      landmarkGuide: landmarkGuide,
      imageUrls: imageUrls,
      createdBy: createdBy,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      memberFullName: memberFullName,
      memberAvatarUrl: memberAvatarUrl,
    );
  }
}

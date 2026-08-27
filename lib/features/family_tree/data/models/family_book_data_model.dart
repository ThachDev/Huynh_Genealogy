import '../../domain/entities/family_book_data_entity.dart';

class FamilyBookStatsModel extends FamilyBookStatsEntity {
  const FamilyBookStatsModel({
    required super.totalGenerations,
    required super.totalMembers,
    required super.maleMembers,
    required super.femaleMembers,
    required super.aliveMembers,
    required super.deceasedMembers,
  });

  factory FamilyBookStatsModel.fromJson(Map<String, dynamic> json) {
    return FamilyBookStatsModel(
      totalGenerations: (json['totalGenerations'] as num?)?.toInt() ?? 0,
      totalMembers: (json['totalMembers'] as num?)?.toInt() ?? 0,
      maleMembers: (json['maleMembers'] as num?)?.toInt() ?? 0,
      femaleMembers: (json['femaleMembers'] as num?)?.toInt() ?? 0,
      aliveMembers: (json['aliveMembers'] as num?)?.toInt() ?? 0,
      deceasedMembers: (json['deceasedMembers'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalGenerations': totalGenerations,
        'totalMembers': totalMembers,
        'maleMembers': maleMembers,
        'femaleMembers': femaleMembers,
        'aliveMembers': aliveMembers,
        'deceasedMembers': deceasedMembers,
      };
}

class MemorialCalendarItemModel extends MemorialCalendarItemEntity {
  const MemorialCalendarItemModel({
    required super.memberId,
    required super.fullName,
    required super.gender,
    required super.generation,
    required super.lunarDay,
    required super.lunarMonth,
    super.dateOfDeath,
    super.lunarDeathDate,
    super.burialPlaceNotes,
  });

  factory MemorialCalendarItemModel.fromJson(Map<String, dynamic> json) {
    return MemorialCalendarItemModel(
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] as String? ?? '',
      gender: json['gender'] as String? ?? 'unknown',
      generation: (json['generation'] as num?)?.toInt() ?? 1,
      lunarDay: (json['lunarDay'] as num?)?.toInt() ?? 1,
      lunarMonth: (json['lunarMonth'] as num?)?.toInt() ?? 1,
      dateOfDeath: json['dateOfDeath'] as String?,
      lunarDeathDate: json['lunarDeathDate'] as String?,
      burialPlaceNotes: json['burialPlaceNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'fullName': fullName,
        'gender': gender,
        'generation': generation,
        'lunarDay': lunarDay,
        'lunarMonth': lunarMonth,
        'dateOfDeath': dateOfDeath,
        'lunarDeathDate': lunarDeathDate,
        'burialPlaceNotes': burialPlaceNotes,
      };
}

class FamilyBookDataModel extends FamilyBookDataEntity {
  const FamilyBookDataModel({
    required super.familyId,
    required super.stats,
    required super.memorialCalendar,
  });

  factory FamilyBookDataModel.fromJson(Map<String, dynamic> json) {
    final statsJson = json['stats'] as Map<String, dynamic>? ?? {};
    final memorialList = json['memorialCalendar'] as List<dynamic>? ?? [];

    return FamilyBookDataModel(
      familyId: (json['familyId'] as num?)?.toInt() ?? 0,
      stats: FamilyBookStatsModel.fromJson(statsJson),
      memorialCalendar: memorialList
          .map((e) =>
              MemorialCalendarItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'familyId': familyId,
        'stats': (stats as FamilyBookStatsModel).toJson(),
        'memorialCalendar': memorialCalendar
            .map((e) => (e as MemorialCalendarItemModel).toJson())
            .toList(),
      };
}

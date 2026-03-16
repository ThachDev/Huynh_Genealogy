import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';

class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.name,
    super.description,
    super.founderName,
    super.foundingYear,
    super.region,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) => v is int ? v : (v is String ? int.tryParse(v) : null);

    return BranchModel(
      id: asInt(json['id']) ?? 0,
      name: json['name'] as String,
      description: json['description'] as String?,
      founderName: json['founderName'] as String?,
      foundingYear: asInt(json['foundingYear']),
      region: json['region'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'founderName': founderName,
      'foundingYear': foundingYear,
      'region': region,
    };

    if (id != 0) {
      data['id'] = id;
    }

    return data;
  }

  factory BranchModel.fromEntity(BranchEntity entity) {
    return BranchModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      founderName: entity.founderName,
      foundingYear: entity.foundingYear,
      region: entity.region,
    );
  }
}

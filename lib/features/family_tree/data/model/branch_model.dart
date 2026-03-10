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
    return BranchModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      founderName: json['founderName'] as String?,
      foundingYear: json['foundingYear'] as int?,
      region: json['region'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'founderName': founderName,
      'foundingYear': foundingYear,
      'region': region,
    };
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

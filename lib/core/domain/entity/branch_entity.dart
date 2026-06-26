import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? founderName;
  final int? foundingYear;
  final String? region;
  final int? familyId;

  const BranchEntity({
    required this.id,
    required this.name,
    this.description,
    this.founderName,
    this.foundingYear,
    this.region,
    this.familyId,
  });

  @override
  List<Object?> get props => [id, name, description, founderName, foundingYear, region, familyId];
}

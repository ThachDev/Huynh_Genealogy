import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_entity.freezed.dart';
part 'branch_entity.g.dart';

@freezed
class BranchEntity with _$BranchEntity {
  const factory BranchEntity({
    required int id,
    required String name,
    String? description,
    String? founderName,
    int? foundingYear,
    String? region,
    int? familyId,
  }) = _BranchEntity;

  factory BranchEntity.fromJson(Map<String, dynamic> json) =>
      _$BranchEntityFromJson(json);
}

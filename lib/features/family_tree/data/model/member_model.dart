import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
abstract class MemberModel with _$MemberModel {
  const factory MemberModel({
    @JsonKey() int? id,
    @JsonKey() String? fullName,
    @JsonKey() Gender? gender,
    @JsonKey() String? dateOfBirth,
    @JsonKey() String? placeOfBirth,
    @JsonKey() bool? isAlive,
    @JsonKey() String? dateOfDeath,
    @JsonKey() MaritalStatus? maritalStatus,
    @JsonKey() int? generation,
    @JsonKey() int? branchId,
    @JsonKey() String? branchName,
    @JsonKey() int? parentId,
    @JsonKey() int? spouseId,
    @JsonKey() String? notes,
    @JsonKey() String? avatarUrl,
  }) = _MemberModel;

  const MemberModel._();

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  factory MemberModel.fromEntity(MemberEntity entity) => MemberModel(
        id: entity.id,
        fullName: entity.fullName,
        gender: entity.gender,
        dateOfBirth: entity.dateOfBirth,
        placeOfBirth: entity.placeOfBirth,
        isAlive: entity.isAlive,
        dateOfDeath: entity.dateOfDeath,
        maritalStatus: entity.maritalStatus,
        generation: entity.generation,
        branchId: entity.branchId,
        branchName: entity.branchName,
        parentId: entity.parentId,
        spouseId: entity.spouseId,
        notes: entity.notes,
        avatarUrl: entity.avatarUrl,
      );

  MemberEntity toEntity() => MemberEntity(
        id: id ?? 0,
        fullName: fullName ?? '',
        gender: gender ?? Gender.unknown,
        dateOfBirth: dateOfBirth,
        placeOfBirth: placeOfBirth,
        isAlive: isAlive ?? true,
        dateOfDeath: dateOfDeath,
        maritalStatus: maritalStatus ?? MaritalStatus.unknown,
        generation: generation,
        branchId: branchId,
        branchName: branchName,
        parentId: parentId,
        spouseId: spouseId,
        notes: notes,
        avatarUrl: avatarUrl,
      );
}

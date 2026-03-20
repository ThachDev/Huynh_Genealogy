import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';

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
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';

/// Giới tính
enum Gender { male, female, unknown }

/// Trạng thái hôn nhân
enum MaritalStatus { single, married, divorced, widowed, unknown }

@freezed
abstract class MemberEntity with _$MemberEntity {
  const factory MemberEntity({
    @Default(0) int id,
    @Default('') String fullName,
    @Default(Gender.unknown) Gender gender,
    String? dateOfBirth,
    String? placeOfBirth,
    @Default(true) bool isAlive,
    String? dateOfDeath,
    @Default(MaritalStatus.unknown) MaritalStatus maritalStatus,
    int? generation,
    int? branchId,
    String? branchName,
    int? parentId,
    int? spouseId,
    String? notes,
    String? avatarUrl,
  }) = _MemberEntity;
}

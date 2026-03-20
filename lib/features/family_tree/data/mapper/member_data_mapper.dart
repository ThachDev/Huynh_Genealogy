import 'package:app_family_tree/core/mapper/base_data_mapper.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';

class MemberDataMapper extends BaseDataMapper<MemberModel, MemberEntity> {
  @override
  MemberEntity mapToEntity(MemberModel? data) {
    if (data == null) {
      return const MemberEntity(id: 0, fullName: '', gender: Gender.unknown);
    }
    return MemberEntity(
      id: data.id ?? 0,
      fullName: data.fullName ?? '',
      gender: data.gender ?? Gender.unknown,
      dateOfBirth: data.dateOfBirth,
      placeOfBirth: data.placeOfBirth,
      isAlive: data.isAlive ?? true,
      dateOfDeath: data.dateOfDeath,
      maritalStatus: data.maritalStatus ?? MaritalStatus.unknown,
      generation: data.generation,
      branchId: data.branchId,
      branchName: data.branchName,
      parentId: data.parentId,
      spouseId: data.spouseId,
      notes: data.notes,
      avatarUrl: data.avatarUrl,
    );
  }

  @override
  MemberModel mapToData(MemberEntity entity) {
    return MemberModel(
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
  }
}

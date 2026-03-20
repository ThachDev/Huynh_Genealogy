import 'package:app_family_tree/core/mapper/base_data_mapper.dart';
import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';

class BranchDataMapper extends BaseDataMapper<BranchModel, BranchEntity> {
  @override
  BranchEntity mapToEntity(BranchModel? data) {
    if (data == null) {
      return const BranchEntity(id: 0, name: '');
    }
    return BranchEntity(
      id: data.id ?? 0,
      name: data.name ?? '',
      description: data.description,
      founderName: data.founderName,
      foundingYear: data.foundingYear,
      region: data.region,
    );
  }

  @override
  BranchModel mapToData(BranchEntity entity) {
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

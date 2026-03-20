import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';

@freezed
abstract class BranchModel with _$BranchModel {
  const factory BranchModel({
    @JsonKey() int? id,
    @JsonKey() String? name,
    @JsonKey() String? description,
    @JsonKey() String? founderName,
    @JsonKey() int? foundingYear,
    @JsonKey() String? region,
  }) = _BranchModel;

  const BranchModel._();

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);
}

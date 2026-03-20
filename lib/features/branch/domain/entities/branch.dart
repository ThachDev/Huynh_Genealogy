import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';

@freezed
abstract class BranchEntity with _$BranchEntity {
  const factory BranchEntity({
    @Default(0) int id,
    @Default('') String name,
    String? description,
    String? founderName,
    int? foundingYear,
    String? region,
  }) = _BranchEntity;
}

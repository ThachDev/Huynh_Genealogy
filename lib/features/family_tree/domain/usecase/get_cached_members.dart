import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../repository/family_tree_repository.dart';

class GetCachedMembers implements UseCase<List<MemberEntity>?, GetCachedMembersParams> {
  final FamilyTreeRepository repository;

  GetCachedMembers(this.repository);

  @override
  Future<Either<Failure, List<MemberEntity>?>> call(GetCachedMembersParams params) async {
    return Right(await repository.getCachedMembers(familyId: params.familyId));
  }
}

class GetCachedMembersParams extends Equatable {
  final int? familyId;

  const GetCachedMembersParams({this.familyId});

  @override
  List<Object?> get props => [familyId];
}

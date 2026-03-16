import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class SaveMemberUseCase extends UseCase<MemberEntity, SaveMemberParams> {
  final FamilyRepository repository;

  SaveMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, MemberEntity>> call(SaveMemberParams params) {
    return repository.saveMember(params.member, imageFile: params.imageFile);
  }
}

class SaveMemberParams {
  final MemberEntity member;
  final File? imageFile;

  SaveMemberParams({required this.member, this.imageFile});
}

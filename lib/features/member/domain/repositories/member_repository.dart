import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';

abstract class MemberRepository {
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId});
  Future<Either<Failure, MemberEntity>> getMemberById(int id);
  Future<Either<Failure, MemberEntity>> saveMember(MemberEntity member, {File? imageFile});
  Future<Either<Failure, bool>> deleteMember(int id);
}

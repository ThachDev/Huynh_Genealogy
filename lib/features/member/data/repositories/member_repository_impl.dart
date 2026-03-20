import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/core/error/app_error_handler.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/features/member/domain/repositories/member_repository.dart';
import 'package:app_family_tree/features/member/data/sources/member_api_service.dart';
import 'package:app_family_tree/features/member/data/mappers/member_data_mapper.dart';

class MemberRepositoryImpl implements MemberRepository {
  MemberRepositoryImpl({required this.apiService});

  final MemberApiService apiService;
  final MemberDataMapper _memberMapper = MemberDataMapper();

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId}) async {
    try {
      final models = await apiService.getMembers(branchId: branchId);
      return Right(models.map(_memberMapper.mapToEntity).toList());
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> getMemberById(int id) async {
    try {
      final model = await apiService.getMemberById(id);
      return Right(_memberMapper.mapToEntity(model));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> saveMember(
    MemberEntity member, {
    File? imageFile,
  }) async {
    try {
      final model = _memberMapper.mapToData(member);
      final saved = await apiService.saveMember(model, imageFile: imageFile);
      return Right(_memberMapper.mapToEntity(saved));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember(int id) async {
    try {
      return Right(await apiService.deleteMember(id));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}

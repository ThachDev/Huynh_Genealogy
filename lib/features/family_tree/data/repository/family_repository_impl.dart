import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';
import 'package:app_family_tree/features/family_tree/data/source/family_api_service.dart';
import 'package:app_family_tree/features/family_tree/data/mapper/branch_data_mapper.dart';
import 'package:app_family_tree/features/family_tree/data/mapper/member_data_mapper.dart';
import 'package:app_family_tree/core/error/app_error_handler.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  FamilyRepositoryImpl({required this.apiService});

  final FamilyApiService apiService;
  final MemberDataMapper _memberMapper = MemberDataMapper();
  final BranchDataMapper _branchMapper = BranchDataMapper();

  // ─── Members ──────────────────────────────────────────────────────────────

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

  // ─── Branches ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<BranchEntity>>> getBranches() async {
    try {
      final models = await apiService.getBranches();
      return Right(models.map(_branchMapper.mapToEntity).toList());
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> getBranchById(int id) async {
    try {
      final model = await apiService.getBranchById(id);
      return Right(_branchMapper.mapToEntity(model));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch) async {
    try {
      final model = _branchMapper.mapToData(branch);
      final saved = await apiService.saveBranch(model);
      return Right(_branchMapper.mapToEntity(saved));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBranch(int id) async {
    try {
      return Right(await apiService.deleteBranch(id));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}

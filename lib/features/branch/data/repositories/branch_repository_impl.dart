import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/core/error/app_error_handler.dart';
import 'package:app_family_tree/features/branch/domain/entities/branch.dart';
import 'package:app_family_tree/features/branch/domain/repositories/branch_repository.dart';
import 'package:app_family_tree/features/branch/data/sources/branch_api_service.dart';
import 'package:app_family_tree/features/branch/data/mappers/branch_data_mapper.dart';

class BranchRepositoryImpl implements BranchRepository {
  BranchRepositoryImpl({required this.apiService});

  final BranchApiService apiService;
  final BranchDataMapper _branchMapper = BranchDataMapper();

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

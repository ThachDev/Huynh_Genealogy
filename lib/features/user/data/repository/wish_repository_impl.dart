import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wish_entity.dart';
import '../../domain/repository/wish_repository.dart';
import '../../domain/wish_reaction.dart';
import '../source/wish_remote_data_source.dart';

class WishRepositoryImpl implements WishRepository {
  WishRepositoryImpl({required this.remoteDataSource});
  final WishRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<WishEntity>>> getWishesByMember(
    int memberId,
  ) async {
    try {
      final wishes = await remoteDataSource.getWishesByMember(memberId);
      return Right(wishes);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, List<WishEntity>>> getMyWishes({int? memberId}) async {
    try {
      final wishes = await remoteDataSource.getMyWishes(memberId: memberId);
      return Right(wishes);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, WishEntity>> createWish(WishEntity wish) async {
    try {
      final created = await remoteDataSource.createWish(wish);
      return Right(created);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, WishReaction>> reactToWish(int wishId) async {
    try {
      final reaction = await remoteDataSource.reactToWish(wishId);
      return Right(reaction);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> reportWish(int wishId, String reason) async {
    try {
      final success = await remoteDataSource.reportWish(wishId, reason);
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markWishAsRead(int wishId) async {
    try {
      final success = await remoteDataSource.markWishAsRead(wishId);
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllWishesAsRead() async {
    try {
      final success = await remoteDataSource.markAllWishesAsRead();
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }
}
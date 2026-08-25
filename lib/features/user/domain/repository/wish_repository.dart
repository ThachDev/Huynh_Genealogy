import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/wish_entity.dart';
import '../wish_reaction.dart';

abstract class WishRepository {
  Future<Either<Failure, List<WishEntity>>> getWishesByMember(int memberId);
  Future<Either<Failure, List<WishEntity>>> getMyWishes({int? memberId});
  Future<Either<Failure, WishEntity>> createWish(WishEntity wish);
  Future<Either<Failure, WishReaction>> reactToWish(int wishId);
  Future<Either<Failure, bool>> reportWish(int wishId, String reason);
  Future<Either<Failure, bool>> deleteWish(int wishId);
  Future<Either<Failure, bool>> markWishAsRead(int wishId);
  Future<Either<Failure, bool>> markAllWishesAsRead();
}
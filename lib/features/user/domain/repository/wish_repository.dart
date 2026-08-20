import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/entity/wish_entity.dart';
import '../wish_reaction.dart';

abstract class WishRepository {
  Future<Either<Failure, List<WishEntity>>> getWishesByMember(int memberId);
  Future<Either<Failure, WishEntity>> createWish(WishEntity wish);
  Future<Either<Failure, WishReaction>> reactToWish(int wishId);
  Future<Either<Failure, bool>> reportWish(int wishId, String reason);
}
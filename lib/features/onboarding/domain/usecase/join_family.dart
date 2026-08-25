import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/family_user_entity.dart';
import '../repository/onboarding_repository.dart';

/// ============================================================================
/// USE CASE — JOIN FAMILY (DOMAIN LAYER)
/// ============================================================================
/// Đảm nhận nghiệp vụ gửi yêu cầu tham gia vào một dòng họ (gia tộc).
///
/// UseCase này nhận `JoinFamilyParams` (bao gồm `userId`, `familyId`, và tuỳ chọn
/// thông tin cá nhân mới hoặc ID nút thành viên trên cây gia phả để liên kết).
/// Kết quả trả về `Either<Failure, FamilyUserEntity>`.
/// ============================================================================
class JoinFamily implements UseCase<FamilyUserEntity, JoinFamilyParams> {

  JoinFamily(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, FamilyUserEntity>> call(JoinFamilyParams params) {
    return repository.joinFamily(
      userId: params.userId,
      familyId: params.familyId,
      memberNodeId: params.memberNodeId,
      fullName: params.fullName,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      placeOfBirth: params.placeOfBirth,
      maritalStatus: params.maritalStatus,
      education: params.education,
      avatarUrl: params.avatarUrl,
      parentId: params.parentId,
      spouseId: params.spouseId,
      notes: params.notes,
    );
  }
}

class JoinFamilyParams extends Equatable {

  const JoinFamilyParams({
    required this.userId,
    required this.familyId,
    this.memberNodeId,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.maritalStatus,
    this.education,
    this.avatarUrl,
    this.parentId,
    this.spouseId,
    this.notes,
  });
  final int userId;
  final int familyId;
  final int? memberNodeId;
  final String? fullName;
  final String? gender;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? maritalStatus;
  final String? education;
  final String? avatarUrl;
  final int? parentId;
  final int? spouseId;
  final String? notes;

  @override
  List<Object?> get props => [
        userId,
        familyId,
        memberNodeId,
        fullName,
        gender,
        dateOfBirth,
        placeOfBirth,
        maritalStatus,
        education,
        avatarUrl,
        notes,
      ];
}

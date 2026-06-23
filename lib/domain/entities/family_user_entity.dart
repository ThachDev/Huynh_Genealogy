import 'package:equatable/equatable.dart';

class FamilyUserEntity extends Equatable {
  final int id;
  final int userId;
  final int familyId;
  final int? memberNodeId;
  final String role; // 'OWNER' | 'BRANCH_ADMIN' | 'EDITOR' | 'VIEWER'
  final String status; // 'PENDING' | 'APPROVED' | 'REJECTED'
  final String? userFullName; // Optional, populated when fetching requests for approval
  final String? userEmail;
  final String? userAvatarUrl;

  const FamilyUserEntity({
    required this.id,
    required this.userId,
    required this.familyId,
    this.memberNodeId,
    required this.role,
    required this.status,
    this.userFullName,
    this.userEmail,
    this.userAvatarUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        familyId,
        memberNodeId,
        role,
        status,
        userFullName,
        userEmail,
        userAvatarUrl,
      ];
}

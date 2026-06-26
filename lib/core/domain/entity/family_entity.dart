import 'package:equatable/equatable.dart';

class FamilyEntity extends Equatable {
  final int id;
  final String name;
  final String inviteCode;
  final int creatorId;
  final String? description;
  final String? coverImageUrl;

  const FamilyEntity({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.creatorId,
    this.description,
    this.coverImageUrl,
  });

  @override
  List<Object?> get props => [id, name, inviteCode, creatorId, description, coverImageUrl];
}

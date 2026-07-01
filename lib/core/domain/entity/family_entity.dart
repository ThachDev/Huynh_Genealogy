import 'package:equatable/equatable.dart';

class FamilyEntity extends Equatable {
  final int id;
  final String name;
  final String inviteCode;
  final int creatorId;
  final String? description;
  final String? origin;
  final String? logoUrl;

  const FamilyEntity({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.creatorId,
    this.description,
    this.origin,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, inviteCode, creatorId, description, origin, logoUrl];
}

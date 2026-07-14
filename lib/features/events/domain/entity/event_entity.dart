import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String eventDate; // Format: Y-m-d
  final bool isLunar;
  final int familyId;

  const EventEntity({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.isLunar = false,
    required this.familyId,
  });

  @override
  List<Object?> get props => [id, title, description, eventDate, isLunar, familyId];
}

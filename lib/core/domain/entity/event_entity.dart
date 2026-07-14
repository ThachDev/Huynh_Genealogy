import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String eventDate; // Format: Y-m-d
  final bool isLunar;
  final int familyId;
  final String? content;
  final String? imageUrl;
  final String? location;
  final String type; // 'event' | 'article' | 'announcement' | 'anniversary'
  final String? organizer;

  const EventEntity({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.isLunar = false,
    required this.familyId,
    this.content,
    this.imageUrl,
    this.location,
    this.type = 'event',
    this.organizer,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        eventDate,
        isLunar,
        familyId,
        content,
        imageUrl,
        location,
        type,
        organizer,
      ];
}

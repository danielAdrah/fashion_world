import 'package:cloud_firestore/cloud_firestore.dart';

class FashionEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String
      eventType; // e.g., "fashion_week", "designer_showcase", "virtual_show", "retail_event"
  final String imageUrl;
  final String organizer;
  final String website;
  final List<String> designers; // List of designer IDs participating
  final Timestamp timestamp;
  final bool isFeatured;

  FashionEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.eventType,
    required this.imageUrl,
    required this.organizer,
    required this.website,
    required this.designers,
    required this.timestamp,
    required this.isFeatured,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'eventType': eventType,
      'imageUrl': imageUrl,
      'organizer': organizer,
      'website': website,
      'designers': designers,
      'timestamp': timestamp,
      'isFeatured': isFeatured,
    };
  }

  factory FashionEvent.fromMap(Map<String, dynamic> map, String id) {
    return FashionEvent(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      eventType: map['eventType'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      organizer: map['organizer'] ?? '',
      website: map['website'] ?? '',
      designers: List<String>.from(map['designers'] ?? []),
      timestamp: map['timestamp'] ?? Timestamp.now(),
      isFeatured: map['isFeatured'] ?? false,
    );
  }
}

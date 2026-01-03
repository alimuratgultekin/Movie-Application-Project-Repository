import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String name;
  final String movieTitle;
  final DateTime date;
  final String time;
  final String location;
  final String createdBy;
  final String organizerName;
  final DateTime createdAt;
  final int attendeeCount;
  final List<String> attendees;

  EventModel({
    required this.id,
    required this.name,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.location,
    required this.createdBy,
    required this.organizerName,
    required this.createdAt,
    this.attendeeCount = 1,
    this.attendees = const [],
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'movieTitle': movieTitle,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
      'createdBy': createdBy,
      'organizerName': organizerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'attendeeCount': attendeeCount,
      'attendees': attendees,
    };
  }

  // Create from Firestore document
  factory EventModel.fromMap(Map<String, dynamic> map, String documentId) {
    return EventModel(
      id: documentId,
      name: map['name'] ?? '',
      movieTitle: map['movieTitle'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      createdBy: map['createdBy'] ?? '',
      organizerName: map['organizerName'] ?? 'Organizer',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attendeeCount: map['attendeeCount'] ?? 1,
      attendees: List<String>.from(map['attendees'] ?? []),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory EventModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return EventModel.fromMap(data, snapshot.id);
  }

  // Check if event is in the past
  bool get isPast => date.isBefore(DateTime.now());

  // Check if event is today
  bool get isToday {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Format date for display
  String get formattedDate {
    List<String> months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
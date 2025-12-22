import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String movieTitle;
  final double rating;
  final String reviewText;
  final String createdBy;
  final String userName;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.movieTitle,
    required this.rating,
    required this.reviewText,
    required this.createdBy,
    required this.userName,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'rating': rating,
      'reviewText': reviewText,
      'createdBy': createdBy,
      'userName': userName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory ReviewModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ReviewModel(
      id: documentId,
      movieTitle: map['movieTitle'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewText: map['reviewText'] ?? '',
      createdBy: map['createdBy'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory ReviewModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ReviewModel.fromMap(data, snapshot.id);
  }
}
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore/review_model.dart';
import '../services/auth_service.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  String? _error;

  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get reviews for a specific movie (real-time)
  Stream<List<ReviewModel>> getMovieReviews(String movieTitle) {
    return _firestore
        .collection('reviews')
        .where('movieTitle', isEqualTo: movieTitle)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ReviewModel.fromSnapshot(doc))
          .toList();
    }).handleError((error) {
      print('Error getting movie reviews: $error');
    });
  }

  // Get user's reviews
  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ReviewModel.fromSnapshot(doc))
          .toList();
    }).handleError((error) {
      print('Error getting user reviews: $error');
    });
  }

  // Submit a review
  Future<bool> submitReview({
    required String movieTitle,
    required double rating,
    required String reviewText,
    required String userName,
  }) async {
    try {

      _isLoading = true;
      _error = null;
      notifyListeners();

      String? userId = _authService.currentUserId;

      if (userId == null) {
        throw 'User not authenticated';
      }

      // Create review document

      DocumentReference docRef = await _firestore.collection('reviews').add({
        'movieTitle': movieTitle,
        'rating': rating,
        'reviewText': reviewText,
        'createdBy': userId,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
      });


      // Update user statistics
      await _authService.updateUserStats(
        moviesRated: 1,
        reviewsWritten: 1,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update a review
  Future<bool> updateReview({
    required String reviewId,
    required double rating,
    required String reviewText,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('reviews').doc(reviewId).update({
        'rating': rating,
        'reviewText': reviewText,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete a review
  Future<bool> deleteReview(String reviewId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('reviews').doc(reviewId).delete();

      // Decrement user statistics
      await _authService.updateUserStats(
        moviesRated: -1,
        reviewsWritten: -1,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get average rating for a movie
  Future<double> getAverageRating(String movieTitle) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('reviews')
          .where('movieTitle', isEqualTo: movieTitle)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      double totalRating = 0;
      for (var doc in snapshot.docs) {
        totalRating += (doc.data() as Map<String, dynamic>)['rating'] ?? 0;
      }

      return totalRating / snapshot.docs.length;
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
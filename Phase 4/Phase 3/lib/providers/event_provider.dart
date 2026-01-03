import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/firestore/event_model.dart';
import '../../services/auth_service.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all events (real-time)
  Stream<List<EventModel>> getAllEvents() {
    try {
      return _firestore
          .collection('events')
          .orderBy('date', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => EventModel.fromSnapshot(doc))
            .toList();
      }).handleError((error) {
        print('Error getting all events: $error');
        if (error.toString().contains('index') || error.toString().contains('failed-precondition')) {
          // Fallback without orderBy if index is missing
          return _firestore
              .collection('events')
              .snapshots()
              .map((snapshot) {
            var events = snapshot.docs
                .map((doc) => EventModel.fromSnapshot(doc))
                .toList();
            // Sort manually by date
            events.sort((a, b) => a.date.compareTo(b.date));
            return events;
          });
        }
        return Stream.value(<EventModel>[]);
      });
    } catch (e) {
      print('Error in getAllEvents: $e');
      return Stream.value(<EventModel>[]);
    }
  }

  // Get user's events (real-time) - with fallback for missing index
  Stream<List<EventModel>> getUserEvents(String userId) {
    try {
      return _firestore
          .collection('events')
          .where('createdBy', isEqualTo: userId)
          .orderBy('date', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => EventModel.fromSnapshot(doc))
            .toList();
      }).handleError((error) {
        print('Error getting user events: $error');
      });
    } catch (e) {
      print('Error in getUserEvents: $e');
      // Fallback query without orderBy
      return _firestore
          .collection('events')
          .where('createdBy', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        var events = snapshot.docs
            .map((doc) => EventModel.fromSnapshot(doc))
            .toList();
        events.sort((a, b) => a.date.compareTo(b.date));
        return events;
      });
    }
  }
  
  // Get user's events (fallback without orderBy)
  Stream<List<EventModel>> getUserEventsFallback(String userId) {
    return _firestore
        .collection('events')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      var events = snapshot.docs
          .map((doc) => EventModel.fromSnapshot(doc))
          .toList();
      events.sort((a, b) => a.date.compareTo(b.date));
      return events;
    });
  }

  // Get upcoming events
  Stream<List<EventModel>> getUpcomingEvents(String userId) {
    return _firestore
        .collection('events')
        .where('createdBy', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EventModel.fromSnapshot(doc))
          .toList();
    });
  }

  // Get past events
  Stream<List<EventModel>> getPastEvents(String userId) {
    return _firestore
        .collection('events')
        .where('createdBy', isEqualTo: userId)
        .where('date', isLessThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EventModel.fromSnapshot(doc))
          .toList();
    });
  }

  // Create an event
  Future<String?> createEvent({
    required String name,
    required String movieTitle,
    required DateTime date,
    required String time,
    required String location,
    required String organizerName,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      String? userId = _authService.currentUserId;
      print('Creating event - User ID: $userId');
      if (userId == null) {
        print('ERROR: User not authenticated');
        throw 'User not authenticated';
      }

      print('Creating event document in Firestore...');
      // Create event document
      DocumentReference docRef = await _firestore.collection('events').add({
        'name': name,
        'movieTitle': movieTitle,
        'date': Timestamp.fromDate(date),
        'time': time,
        'location': location,
        'createdBy': userId,
        'organizerName': organizerName,
        'createdAt': FieldValue.serverTimestamp(),
        'attendeeCount': 1,
        'attendees': [userId],
      });

      print('Event created successfully with ID: ${docRef.id}');
      _isLoading = false;
      notifyListeners();
      return docRef.id;
    } catch (e, stackTrace) {
      print('ERROR creating event: $e');
      print('Stack trace: $stackTrace');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update an event
  Future<bool> updateEvent({
    required String eventId,
    required String name,
    required String movieTitle,
    required DateTime date,
    required String time,
    required String location,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('events').doc(eventId).update({
        'name': name,
        'movieTitle': movieTitle,
        'date': Timestamp.fromDate(date),
        'time': time,
        'location': location,
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

  // Delete an event
  Future<bool> deleteEvent(String eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('events').doc(eventId).delete();

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

  // Join an event (add user to attendees)
  Future<bool> joinEvent(String eventId) async {
    try {
      String? userId = _authService.currentUserId;
      if (userId == null) return false;

      await _firestore.collection('events').doc(eventId).update({
        'attendees': FieldValue.arrayUnion([userId]),
        'attendeeCount': FieldValue.increment(1),
      });

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Leave an event (remove user from attendees)
  Future<bool> leaveEvent(String eventId) async {
    try {
      String? userId = _authService.currentUserId;
      if (userId == null) return false;

      await _firestore.collection('events').doc(eventId).update({
        'attendees': FieldValue.arrayRemove([userId]),
        'attendeeCount': FieldValue.increment(-1),
      });

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  String? get currentUserId => _user?.uid;
  String get displayName => _userData?['displayName'] ?? _user?.displayName ?? 'Student';
  String get email => _user?.email ?? '';
  String get university => _userData?['university'] ?? 'University';
  int get moviesRated => _userData?['moviesRated'] ?? 0;
  int get reviewsWritten => _userData?['reviewsWritten'] ?? 0;
  int get groupsJoined => _userData?['groupsJoined'] ?? 0;
  
  // Expose auth state stream for StreamBuilder
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  AuthProvider() {
    // Load initial user data if already authenticated
    if (_authService.currentUser != null) {
      _user = _authService.currentUser;
      _loadUserData();
    }
    
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      _userData = await _authService.getUserData(_user!.uid);
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
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

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signIn(
        email: email,
        password: password,
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

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();

      _user = null;
      _userData = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.resetPassword(email);

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

  // Update user statistics
  Future<void> updateStats({
    int? moviesRated,
    int? reviewsWritten,
    int? groupsJoined,
  }) async {
    try {
      await _authService.updateUserStats(
        moviesRated: moviesRated,
        reviewsWritten: reviewsWritten,
        groupsJoined: groupsJoined,
      );

      // Reload user data to get updated stats
      await _loadUserData();
      notifyListeners();
    } catch (e) {
      print('Error updating stats: $e');
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
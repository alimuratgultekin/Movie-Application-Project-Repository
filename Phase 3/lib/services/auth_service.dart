import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Trim email to remove any whitespace
      final trimmedEmail = email.trim().toLowerCase();
      
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);

      // Extract university from email
      String university = _extractUniversity(trimmedEmail);

      // Create user document in Firestore
      print('Creating user document in Firestore for UID: ${userCredential.user!.uid}');
      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': trimmedEmail,
          'displayName': displayName,
          'university': university,
          'createdAt': FieldValue.serverTimestamp(),
          'moviesRated': 0,
          'reviewsWritten': 0,
          'groupsJoined': 0,
        });
        print('User document created successfully in Firestore');
      } catch (e) {
        print('ERROR creating user document in Firestore: $e');
        rethrow;
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Trim email to remove any whitespace
      final trimmedEmail = email.trim().toLowerCase();
      
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Unexpected Auth Error: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send reset email. Please try again.';
    }
  }

  // Extract university name from email
  String _extractUniversity(String email) {
    if (!email.contains('@')) return 'Unknown University';

    String domain = email.split('@')[1];
    String universityName = domain.split('.')[0];

    // Capitalize first letter
    return '${universityName[0].toUpperCase()}${universityName.substring(1)} University';
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak. Please use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'The email or password is incorrect. Please check your credentials and try again.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please enable it in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed: ${e.message ?? e.code}. Please check your email and password.';
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user statistics
  Future<void> updateUserStats({
    int? moviesRated,
    int? reviewsWritten,
    int? groupsJoined,
  }) async {
    try {
      if (currentUserId == null) return;

      Map<String, dynamic> updates = {};
      if (moviesRated != null) updates['moviesRated'] = FieldValue.increment(moviesRated);
      if (reviewsWritten != null) updates['reviewsWritten'] = FieldValue.increment(reviewsWritten);
      if (groupsJoined != null) updates['groupsJoined'] = FieldValue.increment(groupsJoined);

      await _firestore.collection('users').doc(currentUserId).update(updates);
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }
}
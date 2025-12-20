import 'user.dart';

class UserService {
  static User? _currentUser;

  static User get currentUser {
    _currentUser ??= User(
      name: 'Student Name',
      email: 'student@university.edu',
      university: 'Demo University',
      bio: 'Movie Enthusiast',
    );
    return _currentUser!;
  }

  static void setUser(User user) {
    _currentUser = user;
  }

  static void login({
    required String name,
    required String email,
    String? university,
  }) {
    _currentUser = User(
      name: name,
      email: email,
      university: university ?? _extractUniversityFromEmail(email),
    );
  }

  static void logout() {
    _currentUser = null;
  }

  static bool isLoggedIn() {
    return _currentUser != null;
  }

  // Extract university name from email
  static String _extractUniversityFromEmail(String email) {
    if (!email.contains('@')) return 'University';

    final domain = email.split('@')[1];
    if (!domain.contains('.')) return 'University';

    // Remove .edu and capitalize
    final name = domain.split('.')[0];
    return '${name[0].toUpperCase()}${name.substring(1)} University';
  }
}
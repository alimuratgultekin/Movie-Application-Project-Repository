class User {
  final String name;
  final String email;
  final String university;
  final String bio;

  User({
    required this.name,
    required this.email,
    required this.university,
    this.bio = 'Movie Enthusiast',
  });

  // Get first name only
  String getFirstName() {
    return name.split(' ').first;
  }

  // Get initials for avatar
  String getInitials() {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
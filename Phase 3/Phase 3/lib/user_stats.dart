// Simple in-memory storage for user statistics

// Simple in-memory storage for user statistics
class UserStats {
  static int _moviesRated = 0;
  static int _reviewsWritten = 0;
  static int _groupsJoined = 0;

  static int get moviesRated => _moviesRated;
  static int get reviewsWritten => _reviewsWritten;
  static int get groupsJoined => _groupsJoined;

  static void incrementMoviesRated() {
    _moviesRated++;
  }

  static void incrementReviewsWritten() {
    _reviewsWritten++;
  }

  static void incrementGroupsJoined() {
    _groupsJoined++;
  }

  static void reset() {
    _moviesRated = 42;
    _reviewsWritten = 8;
    _groupsJoined = 3;
  }
}
import 'package:flutter_test/flutter_test.dart';
import 'package:my_test_app/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
    test('getTrendingMovies returns a non-empty list', () {
      // Arrange & Act
      final movies = Movie.getTrendingMovies();

      // Assert
      expect(movies, isNotEmpty);
      expect(movies.length, greaterThan(0));
    });

    test('getTrendingMovies returns movies with valid data', () {
      // Arrange & Act
      final movies = Movie.getTrendingMovies();

      // Assert - Check first movie has all required fields
      final firstMovie = movies.first;
      expect(firstMovie.id, isNotEmpty);
      expect(firstMovie.title, isNotEmpty);
      expect(firstMovie.year, greaterThan(0));
      expect(firstMovie.rating, greaterThanOrEqualTo(0));
      expect(firstMovie.rating, lessThanOrEqualTo(5));
      expect(firstMovie.reviewCount, greaterThanOrEqualTo(0));
      expect(firstMovie.genres, isNotEmpty);
      expect(firstMovie.synopsis, isNotEmpty);
      expect(firstMovie.imageUrl, isNotEmpty);
    });

    test('getTrendingMovies returns movies with unique IDs', () {
      // Arrange & Act
      final movies = Movie.getTrendingMovies();

      // Assert - All movie IDs should be unique
      final ids = movies.map((m) => m.id).toList();
      final uniqueIds = ids.toSet();
      expect(uniqueIds.length, equals(ids.length));
    });

    test('getTrendingMovies contains expected movies', () {
      // Arrange & Act
      final movies = Movie.getTrendingMovies();
      final movieTitles = movies.map((m) => m.title).toList();

      // Assert - Check for specific movies
      expect(movieTitles, contains('Inception'));
      expect(movieTitles, contains('Interstellar'));
    });

    test('Movie constructor creates valid movie instance', () {
      // Arrange & Act
      final movie = Movie(
        id: 'test-1',
        title: 'Test Movie',
        year: 2023,
        rating: 4.5,
        reviewCount: 10,
        genres: ['Action', 'Drama'],
        synopsis: 'A test movie synopsis',
        imageUrl: 'https://example.com/image.jpg',
      );

      // Assert
      expect(movie.id, equals('test-1'));
      expect(movie.title, equals('Test Movie'));
      expect(movie.year, equals(2023));
      expect(movie.rating, equals(4.5));
      expect(movie.reviewCount, equals(10));
      expect(movie.genres, equals(['Action', 'Drama']));
      expect(movie.synopsis, equals('A test movie synopsis'));
      expect(movie.imageUrl, equals('https://example.com/image.jpg'));
    });
  });
}


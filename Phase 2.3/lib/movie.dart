class Movie {
  final String id;
  final String title;
  final int year;
  final double rating;
  final int reviewCount;
  final List<String> genres;
  final String synopsis;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.reviewCount,
    required this.genres,
    required this.synopsis,
    required this.imageUrl,
  });

  // Sample data
  static List<Movie> getTrendingMovies() {
    return [
      Movie(
        id: '1',
        title: 'Inception',
        year: 2010,
        rating: 4.8,
        reviewCount: 0,
        genres: ['Sci-Fi', 'Thriller'],
        synopsis: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg',
      ),
      Movie(
        id: '2',
        title: 'The Dark Knight',
        year: 2008,
        rating: 4.9,
        reviewCount: 0,
        genres: ['Action', 'Crime'],
        synopsis: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
      ),
      Movie(
        id: '3',
        title: 'Interstellar',
        year: 2014,
        rating: 4.7,
        reviewCount: 0,
        genres: ['Sci-Fi', 'Drama'],
        synopsis: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
      ),
      Movie(
        id: '4',
        title: 'Parasite',
        year: 2019,
        rating: 4.6,
        reviewCount: 0,
        genres: ['Drama', 'Thriller'],
        synopsis: 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BYWZjMjk3ZTItODQ2ZC00NTY5LWE0ZDYtZTI3MjcwN2Q5NTVkXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_SX300.jpg',
      ),
      Movie(
        id: '5',
        title: 'Everything Everywhere All at Once',
        year: 2022,
        rating: 4.7,
        reviewCount: 0,
        genres: ['Sci-Fi', 'Comedy'],
        synopsis: 'An aging Chinese immigrant is swept up in an insane adventure, where she alone can save the world by exploring other universes connecting with the lives she could have led.',
        imageUrl: 'https://m.media-amazon.com/images/M/MV5BYTdiOTIyZTQtNmQ1OS00NjZlLWIyMTgtYzk5Y2M3ZDVmMDk1XkEyXkFqcGdeQXVyMTAzMDg4NzU0._V1_SX300.jpg',
      ),
    ];
  }
}
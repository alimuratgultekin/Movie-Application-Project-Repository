import 'package:flutter/material.dart';
import 'movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'movie_list_card.dart';


class BrowseMoviesScreen extends StatefulWidget {
  const BrowseMoviesScreen({super.key});

  @override
  State<BrowseMoviesScreen> createState() => _BrowseMoviesScreenState();
}

class _BrowseMoviesScreenState extends State<BrowseMoviesScreen> {
  List<Movie> movies = Movie.getTrendingMovies();
  List<Movie> filteredMovies = Movie.getTrendingMovies();
  String selectedGenre = 'All Genres';
  String selectedSort = 'Highest Rated';

  void _applyFilters() {
    setState(() {
      // Filter by genre
      if (selectedGenre == 'All Genres') {
        filteredMovies = List.from(movies);
      } else {
        filteredMovies = movies.where((movie) {
          return movie.genres.contains(selectedGenre);
        }).toList();
      }

      // Sort
      if (selectedSort == 'Highest Rated') {
        filteredMovies.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (selectedSort == 'Most Reviews') {
        filteredMovies.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      } else if (selectedSort == 'Newest') {
        filteredMovies.sort((a, b) => b.year.compareTo(a.year));
      } else if (selectedSort == 'Oldest') {
        filteredMovies.sort((a, b) => a.year.compareTo(b.year));
      }
    });
  }

  void _removeMovie(String movieId) {
    setState(() {
      movies.removeWhere((movie) => movie.id == movieId);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Movie removed from list'),
        backgroundColor: AppColors.cardBackground,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primaryYellow,
          onPressed: () {
            setState(() {
              movies = Movie.getTrendingMovies();
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Row(
          children: [
            const Icon(
              Icons.explore,
              color: AppColors.primaryYellow,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Browse Movies',
              style: AppTextStyles.h2,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Genre Filter
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedGenre,
                        isExpanded: true,
                        icon: const Icon(Icons.filter_list, color: AppColors.textHint),
                        dropdownColor: AppColors.cardBackground,
                        style: AppTextStyles.bodyMedium,
                        items: [
                          'All Genres',
                          'Action',
                          'Comedy',
                          'Drama',
                          'Sci-Fi',
                          'Horror',
                        ].map((genre) {
                          return DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGenre = value!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Sort Filter
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSort,
                        isExpanded: true,
                        icon: const Icon(Icons.sort, color: AppColors.textHint),
                        dropdownColor: AppColors.cardBackground,
                        style: AppTextStyles.bodyMedium,
                        items: [
                          'Highest Rated',
                          'Most Reviews',
                          'Newest',
                          'Oldest',
                        ].map((sort) {
                          return DropdownMenuItem(
                            value: sort,
                            child: Text(sort),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredMovies.length} movies found',
                style: AppTextStyles.subtitle,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Movies List
          Expanded(
            child: filteredMovies.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.movie_outlined,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'No movies in the list',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'All movies have been removed',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: MovieListCard(
                    movie: filteredMovies[index],
                    onRemove: () => _removeMovie(filteredMovies[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
            // Already on Browse
              break;
            case 2:
              Navigator.pushNamed(context, '/chat-groups');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryYellow,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
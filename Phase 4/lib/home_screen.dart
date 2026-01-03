import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'movie_card.dart';
import 'providers/auth_provider.dart';
import 'browse_movies_screen.dart';
import 'chat_groups_screen.dart';
import 'profile_screen.dart';
import 'all_events_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeContent(),
          BrowseMoviesScreen(),
          ChatGroupsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryYellow,
        unselectedItemColor: AppColors.textHint,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final trendingMovies = Movie.getTrendingMovies();
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Header
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    // Get first name from displayName
                    String firstName = authProvider.displayName;
                    if (firstName.contains(' ')) {
                      firstName = firstName.split(' ')[0];
                    }
                    
                    return Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryYellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: AppTextStyles.subtitle,
                              ),
                              Text(
                                firstName,
                                style: AppTextStyles.h3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Organize Movie Night Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Organize a Movie Night',
                                  style: AppTextStyles.h3,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                const Text(
                                  'Plan events with fellow students',
                                  style: AppTextStyles.subtitle,
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/organize-event');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryYellow,
                              foregroundColor: AppColors.darkBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.add, size: 18),
                                const SizedBox(width: AppSpacing.sm),
                                const Text(
                                  'Plan Event',
                                  style: AppTextStyles.button,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/my-events');
                              },
                              icon: const Icon(Icons.event, color: AppColors.primaryYellow),
                              label: const Text(
                                'My Events',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.primaryYellow,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryYellow),
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/all-events');
                              },
                              icon: const Icon(Icons.explore, color: AppColors.primaryYellow),
                              label: const Text(
                                'All Events',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.primaryYellow,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryYellow),
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Movies, Groups, or Events...',
                    hintStyle: AppTextStyles.subtitle,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textHint,
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Trending Now Section
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.primaryYellow,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      'Trending Now',
                      style: AppTextStyles.h2,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Trending Movies List
                SizedBox(
                  height: 350, // Increased to fix overflow (was 280, overflow is 68px)
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingMovies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < trendingMovies.length - 1 ? AppSpacing.md : 0,
                        ),
                        child: MovieCard(
                          movie: trendingMovies[index],
                          width: 140,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Recommended for You Section
                const Text(
                  'Recommended for You',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Based on your mood and preferences',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppSpacing.md),

                // Recommended Movies Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSmallScreen ? 2 : 4,
                    childAspectRatio: 0.5, // Changed from 0.55 to fix overflow (more height)
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      movie: trendingMovies[index % trendingMovies.length],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
}
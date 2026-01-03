import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'providers/review_provider.dart';
import 'models/firestore/review_model.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Movie Poster
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.lightBlue,
                        child: const Icon(
                          Icons.movie,
                          size: 100,
                          color: AppColors.textHint,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.backgroundColor.withOpacity(0.7),
                          AppColors.backgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Movie Details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Year
                  Text(
                    movie.title,
                    style: AppTextStyles.h1.copyWith(fontSize: isSmallScreen ? 28 : 32),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${movie.year}',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Genres
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: movie.genres.map((genre) {
                      return Chip(
                        label: Text(genre, style: AppTextStyles.bodyMedium),
                        backgroundColor: AppColors.lightBlue,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Rating Card with real-time data
                  StreamBuilder<List<ReviewModel>>(
                    stream: Provider.of<ReviewProvider>(context, listen: false)
                        .getMovieReviews(movie.title),
                    builder: (context, snapshot) {
                      final reviews = snapshot.data ?? [];
                      final reviewCount = reviews.length;
                      
                      // Calculate average rating
                      double averageRating = 0.0;
                      if (reviews.isNotEmpty) {
                        double totalRating = 0;
                        for (var review in reviews) {
                          totalRating += review.rating;
                        }
                        averageRating = totalRating / reviews.length;
                      } else {
                        averageRating = movie.rating; // Use default if no reviews
                      }

                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Student Rating',
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.starYellow,
                                  size: 48,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${averageRating.toStringAsFixed(1)} / 5',
                                      style: AppTextStyles.h1.copyWith(fontSize: 36),
                                    ),
                                    Text(
                                      'Based on $reviewCount ${reviewCount == 1 ? 'review' : 'reviews'}',
                                      style: AppTextStyles.subtitle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Synopsis
                  const Text(
                    'Synopsis',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    movie.synopsis,
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Action Buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/review',
                        arguments: movie,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      foregroundColor: AppColors.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Rate and Comment',
                      style: AppTextStyles.button,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Reviews Section with StreamBuilder
                  StreamBuilder<List<ReviewModel>>(
                    stream: Provider.of<ReviewProvider>(context, listen: false)
                        .getMovieReviews(movie.title),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Text(
                            'Error loading reviews: ${snapshot.error}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        );
                      }

                      final reviews = snapshot.data ?? [];
                      final reviewCount = reviews.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/reviews-list',
                                arguments: movie,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.textHint),
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              'View Student Reviews ($reviewCount)',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (reviews.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.lg),
                            const Text(
                              'Recent Reviews',
                              style: AppTextStyles.h2,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ...reviews.take(3).map((review) => Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.md),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          review.userName,
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < review.rating.toInt()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: AppColors.starYellow,
                                            size: 16,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    review.reviewText,
                                    style: AppTextStyles.bodyMedium,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )),
                          ],
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
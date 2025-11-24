import 'package:flutter/material.dart';
import 'movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'user_stats.dart';


class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating(Movie movie) {
    if (_rating == 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Rating Required', style: AppTextStyles.h3),
          content: const Text(
            'Please select a star rating before submitting.',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primaryYellow,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Increment user stats
    UserStats.incrementMoviesRated();
    if (_reviewController.text.isNotEmpty) {
      UserStats.incrementReviewsWritten();
    }

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Review Submitted!', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Thank you for rating ${movie.title}',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: AppColors.starYellow,
                  size: 24,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: AppTextStyles.button.copyWith(
                color: AppColors.primaryYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Rate & Review: ${movie.title}',
          style: AppTextStyles.h3,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rating Section
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your Rating',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                              ),
                              child: Icon(
                                index < _rating ? Icons.star : Icons.star_border,
                                color: AppColors.starYellow,
                                size: 48,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (_rating > 0) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '$_rating / 5 Stars',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primaryYellow,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Review Section
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Review',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _reviewController,
                        maxLines: 8,
                        maxLength: 1000,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts about this movie...',
                          hintStyle: AppTextStyles.subtitle,
                          filled: true,
                          fillColor: AppColors.lightBlue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${_reviewController.text.length}/1000 characters',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Submit Button
                ElevatedButton(
                  onPressed: () => _submitRating(movie),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: AppColors.darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'Submit Rating',
                    style: AppTextStyles.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
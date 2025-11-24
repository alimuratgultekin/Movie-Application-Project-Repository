import 'package:flutter/material.dart';
import 'movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';


class MovieCard extends StatelessWidget {
  final Movie movie;
  final double? width;

  const MovieCard({
    super.key,
    required this.movie,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/movie-detail',
          arguments: movie,
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusMd),
              ),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.network(
                  movie.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.lightBlue,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryYellow,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.lightBlue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie,
                            size: 50,
                            color: AppColors.primaryYellow,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Movie Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${movie.year}',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.starYellow,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${movie.rating}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '(${movie.reviewCount} reviews)',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
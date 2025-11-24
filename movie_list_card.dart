import 'package:flutter/material.dart';
import 'movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class MovieListCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onRemove;

  const MovieListCard({
    super.key,
    required this.movie,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: AppSpacing.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/movie-detail',
            arguments: movie,
          );
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Movie Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Image.network(
                  movie.imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: AppColors.lightBlue,
                      child: const Icon(
                        Icons.movie,
                        color: AppColors.textHint,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Movie Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${movie.year}',
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.starYellow,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${movie.rating}',
                          style: AppTextStyles.bodyMedium.copyWith(
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
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: movie.genres.map((genre) {
                        return Chip(
                          label: Text(
                            genre,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          backgroundColor: AppColors.lightBlue,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Remove Button
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.error,
                ),
                tooltip: 'Remove from list',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
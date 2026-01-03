import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'providers/event_provider.dart';
import 'providers/auth_provider.dart';
import 'models/firestore/event_model.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({super.key});

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
              Icons.event,
              color: AppColors.primaryYellow,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'All Events',
              style: AppTextStyles.h2,
            ),
          ],
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.currentUserId == null) {
            return const Center(
              child: Text('Please login to view events'),
            );
          }

          return StreamBuilder<List<EventModel>>(
            stream: Provider.of<EventProvider>(context, listen: false).getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Error loading events: ${snapshot.error}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final events = snapshot.data ?? [];
              final upcomingEvents = events.where((e) => !e.isPast).toList();
              final pastEvents = events.where((e) => e.isPast).toList();

              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.event_busy,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'No events found',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Be the first to organize a movie night!',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming Events
                    if (upcomingEvents.isNotEmpty) ...[
                      const Text(
                        'Upcoming Events',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: upcomingEvents.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildEventCard(context, upcomingEvents[index], true),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Past Events
                    if (pastEvents.isNotEmpty) ...[
                      const Text(
                        'Past Events',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pastEvents.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildEventCard(context, pastEvents[index], false),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event, bool isUpcoming) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isMyEvent = event.createdBy == authProvider.currentUserId;

    return Card(
      color: AppColors.cardBackground,
      elevation: AppSpacing.elevationMd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Date Badge
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isUpcoming ? AppColors.primaryYellow : AppColors.lightBlue,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.date.day.toString(),
                    style: AppTextStyles.h2.copyWith(
                      color: isUpcoming ? AppColors.darkBlue : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _getMonthName(event.date.month),
                    style: AppTextStyles.caption.copyWith(
                      color: isUpcoming ? AppColors.darkBlue : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Event Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.name,
                          style: AppTextStyles.h3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isMyEvent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'My Event',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryYellow,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    event.movieTitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        event.time,
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${event.attendeeCount} ${event.attendeeCount == 1 ? 'attendee' : 'attendees'}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'by ${event.organizerName}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
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

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}


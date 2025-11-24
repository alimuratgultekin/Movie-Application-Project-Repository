import 'package:flutter/material.dart';
import 'event.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  List<Event> events = Event.getAllEvents();

  void _cancelEvent(String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Cancel Event', style: AppTextStyles.h3),
        content: const Text(
          'Are you sure you want to cancel this event?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                Event.removeEvent(eventId);
                events = Event.getAllEvents();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event cancelled'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              'Yes, Cancel',
              style: AppTextStyles.button.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              event.name,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(Icons.movie, 'Movie', event.movieTitle),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(Icons.calendar_today, 'Date', event.getFormattedDate()),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(Icons.access_time, 'Time', event.time),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(Icons.location_on, 'Location', event.location),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(Icons.people, 'Attendees', '${event.attendeeCount} people'),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invitation sent to group!'),
                    backgroundColor: AppColors.success,
                  ),
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
                'Share Event',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryYellow, size: 20),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = events.where((e) => e.isUpcoming()).toList();
    final pastEvents = events.where((e) => !e.isUpcoming()).toList();
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
            const SizedBox(width: AppSpacing.md),
            const Text(
              'My Events',
              style: AppTextStyles.h2,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/organize-event');
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create New Event',
          ),
        ],
      ),
      body: events.isEmpty
          ? Center(
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
              'No Events Yet',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Create your first movie night!',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/organize-event');
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.darkBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
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
                    child: _buildEventCard(upcomingEvents[index], true),
                  );
                },
              ),
            ],

            // Past Events
            if (pastEvents.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
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
                    child: _buildEventCard(pastEvents[index], false),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, bool isUpcoming) {
    return Card(
      color: AppColors.cardBackground,
      elevation: AppSpacing.elevationMd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: InkWell(
        onTap: () => _viewEventDetails(event),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
                            style: AppTextStyles.h3.copyWith(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (event.isToday())
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'TODAY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.movie, size: 16, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.movieTitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          event.time,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        const Icon(Icons.location_on, size: 16, color: AppColors.textHint),
                        const SizedBox(width: 4),
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
                        const Icon(Icons.people, size: 16, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          '${event.attendeeCount} attending',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              if (isUpcoming)
                IconButton(
                  onPressed: () => _cancelEvent(event.id),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: AppColors.error,
                  ),
                  tooltip: 'Cancel Event',
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
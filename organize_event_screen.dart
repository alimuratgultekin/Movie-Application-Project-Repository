import 'package:flutter/material.dart';
import 'movie.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'event.dart';

class OrganizeEventScreen extends StatefulWidget {
  const OrganizeEventScreen({super.key});

  @override
  State<OrganizeEventScreen> createState() => _OrganizeEventScreenState();
}

class _OrganizeEventScreenState extends State<OrganizeEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedMovie;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryYellow,
              surface: AppColors.cardBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = '${date.day}.${date.month}.${date.year}';
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryYellow,
              surface: AppColors.cardBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _timeController.text = time.format(context);
      });
    }
  }

  void _createEvent() {
    if (_formKey.currentState!.validate() && _selectedMovie != null) {
      // Create new event
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _eventNameController.text,
        movieTitle: _selectedMovie!, // _selectedMovie is already a String (movie title)
        date: _selectedDate,
        time: _selectedTime.format(context),
        location: _locationController.text,
        organizer: 'Student Name',
        attendeeCount: 1,
      );

      // Add to events list
      Event.addEvent(newEvent);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Event Created!', style: AppTextStyles.h3),
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
                'Your movie night "${_eventNameController.text}" has been created successfully!',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'You can view and manage your events from the "My Events" page.',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
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
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/my-events');
              },
              child: Text(
                'View Events',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primaryYellow,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedMovie == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Movie Required', style: AppTextStyles.h3),
          content: const Text(
            'Please select a movie for your event.',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = Movie.getTrendingMovies();
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          'Organize a Movie Night',
          style: AppTextStyles.h2,
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
                // Event Name
                Row(
                  children: [
                    const Icon(Icons.people, color: AppColors.textHint),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('Event Name', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _eventNameController,
                  style: AppTextStyles.bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event name is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'e.g., The Matrix Night',
                    hintStyle: AppTextStyles.subtitle,
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Select Movie
                const Text('Select Movie', style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMovie,
                      hint: const Text(
                        'Choose a movie',
                        style: AppTextStyles.subtitle,
                      ),
                      isExpanded: true,
                      dropdownColor: AppColors.cardBackground,
                      style: AppTextStyles.bodyMedium,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textHint,
                      ),
                      items: movies.map((movie) {
                        return DropdownMenuItem(
                          value: movie.id,
                          child: Text(movie.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMovie = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.textHint),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('Date', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _selectDate,
                  style: AppTextStyles.bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'gg.aa.yyyy',
                    hintStyle: AppTextStyles.subtitle,
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.textHint,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.textHint),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('Time', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: _selectTime,
                  style: AppTextStyles.bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Time is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: '--:--',
                    hintStyle: AppTextStyles.subtitle,
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    suffixIcon: const Icon(
                      Icons.access_time,
                      color: AppColors.textHint,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Location/Platform
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.textHint),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('Location/Platform', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _locationController,
                  style: AppTextStyles.bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'e.g., Campus Dorm Lounge or Zoom Link',
                    hintStyle: AppTextStyles.subtitle,
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Invite Peers Button
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.cardBackground,
                        title: const Text('Invite Peers', style: AppTextStyles.h3),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Invite your friends to this movie night!',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter student email...',
                                hintStyle: AppTextStyles.subtitle,
                                filled: true,
                                fillColor: AppColors.lightBlue,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.email, color: AppColors.textHint),
                              ),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invitation sent!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            child: Text(
                              'Send Invite',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.primaryYellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.group_add),
                  label: const Text('Invite Peers'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textHint),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Create Event Button
                ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: AppColors.darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'Create Event',
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
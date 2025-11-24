class Event {
  final String id;
  final String name;
  final String movieTitle;
  final DateTime date;
  final String time;
  final String location;
  final String organizer;
  final int attendeeCount;

  Event({
    required this.id,
    required this.name,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.attendeeCount,
  });

  // Static list to store created events (in-memory)
  static final List<Event> _events = [
    Event(
      id: '1',
      name: 'Horror Night Marathon',
      movieTitle: 'The Conjuring',
      date: DateTime(2025, 11, 25),
      time: '20:00',
      location: 'Campus Dorm Lounge',
      organizer: 'Student Name',
      attendeeCount: 12,
    ),
    Event(
      id: '2',
      name: 'Sci-Fi Weekend',
      movieTitle: 'Inception',
      date: DateTime(2025, 11, 26),
      time: '19:30',
      location: 'Room 304',
      organizer: 'Student Name',
      attendeeCount: 8,
    ),
    Event(
      id: '3',
      name: 'Classic Cinema Night',
      movieTitle: 'The Dark Knight',
      date: DateTime(2025, 11, 28),
      time: '21:00',
      location: 'Zoom Link',
      organizer: 'Student Name',
      attendeeCount: 15,
    ),
  ];

  static List<Event> getAllEvents() {
    return List.from(_events);
  }

  static void addEvent(Event event) {
    _events.add(event);
  }

  static void removeEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
  }

  static Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  // Format date for display
  String getFormattedDate() {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day.$month.$year';
  }

  // Get day name
  String getDayName() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  // Check if event is today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if event is upcoming
  bool isUpcoming() {
    return date.isAfter(DateTime.now());
  }
}
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'browse_movies_screen.dart';
import 'movie_detail_screen.dart';
import 'review_screen.dart';
import 'chat_groups_screen.dart';
import 'group_chat_screen.dart';
import 'organize_event_screen.dart';
import 'profile_screen.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'my_events_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Movie Buffs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryYellow,
          surface: AppColors.backgroundColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: AppTextStyles.fontFamily,
        useMaterial3: true,
      ),
      // Initial route
      initialRoute: '/login',
      // Named routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/browse': (context) => const BrowseMoviesScreen(),
        '/movie-detail': (context) => const MovieDetailScreen(),
        '/review': (context) => const ReviewScreen(),
        '/chat-groups': (context) => const ChatGroupsScreen(),
        '/group-chat': (context) => const GroupChatScreen(),
        '/organize-event': (context) => const OrganizeEventScreen(),
        '/my-events': (context) => const MyEventsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
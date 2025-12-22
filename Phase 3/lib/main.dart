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

import 'providers/auth_provider.dart';
import 'providers/review_provider.dart';
import 'providers/event_provider.dart';
import 'providers/preferences_provider.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e, stackTrace) {
    print('Firebase initialization error: $e');
    print('Stack trace: $stackTrace');
    // Continue anyway - Firebase might still work
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Use isAuthenticated from provider instead of StreamBuilder
          final isAuthenticated = authProvider.isAuthenticated;

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
            // Initial route based on auth state
            initialRoute: isAuthenticated ? '/home' : '/login',
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
        },
      ),
    );
  }
}
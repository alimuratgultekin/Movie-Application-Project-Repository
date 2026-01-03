# Student Movie Buffs

A Flutter application for students to organize movie nights, rate movies, and connect with peers.

## Project Overview

**Student Movie Buffs** is a social movie platform designed specifically for students to:
- Discover and browse movies
- Rate and review movies
- Organize movie night events with fellow students
- Join chat groups for movie discussions
- Connect with peers who share similar movie interests

### Motivation

This project was developed to create a community-driven platform where students can easily discover new movies, share their opinions, and organize social movie viewing events. The app integrates Firebase for real-time data synchronization, enabling seamless collaboration and social interaction among users.

## Features

- 🔐 **User Authentication**: Secure sign-up and login with Firebase Authentication
- 🎬 **Movie Browsing**: Browse trending movies with detailed information
- ⭐ **Reviews & Ratings**: Rate movies and write reviews to share with the community
- 📅 **Event Organization**: Create and manage movie night events
- 💬 **Chat Groups**: Join discussion groups for movie-related conversations
- 👤 **User Profiles**: Customize your profile and track your movie activity
- 🔍 **Real-time Updates**: Live updates using Firebase Firestore


### Verify Installation

Check your Flutter installation:
```bash
flutter doctor
```

Ensure all required components are properly installed.

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd "Phase 2.2"
```

### Step 2: Install Dependencies

Install all required Flutter packages:
```bash
flutter pub get
```

This will install all dependencies listed in `pubspec.yaml`, including:
- Firebase packages (authentication, Firestore, storage)
- Provider (state management)
- Other required packages

### Step 3: Firebase Configuration

#### 3.1 Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the setup wizard
3. Enable the following services:
   - **Authentication**: Enable Email/Password sign-in method
   - **Firestore Database**: Create a database in production mode (we'll configure rules later)
   - **Storage** (optional, if you plan to use it)

#### 3.2 Configure Android

1. In Firebase Console, go to Project Settings → Your apps → Add app → Android
2. Register your app with package name: `com.example.my_test_app` (or your package name)
3. Download `google-services.json`
4. Place `google-services.json` in `android/app/` directory



#### 3.3 Generate Firebase Options

Run the FlutterFire CLI to automatically configure Firebase:
```bash
flutterfire configure
```

Or manually update `lib/firebase_options.dart` with your Firebase configuration.

#### 3.4 Configure Firestore Security Rules

Deploy Firestore security rules (located in `firestore.rules`):
```bash
firebase deploy --only firestore:rules
```

Make sure you have Firebase CLI installed:
```bash
npm install -g firebase-tools
firebase login
firebase use --add <your-project-id>
```

### Step 4: Run the Application

#### Run on Android Emulator/Device (MacOS)

1. Start an Android emulator or connect a physical device

cd "/Users/sarperdem/Desktop/Phase 2.2" && "$HOME/Library/Android/sdk/emulator/emulator" -avd Medium_Phone_API_36.1 > /dev/null 2>&1 &
flutter run -d emulator-5554
   ```


#### Run on Web (Development)

```bash
flutter run -d chrome
```

## Running Tests

The project includes comprehensive unit tests and widget tests to ensure code quality.

### Run All Tests

To run all tests in the project:
```bash
flutter test
```

### Run Tests with Detailed Output

For more verbose output:
```bash
flutter test --reporter expanded
```

### Run Specific Test Files

To run a specific test file:
```bash
flutter test test/movie_test.dart
flutter test test/widget_test.dart
```

### Test Coverage

The project includes:
- **5 Unit Tests**: Testing the Movie model and its functionality
- **2 Widget Tests**: Testing UI components and theme configuration


### Detailed Test Descriptions

#### Unit Tests (`test/movie_test.dart`)

The unit tests cover the Movie model class and its core functionality:

1. **getTrendingMovies returns a non-empty list**
   - Verifies that the `getTrendingMovies()` method returns a list with at least one movie

2. **getTrendingMovies returns movies with valid data**
   - Tests that all movies in the list have valid and complete data fields (id, title, year, rating, genres, synopsis, imageUrl)
   - Ensures ratings are within valid range (0-5)

3. **getTrendingMovies returns movies with unique IDs**
   - Verifies that each movie has a unique identifier, preventing duplicate entries

4. **getTrendingMovies contains expected movies**
   - Checks that specific movies (e.g., "Inception", "Interstellar") are included in the trending movies list

5. **Movie constructor creates valid movie instance**
   - Tests the Movie class constructor to ensure it properly creates movie instances with all required fields

#### Widget Tests (`test/widget_test.dart`)

The widget tests verify UI components and styling:

1. **App theme uses correct colors**
   - Verifies that the app theme is properly configured with the correct background and primary colors
   - Ensures the scaffold background color matches the app's design system

2. **Text styles are applied correctly**
   - Tests that different text styles (headings, subtitles, body text) are properly applied and rendered
   - Ensures text widgets are displayed correctly in the UI

## Known Limitations

While the application is functional, there are some known limitations and areas for future improvement:

1. **Firebase Dependency**: The app requires an active internet connection and Firebase backend. It cannot function offline.

2. **Review Count Caching**: Review counts are fetched in real-time from Firestore, which may cause slight delays on slower connections.

3. **Platform Support**: The app is primarily tested on Android. iOS testing may require additional configuration.



### Common Issues

**Issue**: Build errors related to dependencies
- **Solution**: Run `flutter clean && flutter pub get` to refresh dependencies



## Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── models/                   # Data models
  ├── providers/                # State management (Provider)
  ├── screens/                  # UI screens
  ├── services/                 # Business logic services
  ├── widgets/                  # Reusable widgets
  └── utils/                    # Utility files (colors, styles, spacing)

test/
  ├── movie_test.dart          # Unit tests for Movie model
  └── widget_test.dart         # Widget tests for UI components
```
## Team Members
- **Ali Murat Gültekin**
- **İsmail Sarp Erdem**
- **Melisa Yağmur Karakurt**
- **Mehmet Alper Canıtez**
- **Doğa Karatay**




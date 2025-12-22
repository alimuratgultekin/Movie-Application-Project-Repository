import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeKey = 'theme_mode';
  static const String _lastTabKey = 'last_tab';
  static const String _onboardingKey = 'onboarding_completed';

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Theme Mode
  Future<bool> saveThemeMode(String mode) async {
    final prefs = await _prefs;
    return await prefs.setString(_themeKey, mode);
  }

  Future<String> getThemeMode() async {
    final prefs = await _prefs;
    return prefs.getString(_themeKey) ?? 'dark';
  }

  // Last Selected Tab
  Future<bool> saveLastTab(int tabIndex) async {
    final prefs = await _prefs;
    return await prefs.setInt(_lastTabKey, tabIndex);
  }

  Future<int> getLastTab() async {
    final prefs = await _prefs;
    return prefs.getInt(_lastTabKey) ?? 0;
  }

  // Onboarding Status
  Future<bool> saveOnboardingStatus(bool completed) async {
    final prefs = await _prefs;
    return await prefs.setBool(_onboardingKey, completed);
  }

  Future<bool> getOnboardingStatus() async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingKey) ?? false;
  }

  // Clear all preferences
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }
}
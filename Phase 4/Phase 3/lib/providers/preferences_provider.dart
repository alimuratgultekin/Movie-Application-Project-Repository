import 'package:flutter/foundation.dart';
import '../../services/preferences_service.dart';

class PreferencesProvider with ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();

  String _themeMode = 'dark';
  int _lastTab = 0;
  bool _onboardingCompleted = false;
  bool _isLoading = false;

  // Getters
  String get themeMode => _themeMode;
  int get lastTab => _lastTab;
  bool get onboardingCompleted => _onboardingCompleted;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _themeMode == 'dark';

  PreferencesProvider() {
    _loadPreferences();
  }

  // Load all preferences
  Future<void> _loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    _themeMode = await _prefsService.getThemeMode();
    _lastTab = await _prefsService.getLastTab();
    _onboardingCompleted = await _prefsService.getOnboardingStatus();

    _isLoading = false;
    notifyListeners();
  }

  // Set theme mode
  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _prefsService.saveThemeMode(mode);
    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == 'dark' ? 'light' : 'dark';
    await _prefsService.saveThemeMode(_themeMode);
    notifyListeners();
  }

  // Set last tab
  Future<void> setLastTab(int tabIndex) async {
    _lastTab = tabIndex;
    await _prefsService.saveLastTab(tabIndex);
    notifyListeners();
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    await _prefsService.saveOnboardingStatus(true);
    notifyListeners();
  }

  // Clear all preferences
  Future<void> clearPreferences() async {
    await _prefsService.clearAll();
    _themeMode = 'dark';
    _lastTab = 0;
    _onboardingCompleted = false;
    notifyListeners();
  }
}
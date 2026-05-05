import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._();

  static const String _themeModeKey = 'theme_mode';
  static final ThemeService instance = ThemeService._();

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeValue = prefs.getString(_themeModeKey);

    if (themeModeValue == 'dark') {
      themeModeNotifier.value = ThemeMode.dark;
      return;
    }

    themeModeNotifier.value = ThemeMode.light;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final newMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    themeModeNotifier.value = newMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, isDarkMode ? 'dark' : 'light');
  }
}

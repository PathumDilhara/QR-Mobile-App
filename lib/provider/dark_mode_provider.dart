import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  final String _themeKey = 'themeMode';
  late Box _box;
  late bool _isDarkMode;

  ThemeProvider() {
    _box = Hive.box('settings');
    _isDarkMode = _box.get(_themeKey, defaultValue: false); // Load the theme from Hive
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.put(_themeKey, _isDarkMode); // Save the new theme to Hive
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}

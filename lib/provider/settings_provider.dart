import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  final String _themeKey = 'themeMode';
  final String _historyKey = "historySaving";
  late Box _box;
  late bool _isDarkMode;
  late bool _isHistorySaving;

  SettingsProvider() {
    _box = Hive.box('settings');
    _isDarkMode = _box.get(_themeKey, defaultValue: false); // Load the theme from Hive
    _isHistorySaving = _box.get(_historyKey, defaultValue: true);
  }

  bool get isDarkMode => _isDarkMode;
  bool get isHistorySaving => _isHistorySaving;

  // Inbuilt parameters relevant to dark, light theme are in  main file and they
  // are implemented in a separate file
  // when we call them load the data that we defined
  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.put(_themeKey, _isDarkMode); // Save the new theme to Hive
    notifyListeners(); // Notify listeners to rebuild the UI with ThemeProvider Consumer
  }

  void toggleHistorySaving(){
    _isHistorySaving = !_isHistorySaving;
    _box.put(_historyKey, _isHistorySaving);
    notifyListeners();
  }
}

// you don't need an adapter to store a simple bool value in Hive. Hive natively
// supports basic data types like bool, int, double, String, List, and Map. For
// storing a single bool value (such as for dark mode on/off), you can directly
// open a box and put the data without needing an adapter.
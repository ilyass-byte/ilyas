import 'package:flutter/material.dart';

class SettingsManager extends ChangeNotifier {
  static final SettingsManager _instance = SettingsManager._internal();
  factory SettingsManager() => _instance;
  SettingsManager._internal();

  static SettingsManager get instance => _instance;

  // Settings state
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedLanguage => _selectedLanguage;

  // Theme data
  ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.white,
    dialogTheme: const DialogTheme(backgroundColor: Colors.white),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF667EEA),
      secondary: Color(0xFF764BA2),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2D3748),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF2D3748)),
      bodyMedium: TextStyle(color: Color(0xFF2D3748)),
      titleLarge: TextStyle(color: Color(0xFF2D3748)),
      titleMedium: TextStyle(color: Color(0xFF2D3748)),
      titleSmall: TextStyle(color: Color(0xFF2D3748)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161B22),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF161B22),
    dialogTheme: const DialogTheme(backgroundColor: Color(0xFF161B22)),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF667EEA),
      secondary: Color(0xFF764BA2),
      surface: Color(0xFF161B22),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE6EDF3),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE6EDF3)),
      bodyMedium: TextStyle(color: Color(0xFFE6EDF3)),
      titleLarge: TextStyle(color: Color(0xFFE6EDF3)),
      titleMedium: TextStyle(color: Color(0xFFE6EDF3)),
      titleSmall: TextStyle(color: Color(0xFFE6EDF3)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),
    ),
  );

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Setters
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  // Toggle methods
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}

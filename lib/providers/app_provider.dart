import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String _currentSection = 'dashboard';
  bool _isDarkMode = false;

  String get currentSection => _currentSection;
  bool get isDarkMode => _isDarkMode;

  void setCurrentSection(String section) {
    _currentSection = section;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

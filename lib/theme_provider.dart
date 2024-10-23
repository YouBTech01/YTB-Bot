import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _dynamicColorEnabled = false;
  double _fontSize = 16.0;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get dynamicColorEnabled => _dynamicColorEnabled;
  double get fontSize => _fontSize;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void toggleDynamicColor(bool enabled) {
    _dynamicColorEnabled = enabled;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
}

// lib/providers/theme_provider.dart
// ------------------------------------------------------
// 🎨 THEME PROVIDER - QUẢN LÝ TRẠNG THÁI GIAO DIỆN
// - Quản lý theme hiện tại (light/dark)
// - Lưu trữ tùy chọn giao diện của người dùng
// - Thay đổi theme động
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/modern_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = AppTheme.primaryColor;
  int _selectedColorIndex = 0;

  // Getters
  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  int get selectedColorIndex => _selectedColorIndex;

  ThemeData get currentTheme {
    // Sử dụng Modern Theme mới
    return _isDarkMode ? ModernTheme.darkTheme : ModernTheme.lightTheme;
  }

  // Khởi tạo từ SharedPreferences hoặc default
  void initializeTheme({bool? isDarkMode, int? colorIndex}) {
    _isDarkMode = isDarkMode ?? false;
    _selectedColorIndex = colorIndex ?? 0;
    _primaryColor = AppTheme.getColorFromIndex(_selectedColorIndex);
    notifyListeners();
  }

  // Chuyển đổi dark/light mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _saveThemeSettings();
  }

  // Đặt theme mode
  void setThemeMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
    _saveThemeSettings();
  }

  // Thay đổi màu chủ đạo
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _selectedColorIndex = AppTheme.customColors.indexOf(color);
    if (_selectedColorIndex == -1) {
      _selectedColorIndex = 0; // Default to first color if not found
    }
    notifyListeners();
    _saveThemeSettings();
  }

  // Thay đổi màu theo index
  void setPrimaryColorByIndex(int index) {
    if (index >= 0 && index < AppTheme.customColors.length) {
      _selectedColorIndex = index;
      _primaryColor = AppTheme.getColorFromIndex(index);
      notifyListeners();
      _saveThemeSettings();
    }
  }

  // Reset về theme mặc định
  void resetToDefault() {
    _isDarkMode = false;
    _selectedColorIndex = 0;
    _primaryColor = AppTheme.primaryColor;
    notifyListeners();
    _saveThemeSettings();
  }

  // Lưu cài đặt theme (mock implementation)
  void _saveThemeSettings() {
    // TODO: Implement SharedPreferences hoặc local storage
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setBool('isDarkMode', _isDarkMode);
    //   prefs.setInt('primaryColorIndex', _selectedColorIndex);
    // });
  }

  // Lấy danh sách màu sắc có sẵn
  List<Color> get availableColors => AppTheme.customColors;

  // Lấy tên màu hiện tại
  String get currentColorName => AppTheme.getColorName(_primaryColor);
}

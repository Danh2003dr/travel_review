// lib/providers/language_provider.dart
// ------------------------------------------------------
// 🌍 LANGUAGE PROVIDER - QUẢN LÝ NGÔN NGỮ
// - Quản lý ngôn ngữ hiện tại của ứng dụng
// - Hỗ trợ đa ngôn ngữ (Tiếng Việt, English)
// - Lưu trữ cài đặt ngôn ngữ
// ------------------------------------------------------

import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('vi', 'VN');

  // Danh sách ngôn ngữ hỗ trợ
  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(
      locale: Locale('vi', 'VN'),
      name: 'Tiếng Việt',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
    LanguageOption(
      locale: Locale('en', 'US'),
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
  ];

  // Getters
  Locale get currentLocale => _currentLocale;
  LanguageOption get currentLanguage =>
      supportedLanguages.firstWhere((lang) => lang.locale == _currentLocale);

  // Thay đổi ngôn ngữ
  void setLanguage(Locale locale) {
    if (supportedLanguages.any((lang) => lang.locale == locale)) {
      _currentLocale = locale;
      notifyListeners();
      _saveLanguageSettings();
    }
  }

  // Thay đổi ngôn ngữ theo index
  void setLanguageByIndex(int index) {
    if (index >= 0 && index < supportedLanguages.length) {
      setLanguage(supportedLanguages[index].locale);
    }
  }

  // Lưu cài đặt ngôn ngữ (mock implementation)
  void _saveLanguageSettings() {
    // TODO: Implement SharedPreferences hoặc local storage
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setString('language_code', _currentLocale.languageCode);
    //   prefs.setString('country_code', _currentLocale.countryCode ?? '');
    // });
  }

  // Khởi tạo ngôn ngữ từ storage
  void initializeLanguage() {
    // TODO: Load from SharedPreferences
    // SharedPreferences.getInstance().then((prefs) {
    //   final languageCode = prefs.getString('language_code') ?? 'vi';
    //   final countryCode = prefs.getString('country_code') ?? 'VN';
    //   _currentLocale = Locale(languageCode, countryCode);
    //   notifyListeners();
    // });
  }

  // Lấy danh sách ngôn ngữ có sẵn
  List<LanguageOption> get availableLanguages => supportedLanguages;
}

// Class chứa thông tin ngôn ngữ
class LanguageOption {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  String get displayName => '$flag $nativeName';
}

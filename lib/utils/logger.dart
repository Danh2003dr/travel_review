// lib/utils/logger.dart
// ------------------------------------------------------
// 📝 LOGGING UTILITY
// - Thay thế print statements bằng logging có cấu trúc
// - Hỗ trợ debug, info, warning, error levels
// - Có thể bật/tắt logging trong production
// ------------------------------------------------------

import 'package:flutter/foundation.dart';

/// Logging utility class để thay thế print statements
class Logger {
  // Có thể bật/tắt logging trong production
  static const bool _isLoggingEnabled = kDebugMode;

  /// Log thông tin debug
  static void debug(String message, [String? tag]) {
    if (_isLoggingEnabled) {
      final prefix = tag != null ? '[DEBUG][$tag]' : '[DEBUG]';
      debugPrint('$prefix $message');
    }
  }

  /// Log thông tin thông thường
  static void info(String message, [String? tag]) {
    if (_isLoggingEnabled) {
      final prefix = tag != null ? '[INFO][$tag]' : '[INFO]';
      debugPrint('$prefix $message');
    }
  }

  /// Log cảnh báo
  static void warning(String message, [String? tag]) {
    if (_isLoggingEnabled) {
      final prefix = tag != null ? '[WARNING][$tag]' : '[WARNING]';
      debugPrint('$prefix $message');
    }
  }

  /// Log lỗi
  static void error(String message, [String? tag, dynamic error]) {
    if (_isLoggingEnabled) {
      final prefix = tag != null ? '[ERROR][$tag]' : '[ERROR]';
      debugPrint('$prefix $message');
      if (error != null) {
        debugPrint('$prefix Error details: $error');
      }
    }
  }

  /// Log thành công
  static void success(String message, [String? tag]) {
    if (_isLoggingEnabled) {
      final prefix = tag != null ? '[SUCCESS][$tag]' : '[SUCCESS]';
      debugPrint('$prefix $message');
    }
  }
}

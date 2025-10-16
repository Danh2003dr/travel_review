// lib/constants/app_constants.dart
// ------------------------------------------------------
// 📐 APP CONSTANTS
// - Tập trung tất cả các hằng số của ứng dụng
// - Dễ dàng thay đổi và bảo trì
// - Tránh magic numbers và strings
// ------------------------------------------------------

/// Các hằng số UI cho toàn bộ ứng dụng
class AppConstants {
  // Không cho phép khởi tạo class này
  AppConstants._();

  // ------------------------------------------------------
  // 🎨 UI CONSTANTS
  // ------------------------------------------------------

  /// Khoảng cách giữa các section
  static const double sectionSpacing = 24.0;

  /// Khoảng cách giữa các card
  static const double cardSpacing = 16.0;

  /// Khoảng cách giữa các category
  static const double categorySpacing = 12.0;

  /// Chiều cao hero section
  static const double heroHeight = 260.0;

  /// Chiều cao search bar
  static const double searchBarHeight = 56.0;

  /// Kích thước category icon
  static const double categorySize = 80.0;

  /// Border radius mặc định
  static const double defaultBorderRadius = 16.0;

  /// Border radius nhỏ
  static const double smallBorderRadius = 8.0;

  /// Border radius lớn
  static const double largeBorderRadius = 24.0;

  // ------------------------------------------------------
  // 📱 RESPONSIVE BREAKPOINTS
  // ------------------------------------------------------

  /// Breakpoint cho mobile
  static const double mobileBreakpoint = 600.0;

  /// Breakpoint cho tablet
  static const double tabletBreakpoint = 1024.0;

  // ------------------------------------------------------
  // 🕒 TIMEOUT VALUES
  // ------------------------------------------------------

  /// Timeout cho network requests
  static const Duration networkTimeout = Duration(seconds: 30);

  /// Timeout cho Firebase operations
  static const Duration firebaseTimeout = Duration(seconds: 15);

  // ------------------------------------------------------
  // 📝 TEXT CONSTANTS
  // ------------------------------------------------------

  /// Text mặc định cho empty states
  static const String emptyReviewsText = 'Chưa có đánh giá nào';
  static const String emptyFavoritesText = 'Chưa có địa điểm yêu thích nào';
  static const String emptyPlacesText = 'Không tìm thấy địa điểm nào';

  /// Loading text
  static const String loadingText = 'Đang tải...';
  static const String refreshingText = 'Đang làm mới...';

  // ------------------------------------------------------
  // 🖼️ IMAGE CONSTANTS
  // ------------------------------------------------------

  /// Placeholder image URL
  static const String placeholderImageUrl =
      'https://via.placeholder.com/300x200';

  /// Default avatar URL
  static const String defaultAvatarUrl = 'https://i.pravatar.cc/200';

  /// Max file size cho upload (5MB)
  static const int maxFileSize = 5 * 1024 * 1024;

  // ------------------------------------------------------
  // 🔐 AUTH CONSTANTS
  // ------------------------------------------------------

  /// Min password length
  static const int minPasswordLength = 6;

  /// Max password length
  static const int maxPasswordLength = 50;

  /// Min name length
  static const int minNameLength = 2;

  /// Max name length
  static const int maxNameLength = 50;

  // ------------------------------------------------------
  // 📊 PAGINATION
  // ------------------------------------------------------

  /// Items per page
  static const int itemsPerPage = 20;

  /// Max items to load at once
  static const int maxItemsPerLoad = 100;

  // ------------------------------------------------------
  // 🗺️ MAP CONSTANTS
  // ------------------------------------------------------

  /// Default zoom level
  static const double defaultZoomLevel = 10.0;

  /// Min zoom level
  static const double minZoomLevel = 5.0;

  /// Max zoom level
  static const double maxZoomLevel = 18.0;

  /// Cluster radius
  static const double clusterRadius = 80.0;

  /// Cluster size
  static const double clusterSize = 40.0;
}

/// Các route constants
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String phoneAuth = '/phone-auth';
  static const String emailVerification = '/email-verification';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String placeDetail = '/place-detail';
  static const String writeReview = '/write-review';
  static const String map = '/map';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String reviews = '/reviews';
}

/// Các animation durations
class AnimationDurations {
  AnimationDurations._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}

/// Các error messages
class ErrorMessages {
  ErrorMessages._();

  static const String networkError = 'Lỗi kết nối mạng. Vui lòng thử lại.';
  static const String unknownError = 'Đã xảy ra lỗi không xác định.';
  static const String authError = 'Lỗi xác thực. Vui lòng đăng nhập lại.';
  static const String permissionError =
      'Bạn không có quyền thực hiện hành động này.';
  static const String validationError = 'Dữ liệu không hợp lệ.';
}

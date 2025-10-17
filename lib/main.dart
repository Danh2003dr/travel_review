// lib/main.dart
// ------------------------------------------------------
// ✨ ỨNG DỤNG REVIEW DU LỊCH (UI-first, Mock Data)
// - Gộp main.dart + app.dart: dễ chạy, dễ quản lý.
// - Chỉ cần đổi repo trong repo_provider.dart là dùng dữ liệu thật.
// ------------------------------------------------------

// lib/
//  ├─ main.dart
//  ├─ di/repo_provider.dart
//  ├─ data/
//  │   ├─ place_repository.dart
//  │   └─ in_memory_place_repository.dart
//  ├─ models/
//  │   ├─ place.dart
//  │   └─ review.dart
//  ├─ features/
//  │   ├─ home/home_screen.dart
//  │   ├─ search/search_screen.dart
//  │   ├─ place/place_detail_screen.dart
//  │   ├─ map/map_screen.dart
//  │   └─ profile/profile_screen.dart
//  ├─ widgets/
//  │   ├─ place_card.dart
//  │   ├─ type_chip.dart
//  │   ├─ section_header.dart
//  │   ├─ rating_stars.dart
//  │   ├─ hero_image.dart
//  │   ├─ review_tile.dart
//  │   ├─ empty_view.dart
//  │   └─ skeletons/place_skeleton.dart
//  └─ utils/date_format.dart hãy chú thích vai trò từng file

// Cài thư viện: flutter pub get

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home/home_screen_modern.dart';
import 'features/map/map_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/search/search_screen_modern.dart';
import 'features/explore/explore_screen.dart';
// Removed unused import
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/about/about_screen.dart';
import 'features/help/help_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/theme/theme_customization_screen.dart';
import 'features/legal/privacy_policy_screen.dart';
import 'features/legal/terms_of_service_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/phone_auth_screen.dart';
import 'features/auth/email_verification_screen.dart';
import 'features/map/enhanced_map_screen.dart';
import 'features/search/enhanced_search_screen.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/reviews_provider.dart';

// Services
import 'services/firebase_service.dart';
import 'utils/firebase_test.dart';

// ------------------------------------------------------
// 🚀 MAIN - KHỞI TẠO FIREBASE VÀ CHẠY ỨNG DỤNG
// ------------------------------------------------------
void main() async {
  // Đảm bảo Flutter bindings đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  try {
    await FirebaseService().initialize();
    print('✅ Firebase khởi tạo thành công');

    // Test kết nối Firebase (chỉ trong development)
    await FirebaseTest.printTestResults();
  } catch (e) {
    print('❌ Lỗi khởi tạo Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => ReviewsProvider()),
      ],
      child: const TravelReviewApp(),
    ),
  );
}

// ------------------------------------------------------
// 🧭 TravelReviewApp – cấu hình MaterialApp + theme
// ------------------------------------------------------
class TravelReviewApp extends StatelessWidget {
  const TravelReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel Review',
          theme: themeProvider.currentTheme,
          home: const LoginScreen(), // Đi thẳng đến login để test
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/main': (context) => const AppShell(),
            '/search': (context) =>
                const SearchScreenModern(initKeyword: '', initType: ''),
            '/settings': (context) => const SettingsScreen(),
            '/about': (context) => const AboutScreen(),
            '/help': (context) => const HelpScreen(),
            '/favorites': (context) => const FavoritesScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/theme': (context) => const ThemeCustomizationScreen(),
            '/privacy': (context) => const PrivacyPolicyScreen(),
            '/terms': (context) => const TermsOfServiceScreen(),
            '/enhanced-map': (context) => const EnhancedMapScreen(),
            '/enhanced-search': (context) => const EnhancedSearchScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/phone-auth': (context) => const PhoneAuthScreen(),
            '/email-verification': (context) => const EmailVerificationScreen(),
          },
        );
      },
    );
  }
}

// ------------------------------------------------------
// 🧩 AppShell – khung chính (Scaffold + NavigationBar)
// ------------------------------------------------------
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  // Danh sách 5 màn hình chính
  final _pages = [ 
    const HomeScreenModern(), // Giữ const cho constructor nếu có thể
    const ExploreScreen(),    // Giữ const cho constructor nếu có thể
    const SearchScreenModern(initKeyword: '', initType: ''), // Giữ const cho constructor nếu có thể
    const MapScreen(),        // THÊM const cho constructor (Nếu nó là StatelessWidget/StatefulWidget)
    const ProfileScreen(),    // THÊM const cho constructor (Nếu nó là StatelessWidget/StatefulWidget)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Khám phá',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}

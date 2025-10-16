// lib/features/onboarding/onboarding_screen.dart
// ------------------------------------------------------
// 🎯 ONBOARDING SCREEN - MÀN HÌNH GIỚI THIỆU
// - Giới thiệu ứng dụng cho người dùng mới
// - Hướng dẫn các tính năng chính
// - Slider với animation đẹp mắt
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../widgets/animated_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Khám phá địa điểm du lịch',
      description:
          'Tìm hiểu những địa điểm du lịch tuyệt vời từ những đánh giá chân thực của cộng đồng',
      image: Icons.explore,
      color: Colors.blue,
    ),
    OnboardingData(
      title: 'Đánh giá và chia sẻ',
      description:
          'Viết đánh giá chi tiết và chia sẻ trải nghiệm của bạn với mọi người',
      image: Icons.rate_review,
      color: Colors.green,
    ),
    OnboardingData(
      title: 'Lưu địa điểm yêu thích',
      description:
          'Lưu lại những địa điểm bạn quan tâm và tạo danh sách riêng của mình',
      image: Icons.favorite,
      color: Colors.red,
    ),
    OnboardingData(
      title: 'Bản đồ thông minh',
      description:
          'Xem vị trí địa điểm trên bản đồ và lập kế hoạch hành trình hoàn hảo',
      image: Icons.map,
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text('Bỏ qua'),
                  ),
                ],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return AnimatedCard(
                    delay: Duration(milliseconds: index * 200),
                    child: _buildOnboardingPage(data),
                  );
                },
              ),
            ),

            // Bottom navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Trước'),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next/Get Started button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _currentPage == _onboardingData.length - 1
                          ? _startApp
                          : _nextPage,
                      icon: Icon(
                        _currentPage == _onboardingData.length - 1
                            ? Icons.rocket_launch
                            : Icons.arrow_forward,
                      ),
                      label: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'Bắt đầu'
                            : 'Tiếp theo',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng trang onboarding
  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: data.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(data.image, size: 100, color: data.color),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: data.color,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // Feature highlights
          _buildFeatureHighlights(data),
        ],
      ),
    );
  }

  // Widget hiển thị các tính năng nổi bật
  Widget _buildFeatureHighlights(OnboardingData data) {
    List<String> highlights = [];

    switch (data.title) {
      case 'Khám phá địa điểm du lịch':
        highlights = [
          'Tìm kiếm thông minh',
          'Đánh giá chân thực',
          'Ảnh chất lượng cao',
        ];
        break;
      case 'Đánh giá và chia sẻ':
        highlights = ['Viết review dễ dàng', 'Chia sẻ ảnh', 'Đánh giá sao'];
        break;
      case 'Lưu địa điểm yêu thích':
        highlights = [
          'Danh sách cá nhân',
          'Đồng bộ đám mây',
          'Chia sẻ với bạn bè',
        ];
        break;
      case 'Bản đồ thông minh':
        highlights = ['Vị trí chính xác', 'Hướng dẫn đường đi', 'Tích hợp GPS'];
        break;
    }

    return Column(
      children: highlights
          .map(
            (highlight) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: data.color, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    highlight,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // Chuyển đến trang tiếp theo
  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Chuyển về trang trước
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Bỏ qua onboarding
  void _skipOnboarding() {
    _startApp();
  }

  // Bắt đầu sử dụng ứng dụng
  void _startApp() {
    // TODO: Lưu trạng thái đã xem onboarding và chuyển đến màn hình chính
    Navigator.of(context).pushReplacementNamed('/main');
  }
}

// Class chứa dữ liệu onboarding
class OnboardingData {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

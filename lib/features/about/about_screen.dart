// lib/features/about/about_screen.dart
// ------------------------------------------------------
// ℹ️ ABOUT SCREEN - MÀN HÌNH GIỚI THIỆU ỨNG DỤNG
// - Thông tin về ứng dụng và phiên bản
// - Liên kết đến các trang chính sách
// - Thông tin nhà phát triển
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App info card
            _buildAppInfoCard(context),

            const SizedBox(height: 24),

            // Features section
            _buildFeaturesSection(context),

            const SizedBox(height: 24),

            // Legal links
            _buildLegalSection(context),

            const SizedBox(height: 24),

            // Developer info
            _buildDeveloperSection(context),

            const SizedBox(height: 24),

            // Version info
            _buildVersionSection(context),
          ],
        ),
      ),
    );
  }

  // Card thông tin ứng dụng
  Widget _buildAppInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.travel_explore,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Travel Review',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Ứng dụng đánh giá địa điểm du lịch',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'Khám phá thế giới qua những đánh giá chân thực từ cộng đồng. '
              'Tìm kiếm, đánh giá và chia sẻ trải nghiệm du lịch của bạn.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Section tính năng
  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.search,
        'title': 'Tìm kiếm thông minh',
        'desc': 'Tìm địa điểm du lịch phù hợp',
      },
      {
        'icon': Icons.rate_review,
        'title': 'Đánh giá chi tiết',
        'desc': 'Chia sẻ trải nghiệm của bạn',
      },
      {
        'icon': Icons.favorite,
        'title': 'Lưu yêu thích',
        'desc': 'Tạo danh sách địa điểm quan tâm',
      },
      {
        'icon': Icons.map,
        'title': 'Bản đồ tích hợp',
        'desc': 'Xem vị trí và lập kế hoạch',
      },
      {
        'icon': Icons.photo_camera,
        'title': 'Chia sẻ ảnh',
        'desc': 'Upload và xem ảnh địa điểm',
      },
      {
        'icon': Icons.group,
        'title': 'Cộng đồng',
        'desc': 'Kết nối với du khách khác',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tính năng nổi bật',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['desc'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Section các liên kết pháp lý
  Widget _buildLegalSection(BuildContext context) {
    final legalItems = [
      {'title': 'Chính sách bảo mật', 'route': '/privacy'},
      {'title': 'Điều khoản sử dụng', 'route': '/terms'},
      {'title': 'Giấy phép mã nguồn', 'route': '/licenses'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin pháp lý',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...legalItems.map(
          (item) => Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: Text(item['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to respective screens
                switch (item['route']) {
                  case '/privacy':
                    Navigator.pushNamed(context, '/privacy');
                    break;
                  case '/terms':
                    Navigator.pushNamed(context, '/terms');
                    break;
                  case '/licenses':
                    _showLicenses(context);
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item['title']} sẽ sớm có mặt'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Section thông tin nhà phát triển
  Widget _buildDeveloperSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhà phát triển',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.code,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Development Team',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phát triển với ❤️ bằng Flutter',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildSocialButton(
                            context,
                            Icons.email,
                            'Email',
                            () => _showComingSoon(context),
                          ),
                          const SizedBox(width: 8),
                          _buildSocialButton(
                            context,
                            Icons.code,
                            'GitHub',
                            () => _showComingSoon(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section thông tin phiên bản
  Widget _buildVersionSection(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Phiên bản'),
                Text(
                  '1.0.0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Build'), const Text('2024.01.01')],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Flutter'), const Text('3.x')],
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('© 2024 Travel Review'),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: 'Travel Review App'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã sao chép tên ứng dụng'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Sao chép'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget nút mạng xã hội
  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).primaryColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị thông báo "sắp có"
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng này sẽ sớm có mặt'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Hiển thị licenses
  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Travel Review',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.travel_explore,
        color: Theme.of(context).primaryColor,
        size: 48,
      ),
    );
  }
}

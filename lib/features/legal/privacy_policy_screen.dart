// lib/features/legal/privacy_policy_screen.dart
// ------------------------------------------------------
// 🔒 PRIVACY POLICY SCREEN - MÀN HÌNH CHÍNH SÁCH BẢO MẬT
// - Hiển thị chính sách bảo mật của ứng dụng
// - Thông tin về thu thập và sử dụng dữ liệu
// - Quyền lợi của người dùng
// ------------------------------------------------------

import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chính sách bảo mật'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),

            const SizedBox(height: 24),

            // Last updated
            _buildLastUpdated(),

            const SizedBox(height: 24),

            // Sections
            _buildSection(
              context,
              '1. Thu thập thông tin',
              'Chúng tôi thu thập thông tin bạn cung cấp trực tiếp khi sử dụng ứng dụng, bao gồm:\n\n'
                  '• Thông tin tài khoản: tên, email, ảnh đại diện\n'
                  '• Nội dung đánh giá: bài viết, ảnh, đánh giá sao\n'
                  '• Thông tin vị trí: để hiển thị địa điểm gần bạn\n'
                  '• Dữ liệu sử dụng: thời gian, tính năng được sử dụng',
            ),

            _buildSection(
              context,
              '2. Sử dụng thông tin',
              'Chúng tôi sử dụng thông tin để:\n\n'
                  '• Cung cấp và cải thiện dịch vụ\n'
                  '• Hiển thị đánh giá và địa điểm phù hợp\n'
                  '• Gửi thông báo quan trọng\n'
                  '• Phân tích xu hướng sử dụng\n'
                  '• Bảo vệ quyền lợi người dùng',
            ),

            _buildSection(
              context,
              '3. Chia sẻ thông tin',
              'Chúng tôi KHÔNG bán thông tin cá nhân của bạn. Thông tin chỉ được chia sẻ khi:\n\n'
                  '• Có sự đồng ý của bạn\n'
                  '• Để tuân thủ pháp luật\n'
                  '• Với nhà cung cấp dịch vụ tin cậy\n'
                  '• Trong trường hợp sáp nhập công ty',
            ),

            _buildSection(
              context,
              '4. Bảo mật dữ liệu',
              'Chúng tôi áp dụng các biện pháp bảo mật:\n\n'
                  '• Mã hóa dữ liệu trong quá trình truyền\n'
                  '• Bảo mật server với firewall\n'
                  '• Kiểm tra bảo mật định kỳ\n'
                  '• Đào tạo nhân viên về bảo mật\n'
                  '• Sao lưu dữ liệu an toàn',
            ),

            _buildSection(
              context,
              '5. Quyền của bạn',
              'Bạn có quyền:\n\n'
                  '• Xem thông tin cá nhân\n'
                  '• Chỉnh sửa thông tin\n'
                  '• Xóa tài khoản\n'
                  '• Rút lại sự đồng ý\n'
                  '• Yêu cầu xuất dữ liệu\n'
                  '• Khiếu nại về việc xử lý dữ liệu',
            ),

            _buildSection(
              context,
              '6. Cookie và công nghệ theo dõi',
              'Ứng dụng có thể sử dụng:\n\n'
                  '• Cookie để ghi nhớ tùy chọn\n'
                  '• Local storage để lưu cài đặt\n'
                  '• Analytics để cải thiện trải nghiệm\n'
                  '• Không theo dõi hành vi cá nhân',
            ),

            _buildSection(
              context,
              '7. Trẻ em',
              'Ứng dụng không dành cho trẻ em dưới 13 tuổi. '
                  'Chúng tôi không cố ý thu thập thông tin từ trẻ em dưới 13 tuổi.',
            ),

            _buildSection(
              context,
              '8. Thay đổi chính sách',
              'Chúng tôi có thể cập nhật chính sách này. '
                  'Thay đổi quan trọng sẽ được thông báo qua ứng dụng hoặc email.',
            ),

            const SizedBox(height: 24),

            // Contact info
            _buildContactSection(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Widget header
  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.privacy_tip,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Chính sách bảo mật',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Travel Review App',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ngày cập nhật
  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.update, color: Colors.orange[700], size: 20),
          const SizedBox(width: 8),
          Text(
            'Cập nhật lần cuối: 01/01/2024',
            style: TextStyle(
              color: Colors.orange[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget section
  Widget _buildSection(BuildContext context, String title, String content) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              content,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  // Widget thông tin liên hệ
  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_support,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Liên hệ hỗ trợ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildContactItem(
              context,
              Icons.email,
              'Email',
              'support@travelreview.app',
              () => _showComingSoon(context),
            ),

            _buildContactItem(
              context,
              Icons.phone,
              'Điện thoại',
              '+84 123 456 789',
              () => _showComingSoon(context),
            ),

            _buildContactItem(
              context,
              Icons.web,
              'Website',
              'www.travelreview.app',
              () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  // Widget item liên hệ
  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
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
}

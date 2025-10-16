// lib/features/legal/terms_of_service_screen.dart
// ------------------------------------------------------
// 📋 TERMS OF SERVICE SCREEN - MÀN HÌNH ĐIỀU KHOẢN SỬ DỤNG
// - Hiển thị điều khoản sử dụng của ứng dụng
// - Quyền và nghĩa vụ của người dùng
// - Điều khoản chấm dứt dịch vụ
// ------------------------------------------------------

import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều khoản sử dụng'),
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

            // Agreement notice
            _buildAgreementNotice(context),

            const SizedBox(height: 24),

            // Sections
            _buildSection(
              context,
              '1. Chấp nhận điều khoản',
              'Bằng việc sử dụng ứng dụng Travel Review, bạn đồng ý tuân thủ các điều khoản này. '
                  'Nếu bạn không đồng ý, vui lòng không sử dụng ứng dụng.\n\n'
                  'Chúng tôi có thể cập nhật điều khoản này bất kỳ lúc nào. '
                  'Việc tiếp tục sử dụng sau khi có thay đổi được coi là chấp nhận điều khoản mới.',
            ),

            _buildSection(
              context,
              '2. Mô tả dịch vụ',
              'Travel Review là ứng dụng:\n\n'
                  '• Tìm kiếm và khám phá địa điểm du lịch\n'
                  '• Đọc và viết đánh giá về địa điểm\n'
                  '• Chia sẻ ảnh và trải nghiệm\n'
                  '• Lưu địa điểm yêu thích\n'
                  '• Xem bản đồ và định vị\n\n'
                  'Dịch vụ được cung cấp "như hiện tại" và có thể thay đổi mà không cần thông báo trước.',
            ),

            _buildSection(
              context,
              '3. Tài khoản người dùng',
              'Để sử dụng một số tính năng, bạn cần:\n\n'
                  '• Tạo tài khoản với thông tin chính xác\n'
                  '• Bảo mật mật khẩu và tài khoản\n'
                  '• Thông báo ngay khi phát hiện vi phạm\n'
                  '• Chịu trách nhiệm cho mọi hoạt động trên tài khoản\n\n'
                  'Chúng tôi có quyền từ chối hoặc chấm dứt tài khoản vi phạm.',
            ),

            _buildSection(
              context,
              '4. Nội dung người dùng',
              'Bạn có trách nhiệm về nội dung đăng tải:\n\n'
                  '• Nội dung phải chính xác và không vi phạm pháp luật\n'
                  '• Không spam, quấy rối hoặc lừa đảo\n'
                  '• Không vi phạm bản quyền hoặc quyền sở hữu trí tuệ\n'
                  '• Không đăng nội dung không phù hợp\n\n'
                  'Chúng tôi có quyền xóa nội dung vi phạm mà không cần thông báo.',
            ),

            _buildSection(
              context,
              '5. Quyền sở hữu trí tuệ',
              'Ứng dụng và nội dung thuộc về Travel Review App:\n\n'
                  '• Giao diện và thiết kế ứng dụng\n'
                  '• Logo, thương hiệu và nhãn hiệu\n'
                  '• Phần mềm và mã nguồn\n'
                  '• Cơ sở dữ liệu và thuật toán\n\n'
                  'Bạn không được sao chép, phân phối hoặc sử dụng thương mại mà không có sự đồng ý.',
            ),

            _buildSection(
              context,
              '6. Cấm và hạn chế',
              'Khi sử dụng ứng dụng, bạn KHÔNG được:\n\n'
                  '• Vi phạm pháp luật hoặc quy định\n'
                  '• Đăng nội dung sai sự thật hoặc gây hiểu lầm\n'
                  '• Quấy rối, đe dọa hoặc lạm dụng người khác\n'
                  '• Sử dụng bot hoặc công cụ tự động\n'
                  '• Khai thác lỗ hổng bảo mật\n'
                  '• Đăng nội dung khiêu dâm hoặc bạo lực',
            ),

            _buildSection(
              context,
              '7. Chấm dứt dịch vụ',
              'Chúng tôi có quyền chấm dứt hoặc tạm dừng dịch vụ:\n\n'
                  '• Khi phát hiện vi phạm điều khoản\n'
                  '• Để bảo trì hoặc nâng cấp hệ thống\n'
                  '• Khi có yêu cầu từ cơ quan pháp luật\n'
                  '• Vì lý do kỹ thuật hoặc kinh doanh\n\n'
                  'Bạn có thể xóa tài khoản bất kỳ lúc nào.',
            ),

            _buildSection(
              context,
              '8. Miễn trừ trách nhiệm',
              'Ứng dụng được cung cấp "như hiện tại". Chúng tôi không đảm bảo:\n\n'
                  '• Dịch vụ không bị gián đoạn\n'
                  '• Thông tin luôn chính xác\n'
                  '• Không có lỗi hoặc virus\n'
                  '• Phù hợp với mục đích cụ thể\n\n'
                  'Bạn sử dụng ứng dụng với rủi ro của riêng mình.',
            ),

            _buildSection(
              context,
              '9. Giới hạn trách nhiệm',
              'Trong mọi trường hợp, Travel Review App không chịu trách nhiệm cho:\n\n'
                  '• Thiệt hại gián tiếp hoặc hậu quả\n'
                  '• Mất lợi nhuận hoặc cơ hội kinh doanh\n'
                  '• Thiệt hại do việc sử dụng hoặc không thể sử dụng dịch vụ\n'
                  '• Tổng thiệt hại không vượt quá phí đã trả (nếu có)',
            ),

            _buildSection(
              context,
              '10. Luật áp dụng',
              'Điều khoản này được điều chỉnh bởi pháp luật Việt Nam. '
                  'Mọi tranh chấp sẽ được giải quyết tại Tòa án có thẩm quyền tại Việt Nam.',
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
                Icons.description,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Điều khoản sử dụng',
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

  // Widget thông báo đồng ý
  Widget _buildAgreementNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Bằng việc sử dụng ứng dụng, bạn đã đọc và đồng ý với các điều khoản này.',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
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
              'legal@travelreview.app',
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

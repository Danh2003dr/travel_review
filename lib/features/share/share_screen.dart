// lib/features/share/share_screen.dart
// ------------------------------------------------------
// 📤 SHARE SCREEN - MÀN HÌNH CHIA SẺ ỨNG DỤNG
// - Chia sẻ ứng dụng với bạn bè
// - Chia sẻ địa điểm, đánh giá
// - Mạng xã hội và messaging
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareScreen extends StatelessWidget {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? url;

  const ShareScreen({
    super.key,
    this.title,
    this.description,
    this.imageUrl,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chia sẻ'),
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

            // Content preview
            if (title != null) _buildContentPreview(context),

            const SizedBox(height: 24),

            // Share options
            _buildShareOptions(context),

            const SizedBox(height: 24),

            // Social media
            _buildSocialMedia(context),

            const SizedBox(height: 24),

            // Copy options
            _buildCopyOptions(context),
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
                Icons.share,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Chia sẻ ứng dụng',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Giới thiệu Travel Review với bạn bè và gia đình',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget preview nội dung
  Widget _buildContentPreview(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xem trước nội dung chia sẻ',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            Text(
              title ?? 'Travel Review App',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 4),

            Text(
              description ??
                  'Khám phá thế giới qua những đánh giá chân thực từ cộng đồng.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),

            if (url != null) ...[
              const SizedBox(height: 8),
              Text(
                url!,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget tùy chọn chia sẻ
  Widget _buildShareOptions(BuildContext context) {
    final shareOptions = [
      ShareOption(
        icon: Icons.message,
        title: 'Tin nhắn',
        subtitle: 'Gửi qua SMS',
        color: Colors.green,
        onTap: () => _shareViaSMS(context),
      ),
      ShareOption(
        icon: Icons.email,
        title: 'Email',
        subtitle: 'Gửi qua email',
        color: Colors.blue,
        onTap: () => _shareViaEmail(context),
      ),
      ShareOption(
        icon: Icons.link,
        title: 'Sao chép link',
        subtitle: 'Sao chép vào clipboard',
        color: Colors.orange,
        onTap: () => _copyLink(context),
      ),
      ShareOption(
        icon: Icons.qr_code,
        title: 'Mã QR',
        subtitle: 'Tạo mã QR để chia sẻ',
        color: Colors.purple,
        onTap: () => _generateQR(context),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chia sẻ cơ bản',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: shareOptions.length,
          itemBuilder: (context, index) {
            final option = shareOptions[index];
            return _buildShareOptionCard(context, option);
          },
        ),
      ],
    );
  }

  // Widget card tùy chọn chia sẻ
  Widget _buildShareOptionCard(BuildContext context, ShareOption option) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: option.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(option.icon, color: option.color, size: 24),
              ),

              const SizedBox(height: 8),

              Text(
                option.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              Text(
                option.subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget mạng xã hội
  Widget _buildSocialMedia(BuildContext context) {
    final socialOptions = [
      ShareOption(
        icon: Icons.facebook,
        title: 'Facebook',
        subtitle: 'Chia sẻ lên Facebook',
        color: const Color(0xFF1877F2),
        onTap: () => _shareToFacebook(context),
      ),
      ShareOption(
        icon: Icons.chat_bubble,
        title: 'Zalo',
        subtitle: 'Chia sẻ lên Zalo',
        color: const Color(0xFF0068FF),
        onTap: () => _shareToZalo(context),
      ),
      ShareOption(
        icon: Icons.telegram,
        title: 'Telegram',
        subtitle: 'Chia sẻ lên Telegram',
        color: const Color(0xFF0088CC),
        onTap: () => _shareToTelegram(context),
      ),
      ShareOption(
        icon: Icons.chat,
        title: 'WhatsApp',
        subtitle: 'Chia sẻ lên WhatsApp',
        color: const Color(0xFF25D366),
        onTap: () => _shareToWhatsApp(context),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mạng xã hội',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...socialOptions
            .map(
              (option) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: option.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(option.icon, color: option.color, size: 24),
                  ),
                  title: Text(
                    option.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(option.subtitle),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: option.onTap,
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  // Widget tùy chọn sao chép
  Widget _buildCopyOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sao chép',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.content_copy, color: Colors.blue),
                title: const Text('Sao chép link ứng dụng'),
                subtitle: const Text('travelreview.app'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _copyAppLink(context),
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.text_fields, color: Colors.green),
                title: const Text('Sao chép văn bản giới thiệu'),
                subtitle: const Text('Khám phá thế giới qua Travel Review'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _copyIntroText(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Các phương thức chia sẻ
  void _shareViaSMS(BuildContext context) {
    _showComingSoon(context, 'Chia sẻ qua SMS');
  }

  void _shareViaEmail(BuildContext context) {
    _showComingSoon(context, 'Chia sẻ qua Email');
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: url ?? 'https://travelreview.app'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép link vào clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _generateQR(BuildContext context) {
    _showComingSoon(context, 'Tạo mã QR');
  }

  void _shareToFacebook(BuildContext context) {
    _showComingSoon(context, 'Chia sẻ lên Facebook');
  }

  void _shareToZalo(BuildContext context) {
    _showComingSoon(context, 'Chia sẻ lên Zalo');
  }

  void _shareToTelegram(BuildContext context) {
    _showComingSoon(context, 'Chia sẻ lên Telegram');
  }

  void _shareToWhatsApp(BuildContext context) {
    _showComingSoon(context, 'Chia sẻ lên WhatsApp');
  }

  void _copyAppLink(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: 'https://travelreview.app'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép link ứng dụng'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _copyIntroText(BuildContext context) {
    const text =
        '🌟 Khám phá Travel Review - Ứng dụng đánh giá du lịch tuyệt vời!\n\n'
        '📍 Tìm kiếm địa điểm du lịch hấp dẫn\n'
        '⭐ Đọc đánh giá chân thực từ cộng đồng\n'
        '📝 Chia sẻ trải nghiệm của bạn\n'
        '🗺️ Xem bản đồ và định vị\n'
        '❤️ Lưu địa điểm yêu thích\n\n'
        'Tải ngay: https://travelreview.app';

    Clipboard.setData(const ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép văn bản giới thiệu'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Hiển thị thông báo "sắp có"
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature sẽ sớm có mặt'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

// Class chứa thông tin tùy chọn chia sẻ
class ShareOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

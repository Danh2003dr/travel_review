// lib/features/settings/settings_screen.dart
// ------------------------------------------------------
// ⚙️ SETTINGS SCREEN - MÀN HÌNH CÀI ĐẶT
// - Quản lý các tùy chọn ứng dụng
// - Cài đặt thông báo, ngôn ngữ, chủ đề
// - Thông tin ứng dụng và liên hệ
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_customization_screen.dart';
import '../help/help_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_of_service_screen.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Trạng thái các tùy chọn
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _locationServices = true;
  // Removed unused field
  String _selectedLanguage = 'Tiếng Việt';
  double _mapZoom = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Phần thông báo
          _buildSectionHeader('Thông báo'),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Thông báo đẩy',
            subtitle: 'Nhận thông báo về địa điểm mới và reviews',
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'Thông báo email',
            subtitle: 'Nhận email về hoạt động tài khoản',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),

          const Divider(),

          // Phần tùy chọn ứng dụng
          _buildSectionHeader('Tùy chọn ứng dụng'),
          _buildListTile(
            icon: Icons.palette,
            title: 'Tùy chỉnh giao diện',
            subtitle: 'Chọn màu sắc và chế độ hiển thị',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeCustomizationScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: Icons.language,
            title: 'Ngôn ngữ',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageDialog(),
          ),

          const Divider(),

          // Phần bản đồ và vị trí
          _buildSectionHeader('Bản đồ & Vị trí'),
          _buildSwitchTile(
            icon: Icons.location_on,
            title: 'Dịch vụ vị trí',
            subtitle: 'Cho phép ứng dụng truy cập vị trí của bạn',
            value: _locationServices,
            onChanged: (value) => setState(() => _locationServices = value),
          ),
          _buildSliderTile(
            icon: Icons.zoom_in,
            title: 'Mức zoom bản đồ mặc định',
            subtitle: '${_mapZoom.toInt()} km',
            value: _mapZoom,
            min: 5.0,
            max: 50.0,
            divisions: 9,
            onChanged: (value) => setState(() => _mapZoom = value),
          ),

          const Divider(),

          // Phần tài khoản
          _buildSectionHeader('Tài khoản'),
          _buildListTile(
            icon: Icons.person,
            title: 'Thông tin cá nhân',
            subtitle: 'Chỉnh sửa thông tin tài khoản',
            onTap: () => _showComingSoon(),
          ),
          _buildListTile(
            icon: Icons.privacy_tip,
            title: 'Quyền riêng tư',
            subtitle: 'Quản lý quyền riêng tư và bảo mật',
            onTap: () => _showComingSoon(),
          ),
          _buildListTile(
            icon: Icons.lock,
            title: 'Đổi mật khẩu',
            subtitle: 'Cập nhật mật khẩu tài khoản',
            onTap: () => _showComingSoon(),
          ),

          const Divider(),

          // Phần hỗ trợ
          _buildSectionHeader('Hỗ trợ'),
          _buildListTile(
            icon: Icons.help,
            title: 'Trợ giúp & FAQ',
            subtitle: 'Câu hỏi thường gặp',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          _buildListTile(
            icon: Icons.contact_support,
            title: 'Liên hệ hỗ trợ',
            subtitle: 'Gửi phản hồi hoặc báo lỗi',
            onTap: () => _showContactDialog(),
          ),
          _buildListTile(
            icon: Icons.star_rate,
            title: 'Đánh giá ứng dụng',
            subtitle: 'Đánh giá trên cửa hàng',
            onTap: () => _showComingSoon(),
          ),

          const Divider(),

          // Phần thông tin ứng dụng
          _buildSectionHeader('Thông tin ứng dụng'),
          _buildListTile(
            icon: Icons.info,
            title: 'Phiên bản',
            subtitle: '1.0.0',
            onTap: null,
          ),
          _buildListTile(
            icon: Icons.description,
            title: 'Điều khoản sử dụng',
            subtitle: 'Xem điều khoản và điều kiện',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServiceScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: Icons.security,
            title: 'Chính sách bảo mật',
            subtitle: 'Xem chính sách bảo mật',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Nút đăng xuất
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(),
              icon: const Icon(Icons.logout),
              label: const Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget tiêu đề section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget switch tile
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  // Widget list tile thông thường
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  // Widget slider tile
  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: Theme.of(context).primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Hiển thị dialog chọn ngôn ngữ
  void _showLanguageDialog() {
    final languages = ['Tiếng Việt', 'English', '中文', '日本語', '한국어'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ngôn ngữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages
              .map(
                (lang) => RadioListTile<String>(
                  title: Text(lang),
                  value: lang,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() => _selectedLanguage = value!);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  // Hiển thị dialog liên hệ
  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liên hệ hỗ trợ'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 Email: support@travelreview.com'),
            SizedBox(height: 8),
            Text('📱 Hotline: 1900-xxxx'),
            SizedBox(height: 8),
            Text('💬 Chat: Trong ứng dụng'),
            SizedBox(height: 8),
            Text('⏰ Giờ làm việc: 8:00 - 22:00 (T2-CN)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Mở email client hoặc chat
            },
            child: const Text('Liên hệ ngay'),
          ),
        ],
      ),
    );
  }

  // Hiển thị dialog đăng xuất
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.signOut();

              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('✅ Đã đăng xuất')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị thông báo "sắp ra mắt"
  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng này sẽ sớm ra mắt!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

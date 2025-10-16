// lib/features/settings/language_settings_screen.dart
// ------------------------------------------------------
// 🌍 LANGUAGE SETTINGS SCREEN - MÀN HÌNH CÀI ĐẶT NGÔN NGỮ
// - Chọn ngôn ngữ hiển thị của ứng dụng
// - Hỗ trợ đa ngôn ngữ với preview
// - Lưu cài đặt ngôn ngữ
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngôn ngữ'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: 24),

              // Language options
              _buildLanguageOptions(context, languageProvider),

              const SizedBox(height: 24),

              // Preview section
              _buildPreviewSection(context, languageProvider),

              const SizedBox(height: 24),

              // Info card
              _buildInfoCard(context),
            ],
          );
        },
      ),
    );
  }

  // Widget header
  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngôn ngữ ứng dụng',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chọn ngôn ngữ hiển thị cho toàn bộ ứng dụng',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget danh sách ngôn ngữ
  Widget _buildLanguageOptions(
    BuildContext context,
    LanguageProvider languageProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn ngôn ngữ',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...languageProvider.availableLanguages.map((language) {
          final isSelected = language.locale == languageProvider.currentLocale;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: isSelected ? 4 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: ListTile(
              leading: Text(
                language.flag,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                language.nativeName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
              ),
              subtitle: Text(
                language.name,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                languageProvider.setLanguage(language.locale);

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã chuyển sang ${language.nativeName}'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  // Widget preview
  Widget _buildPreviewSection(
    BuildContext context,
    LanguageProvider languageProvider,
  ) {
    final currentLang = languageProvider.currentLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xem trước',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      currentLang.flag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Travel Review - ${currentLang.nativeName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildPreviewItem(
                  context,
                  'Trang chủ',
                  currentLang.locale.languageCode == 'vi'
                      ? 'Khám phá địa điểm du lịch tuyệt vời'
                      : 'Discover amazing travel destinations',
                ),

                _buildPreviewItem(
                  context,
                  currentLang.locale.languageCode == 'vi'
                      ? 'Tìm kiếm'
                      : 'Search',
                  currentLang.locale.languageCode == 'vi'
                      ? 'Tìm kiếm địa điểm, khách sạn, nhà hàng...'
                      : 'Search for places, hotels, restaurants...',
                ),

                _buildPreviewItem(
                  context,
                  currentLang.locale.languageCode == 'vi'
                      ? 'Đánh giá'
                      : 'Review',
                  currentLang.locale.languageCode == 'vi'
                      ? 'Chia sẻ trải nghiệm của bạn'
                      : 'Share your experience',
                ),

                _buildPreviewItem(
                  context,
                  currentLang.locale.languageCode == 'vi' ? 'Hồ sơ' : 'Profile',
                  currentLang.locale.languageCode == 'vi'
                      ? 'Quản lý thông tin cá nhân'
                      : 'Manage your personal information',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget item preview
  Widget _buildPreviewItem(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget thông tin
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thay đổi ngôn ngữ sẽ áp dụng ngay lập tức cho toàn bộ ứng dụng. Một số nội dung có thể chưa được dịch.',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      height: 1.3,
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
}

// lib/features/help/help_screen.dart
// ------------------------------------------------------
// ❓ HELP SCREEN - MÀN HÌNH TRỢ GIÚP
// - FAQ và câu hỏi thường gặp
// - Hướng dẫn sử dụng ứng dụng
// - Liên hệ hỗ trợ
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategory = 0;

  final List<String> _categories = [
    'Tất cả',
    'Đăng nhập',
    'Đánh giá',
    'Tìm kiếm',
    'Bản đồ',
    'Cài đặt',
  ];

  final List<HelpItem> _helpItems = [
    // Đăng nhập
    HelpItem(
      category: 'Đăng nhập',
      question: 'Làm thế nào để đăng nhập?',
      answer:
          'Bạn có thể đăng nhập bằng email, số điện thoại hoặc tài khoản Google. Nhấn vào nút "Đăng nhập" ở màn hình chính.',
    ),
    HelpItem(
      category: 'Đăng nhập',
      question: 'Quên mật khẩu phải làm sao?',
      answer:
          'Nhấn "Quên mật khẩu" ở màn hình đăng nhập và làm theo hướng dẫn để đặt lại mật khẩu.',
    ),

    // Đánh giá
    HelpItem(
      category: 'Đánh giá',
      question: 'Làm thế nào để viết đánh giá?',
      answer:
          'Tìm địa điểm bạn muốn đánh giá, nhấn vào địa điểm đó, sau đó chọn "Viết đánh giá".',
    ),
    HelpItem(
      category: 'Đánh giá',
      question: 'Có thể chỉnh sửa đánh giá đã đăng không?',
      answer:
          'Hiện tại bạn chưa thể chỉnh sửa đánh giá đã đăng. Tính năng này sẽ sớm có mặt.',
    ),
    HelpItem(
      category: 'Đánh giá',
      question: 'Làm thế nào để xóa đánh giá?',
      answer:
          'Vào màn hình Profile > My Reviews, tìm đánh giá cần xóa và nhấn nút xóa.',
    ),

    // Tìm kiếm
    HelpItem(
      category: 'Tìm kiếm',
      question: 'Cách tìm kiếm địa điểm hiệu quả?',
      answer:
          'Sử dụng từ khóa cụ thể, bộ lọc theo loại địa điểm, và sắp xếp theo đánh giá để tìm kết quả phù hợp nhất.',
    ),
    HelpItem(
      category: 'Tìm kiếm',
      question: 'Có thể lưu tìm kiếm không?',
      answer:
          'Hiện tại chưa hỗ trợ lưu tìm kiếm. Tính năng này sẽ được thêm trong phiên bản tới.',
    ),

    // Bản đồ
    HelpItem(
      category: 'Bản đồ',
      question: 'Tại sao bản đồ không hiển thị?',
      answer:
          'Kiểm tra kết nối internet và quyền truy cập vị trí. Bản đồ cần có kết nối để tải dữ liệu.',
    ),
    HelpItem(
      category: 'Bản đồ',
      question: 'Làm thế nào để xem vị trí hiện tại?',
      answer:
          'Nhấn vào nút định vị (GPS) ở góc bản đồ để hiển thị vị trí hiện tại của bạn.',
    ),

    // Cài đặt
    HelpItem(
      category: 'Cài đặt',
      question: 'Làm thế nào để thay đổi ngôn ngữ?',
      answer: 'Vào Settings > Language để chọn ngôn ngữ hiển thị của ứng dụng.',
    ),
    HelpItem(
      category: 'Cài đặt',
      question: 'Có thể tùy chỉnh theme không?',
      answer:
          'Có, vào Settings > Theme để thay đổi màu sắc và chế độ sáng/tối.',
    ),
    HelpItem(
      category: 'Cài đặt',
      question: 'Làm thế nào để tắt thông báo?',
      answer:
          'Vào Settings > Notifications để tùy chỉnh các loại thông báo nhận được.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ giúp'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Category tabs
          _buildCategoryTabs(),

          // Help items list
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return _buildHelpItem(filteredItems[index]);
                    },
                  ),
          ),

          // Contact support button
          _buildContactSupport(),
        ],
      ),
    );
  }

  // Widget thanh tìm kiếm
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm câu hỏi...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value.toLowerCase());
        },
      ),
    );
  }

  // Widget tabs danh mục
  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_categories[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = index);
              },
              selectedColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  // Widget item trợ giúp
  Widget _buildHelpItem(HelpItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          item.category,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item.answer,
              style: TextStyle(color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // Widget trạng thái trống
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy câu hỏi phù hợp',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thử từ khóa khác hoặc liên hệ hỗ trợ',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Widget nút liên hệ hỗ trợ
  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Text(
            'Vẫn cần hỗ trợ?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _sendEmail,
                  icon: const Icon(Icons.email),
                  label: const Text('Email hỗ trợ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openLiveChat,
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat trực tiếp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Lọc danh sách theo tìm kiếm và danh mục
  List<HelpItem> _getFilteredItems() {
    var items = _helpItems;

    // Lọc theo danh mục
    if (_selectedCategory > 0) {
      final category = _categories[_selectedCategory];
      items = items.where((item) => item.category == category).toList();
    }

    // Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      items = items
          .where(
            (item) =>
                item.question.toLowerCase().contains(_searchQuery) ||
                item.answer.toLowerCase().contains(_searchQuery),
          )
          .toList();
    }

    return items;
  }

  // Gửi email hỗ trợ
  void _sendEmail() {
    // Implement email functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email: support@travelreview.app'),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'Sao chép',
          onPressed: () {
            Clipboard.setData(
              const ClipboardData(text: 'support@travelreview.app'),
            );
          },
        ),
      ),
    );
  }

  // Mở chat trực tiếp
  void _openLiveChat() {
    // Implement live chat
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat trực tiếp'),
        content: const Text(
          'Tính năng chat trực tiếp đang được phát triển. '
          'Bạn có thể liên hệ qua email hoặc số điện thoại trong thời gian chờ đợi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendEmail();
            },
            child: const Text('Gửi Email'),
          ),
        ],
      ),
    );
  }
}

// Class chứa thông tin item trợ giúp
class HelpItem {
  final String category;
  final String question;
  final String answer;

  HelpItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

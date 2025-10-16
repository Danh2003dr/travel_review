// lib/features/notifications/notifications_screen.dart
// ------------------------------------------------------
// 🔔 NOTIFICATIONS SCREEN - MÀN HÌNH THÔNG BÁO
// - Hiển thị danh sách thông báo của người dùng
// - Phân loại thông báo theo loại
// - Đánh dấu đã đọc, xóa thông báo
// ------------------------------------------------------

import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';
  bool _isLoading = false;

  final List<NotificationData> _notifications = [
    NotificationData(
      id: '1',
      title: 'Review mới tại Bãi biển Nha Trang',
      message: 'Minh Anh đã đăng một review mới cho địa điểm bạn yêu thích',
      type: NotificationType.review,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      actionData: {'placeId': '1', 'reviewId': 'r1'},
    ),
    NotificationData(
      id: '2',
      title: 'Địa điểm mới gần bạn',
      message: 'Có 3 địa điểm mới được thêm gần vị trí của bạn',
      type: NotificationType.newPlace,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      actionData: {'location': 'nearby'},
    ),
    NotificationData(
      id: '3',
      title: 'Cập nhật ứng dụng',
      message: 'Phiên bản mới với nhiều tính năng thú vị đã sẵn sàng!',
      type: NotificationType.system,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      actionData: {'version': '1.1.0'},
    ),
    NotificationData(
      id: '4',
      title: 'Review của bạn được thích',
      message: '5 người đã thích review của bạn về Phố cổ Hội An',
      type: NotificationType.like,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      actionData: {'reviewId': 'r3', 'likes': 5},
    ),
    NotificationData(
      id: '5',
      title: 'Nhắc nhở viết review',
      message:
          'Bạn đã tham quan Cù Lao Chàm 3 ngày trước, hãy chia sẻ trải nghiệm!',
      type: NotificationType.reminder,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      actionData: {'placeId': '4'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _selectedFilter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive),
                    SizedBox(width: 8),
                    Text('Tất cả'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'unread',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_unread),
                    SizedBox(width: 8),
                    Text('Chưa đọc'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'review',
                child: Row(
                  children: [
                    Icon(Icons.rate_review),
                    SizedBox(width: 8),
                    Text('Reviews'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'system',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Hệ thống'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
            tooltip: 'Đánh dấu tất cả đã đọc',
          ),
        ],
      ),
      body: Column(
        children: [
          // Thống kê
          _buildStatsBar(),

          // Danh sách thông báo
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationTile(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget thanh thống kê
  Widget _buildStatsBar() {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_getFilteredNotifications().length} thông báo',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount chưa đọc',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget tile thông báo
  Widget _buildNotificationTile(NotificationData notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: notification.isRead ? 1 : 3,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(
              notification.type,
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.createdAt),
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ],
        ),
        trailing: notification.isRead
            ? IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showNotificationOptions(notification),
              )
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  // Widget trạng thái trống
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'unread'
                  ? 'Không có thông báo chưa đọc'
                  : 'Không có thông báo nào',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'unread'
                  ? 'Tất cả thông báo đã được đọc'
                  : 'Bạn sẽ nhận được thông báo khi có hoạt động mới',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Lọc thông báo theo filter
  List<NotificationData> _getFilteredNotifications() {
    switch (_selectedFilter) {
      case 'unread':
        return _notifications.where((n) => !n.isRead).toList();
      case 'review':
        return _notifications
            .where((n) => n.type == NotificationType.review)
            .toList();
      case 'system':
        return _notifications
            .where((n) => n.type == NotificationType.system)
            .toList();
      default:
        return _notifications;
    }
  }

  // Lấy icon cho loại thông báo
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.review:
        return Icons.rate_review;
      case NotificationType.newPlace:
        return Icons.place;
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.reminder:
        return Icons.schedule;
      case NotificationType.system:
        return Icons.settings;
    }
  }

  // Lấy màu cho loại thông báo
  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.review:
        return Colors.blue;
      case NotificationType.newPlace:
        return Colors.green;
      case NotificationType.like:
        return Colors.red;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.system:
        return Colors.purple;
    }
  }

  // Format thời gian
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Xử lý tap vào thông báo
  void _handleNotificationTap(NotificationData notification) {
    // Đánh dấu đã đọc
    setState(() {
      notification.isRead = true;
    });

    // Xử lý hành động theo loại thông báo
    switch (notification.type) {
      case NotificationType.review:
        // TODO: Navigate to review detail
        break;
      case NotificationType.newPlace:
        // TODO: Navigate to nearby places
        break;
      case NotificationType.like:
        // TODO: Navigate to review detail
        break;
      case NotificationType.reminder:
        // TODO: Navigate to write review
        break;
      case NotificationType.system:
        // TODO: Navigate to app update
        break;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã mở ${notification.title}')));
  }

  // Hiển thị tùy chọn thông báo
  void _showNotificationOptions(NotificationData notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Xóa thông báo'),
              onTap: () {
                Navigator.pop(context);
                _deleteNotification(notification);
              },
            ),
            if (!notification.isRead)
              ListTile(
                leading: const Icon(Icons.mark_email_read),
                title: const Text('Đánh dấu đã đọc'),
                onTap: () {
                  Navigator.pop(context);
                  _markAsRead(notification);
                },
              ),
          ],
        ),
      ),
    );
  }

  // Đánh dấu tất cả đã đọc
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã đánh dấu tất cả đã đọc')));
  }

  // Đánh dấu một thông báo đã đọc
  void _markAsRead(NotificationData notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  // Xóa thông báo
  void _deleteNotification(NotificationData notification) {
    setState(() {
      _notifications.remove(notification);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa thông báo')));
  }
}

// Enum loại thông báo
enum NotificationType { review, newPlace, like, reminder, system }

// Class dữ liệu thông báo
class NotificationData {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> actionData;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.actionData,
  });
}

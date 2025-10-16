// lib/utils/date_format.dart
// ------------------------------------------------------
// ⏰ DATE FORMAT HELPER
// - Chuyển DateTime thành chuỗi "vừa xong", "2 ngày trước"
// ------------------------------------------------------

String formatDate(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inDays >= 1) return '${diff.inDays} ngày trước';
  if (diff.inHours >= 1) return '${diff.inHours} giờ trước';
  if (diff.inMinutes >= 1) return '${diff.inMinutes} phút trước';
  return 'vừa xong';
}

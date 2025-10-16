// lib/models/trip.dart
// ------------------------------------------------------
// ✈️ TRIP MODEL - MÔ HÌNH CHUYẾN ĐI
// - Đại diện cho một chuyến du lịch của người dùng
// - Bao gồm ngày, địa điểm, ngân sách, ghi chú
// ------------------------------------------------------

class Trip {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String currency;
  final List<String> placeIds;
  final String coverImageUrl;
  final String status; // 'planning', 'ongoing', 'completed'
  final String notes;
  final List<String> participants;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.budget = 0,
    this.currency = 'VND',
    this.placeIds = const [],
    this.coverImageUrl = '',
    this.status = 'planning',
    this.notes = '',
    this.participants = const [],
  });

  // Số ngày của chuyến đi
  int get duration => endDate.difference(startDate).inDays + 1;

  // Kiểm tra chuyến đi đã bắt đầu chưa
  bool get hasStarted => DateTime.now().isAfter(startDate);

  // Kiểm tra chuyến đi đã kết thúc chưa
  bool get hasEnded => DateTime.now().isAfter(endDate);

  // Số ngày còn lại
  int get daysRemaining {
    if (hasEnded) return 0;
    if (!hasStarted) return startDate.difference(DateTime.now()).inDays;
    return endDate.difference(DateTime.now()).inDays;
  }
}

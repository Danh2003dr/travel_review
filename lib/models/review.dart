// lib/models/review.dart
// ------------------------------------------------------
// 🧩 MÔ HÌNH DỮ LIỆU REVIEW
// - Đại diện cho một đánh giá (review) của người dùng
//   đối với một địa điểm du lịch.
// - Dùng trong PlaceDetailScreen để hiển thị danh sách đánh giá.
// ------------------------------------------------------

class Review {
  final String id; // Mã định danh review
  final String placeId; // ID của địa điểm
  final String userId; // ID của người dùng
  final String userName; // Tên người dùng (VD: Minh Anh)
  final String userAvatar; // Ảnh đại diện (URL)
  final String userAvatarUrl; // URL ảnh đại diện (alias)
  final double rating; // Điểm đánh giá (1..5)
  final String content; // Nội dung đánh giá
  final String imageUrl; // Ảnh đính kèm (URL)
  final DateTime createdAt; // Thời gian tạo đánh giá
  final List<String> photos; // Danh sách ảnh đính kèm (nếu có)

  const Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.userAvatarUrl,
    required this.rating,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    this.photos = const [],
  });

  // ------------------------------------------------------
  // 🔁 Các hàm tiện ích hỗ trợ JSON (Firestore / API)
  // ------------------------------------------------------

  // Chuyển từ JSON → Review (dùng khi đọc từ Firestore hoặc API)
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      placeId: json['placeId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      userAvatarUrl: json['userAvatarUrl'] ?? json['userAvatar'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      photos:
          (json['photos'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  // Chuyển Review → JSON (để lưu hoặc gửi API)
  Map<String, dynamic> toJson() => {
    'id': id,
    'placeId': placeId,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'userAvatarUrl': userAvatarUrl,
    'rating': rating,
    'content': content,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'photos': photos,
  };

  // In ra console cho dễ debug
  @override
  String toString() => 'Review($userName, rating: $rating, content: $content)';
}

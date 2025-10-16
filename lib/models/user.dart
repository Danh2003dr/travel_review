// lib/models/user.dart
// ------------------------------------------------------
// 👤 MÔ HÌNH DỮ LIỆU USER
// - Đại diện cho thông tin người dùng trong ứng dụng
// - Bao gồm thông tin cá nhân, reviews đã viết, và danh sách yêu thích
// ------------------------------------------------------

class User {
  final String id; // Mã định danh người dùng
  final String name; // Tên hiển thị
  final String email; // Email đăng nhập
  final String avatarUrl; // URL ảnh đại diện
  final String? bio; // Tiểu sử người dùng
  final DateTime joinDate; // Ngày tham gia
  final List<String> favoritePlaceIds; // Danh sách ID các địa điểm yêu thích
  final List<String> reviewIds; // Danh sách ID các review đã viết
  final int totalReviews; // Tổng số review đã viết
  final double averageRating; // Điểm trung bình các review của user

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.bio,
    required this.joinDate,
    this.favoritePlaceIds = const [],
    this.reviewIds = const [],
    this.totalReviews = 0,
    this.averageRating = 0.0,
  });

  // ------------------------------------------------------
  // 🔁 Các hàm tiện ích hỗ trợ JSON (Firestore / API)
  // ------------------------------------------------------

  // Chuyển từ JSON → User (dùng khi đọc từ Firestore hoặc API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      bio: json['bio'],
      joinDate: DateTime.tryParse(json['joinDate'] ?? '') ?? DateTime.now(),
      favoritePlaceIds:
          (json['favoritePlaceIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      reviewIds:
          (json['reviewIds'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
    );
  }

  // Chuyển User → JSON (để lưu hoặc gửi API)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'bio': bio,
    'joinDate': joinDate.toIso8601String(),
    'favoritePlaceIds': favoritePlaceIds,
    'reviewIds': reviewIds,
    'totalReviews': totalReviews,
    'averageRating': averageRating,
  };

  // Tạo bản sao với một số thay đổi
  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? favoritePlaceIds,
    List<String>? reviewIds,
    int? totalReviews,
    double? averageRating,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      joinDate: joinDate,
      favoritePlaceIds: favoritePlaceIds ?? this.favoritePlaceIds,
      reviewIds: reviewIds ?? this.reviewIds,
      totalReviews: totalReviews ?? this.totalReviews,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  // In ra console cho dễ debug
  @override
  String toString() => 'User($name, $email, reviews: $totalReviews)';
}

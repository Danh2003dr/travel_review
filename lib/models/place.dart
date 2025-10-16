// lib/models/place.dart
// ------------------------------------------------------
// 🧩 MÔ HÌNH DỮ LIỆU PLACE
// - Đại diện cho một địa điểm du lịch.
// - Dùng chung cho UI (Home, Search, Detail) và Repository.
// ------------------------------------------------------

class Place {
  final String id;             // Mã định danh duy nhất (UUID hoặc docID)
  final String name;           // Tên địa điểm (VD: Bãi biển Nha Trang)
  final String type;           // Loại hình: biển | núi | văn hóa | ẩm thực | ...
  final String city;           // Thành phố
  final String country;        // Quốc gia
  final String description;    // Mô tả ngắn gọn
  final double ratingAvg;      // Điểm trung bình (0..5)
  final int ratingCount;       // Số lượt đánh giá
  final String thumbnailUrl;   // URL ảnh đại diện
  final double lat;            // Vĩ độ (latitude)
  final double lng;            // Kinh độ (longitude)

  const Place({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.country,
    required this.description,
    required this.ratingAvg,
    required this.ratingCount,
    required this.thumbnailUrl,
    required this.lat,
    required this.lng,
  });

  // ------------------------------------------------------
  // 🔁 Các hàm tiện ích (nếu sau này dùng Firestore/API)
  // ------------------------------------------------------

  // Tạo Place từ JSON (Firestore hoặc REST API)
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      ratingAvg: (json['ratingAvg'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  // Chuyển Place sang JSON (để lưu hoặc gửi API)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'city': city,
        'country': country,
        'description': description,
        'ratingAvg': ratingAvg,
        'ratingCount': ratingCount,
        'thumbnailUrl': thumbnailUrl,
        'lat': lat,
        'lng': lng,
      };

  // Gợi ý tiện: in ra console dễ đọc
  @override
  String toString() => 'Place($name, $city, $country, rating: $ratingAvg)';
}

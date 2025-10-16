// lib/models/collection.dart
// ------------------------------------------------------
// 📚 COLLECTION MODEL - MÔ HÌNH BỘ SƯU TẬP ĐỊA ĐIỂM
// - Đại diện cho một bộ sưu tập các địa điểm được tuyển chọn
// - Ví dụ: "Top 10 bãi biển", "Địa điểm lãng mạn", v.v.
// ------------------------------------------------------

class Collection {
  final String id;
  final String title;
  final String description;
  final String coverImageUrl;
  final List<String> placeIds;
  final String category;
  final int viewCount;
  final int saveCount;
  final DateTime createdAt;
  final String curatorName;
  final String curatorAvatar;

  Collection({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    required this.placeIds,
    required this.category,
    this.viewCount = 0,
    this.saveCount = 0,
    required this.createdAt,
    this.curatorName = 'Travel Review',
    this.curatorAvatar = '',
  });

  // Số lượng địa điểm trong bộ sưu tập
  int get placeCount => placeIds.length;

  // ------------------------------------------------------
  // 🔁 Các hàm tiện ích hỗ trợ JSON (Firestore / API)
  // ------------------------------------------------------

  // Chuyển từ JSON → Collection
  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      placeIds:
          (json['placeIds'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      category: json['category'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      saveCount: json['saveCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      curatorName: json['curatorName'] ?? 'Travel Review',
      curatorAvatar: json['curatorAvatar'] ?? '',
    );
  }

  // Chuyển Collection → JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'coverImageUrl': coverImageUrl,
    'placeIds': placeIds,
    'category': category,
    'viewCount': viewCount,
    'saveCount': saveCount,
    'createdAt': createdAt.toIso8601String(),
    'curatorName': curatorName,
    'curatorAvatar': curatorAvatar,
  };
}

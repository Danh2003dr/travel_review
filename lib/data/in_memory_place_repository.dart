// lib/data/in_memory_place_repository.dart
// ------------------------------------------------------
// 🧩 IN-MEMORY REPOSITORY (Mock data cho UI)
// - Giúp chạy thử ứng dụng mà không cần kết nối mạng.
// - Dữ liệu được lưu tạm trong bộ nhớ, mô phỏng delay mạng.
// - Có thể thay thế bằng FirestorePlaceRepository sau này.
// ------------------------------------------------------

import 'dart:async';
import '../models/place.dart';
import '../models/review.dart';
import 'place_repository.dart';

class InMemoryPlaceRepository implements PlaceRepository {
  InMemoryPlaceRepository();

  // ------------------------------------------------------
  // 🔹 DỮ LIỆU GIẢ – danh sách địa điểm
  // ------------------------------------------------------
  static final _places = <Place>[
    Place(
      id: '1',
      name: 'Bãi biển Nha Trang',
      type: 'biển',
      city: 'Nha Trang',
      country: 'Việt Nam',
      description:
          'Bãi cát trắng, nước trong xanh, phù hợp tắm biển và lặn ngắm san hô.',
      ratingAvg: 4.6,
      ratingCount: 128,
      thumbnailUrl: 'https://picsum.photos/id/1018/800/500',
      lat: 12.2388,
      lng: 109.1967,
    ),
    Place(
      id: '2',
      name: 'Fansipan',
      type: 'núi',
      city: 'Sa Pa',
      country: 'Việt Nam',
      description: 'Nóc nhà Đông Dương, đi cáp treo và săn mây tuyệt đẹp.',
      ratingAvg: 4.7,
      ratingCount: 203,
      thumbnailUrl: 'https://picsum.photos/id/1021/800/500',
      lat: 22.3033,
      lng: 103.7728,
    ),
    Place(
      id: '3',
      name: 'Phố cổ Hội An',
      type: 'văn hóa',
      city: 'Hội An',
      country: 'Việt Nam',
      description:
          'Đèn lồng, kiến trúc cổ, ẩm thực phong phú, chụp ảnh siêu đẹp.',
      ratingAvg: 4.8,
      ratingCount: 320,
      thumbnailUrl: 'https://picsum.photos/id/1035/800/500',
      lat: 15.8801,
      lng: 108.3380,
    ),
    Place(
      id: '4',
      name: 'Cù Lao Chàm',
      type: 'biển',
      city: 'Quảng Nam',
      country: 'Việt Nam',
      description: 'Đảo hoang sơ, lặn ngắm san hô, hải sản tươi.',
      ratingAvg: 4.5,
      ratingCount: 77,
      thumbnailUrl: 'https://picsum.photos/id/1011/800/500',
      lat: 15.9570,
      lng: 108.4890,
    ),
    Place(
      id: '5',
      name: 'Đà Lạt – Hồ Xuân Hương',
      type: 'thiên nhiên',
      city: 'Đà Lạt',
      country: 'Việt Nam',
      description: 'Không khí mát mẻ quanh năm, cảnh quan lãng mạn.',
      ratingAvg: 4.4,
      ratingCount: 96,
      thumbnailUrl: 'https://picsum.photos/id/1043/800/500',
      lat: 11.9465,
      lng: 108.4419,
    ),
  ];

  // ------------------------------------------------------
  // 🔹 DỮ LIỆU GIẢ – danh sách review theo địa điểm
  // ------------------------------------------------------
  static final _reviews = <String, List<Review>>{
    '1': [
      Review(
        id: 'r1',
        placeId: '1',
        userId: 'user_001',
        userName: 'Minh Anh',
        userAvatar: 'https://i.pravatar.cc/100?img=12',
        userAvatarUrl: 'https://i.pravatar.cc/100?img=12',
        rating: 5,
        content:
            'Biển đẹp, nước trong. Rất đáng đi vào mùa hè! Ảnh sống ảo bao chất.',
        imageUrl: '',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r2',
        placeId: '1',
        userId: 'user_002',
        userName: 'Tuấn Kiệt',
        userAvatar: 'https://i.pravatar.cc/100?img=8',
        userAvatarUrl: 'https://i.pravatar.cc/100?img=8',
        rating: 4,
        content: 'Đông khách cuối tuần. Nên đi sớm buổi sáng để đỡ nắng.',
        imageUrl: '',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ],
    '3': [
      Review(
        id: 'r3',
        placeId: '3',
        userId: 'user_003',
        userName: 'Quỳnh Chi',
        userAvatar: 'https://i.pravatar.cc/100?img=31',
        userAvatarUrl: 'https://i.pravatar.cc/100?img=31',
        rating: 5,
        content: 'Đêm thả đèn lồng quá thơ mộng. Món cao lầu ngon!',
        imageUrl: '',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  };

  // ------------------------------------------------------
  // 🧠 CÁC HÀM TRIỂN KHAI INTERFACE (PlaceRepository)
  // ------------------------------------------------------

  // Lấy top địa điểm (theo rating cao nhất)
  @override
  Future<List<Place>> fetchTopPlaces({int limit = 10}) async {
    await Future.delayed(
      const Duration(milliseconds: 350),
    ); // mô phỏng độ trễ mạng
    final sorted = [..._places]
      ..sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
    return sorted.take(limit).toList();
  }

  // Lấy chi tiết 1 địa điểm theo id
  @override
  Future<Place?> getPlaceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      return _places.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // Tìm kiếm địa điểm theo từ khóa và loại hình
  @override
  Future<List<Place>> searchPlaces({String keyword = '', String? type}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    Iterable<Place> result = _places;
    if (keyword.isNotEmpty) {
      final k = keyword.toLowerCase();
      result = result.where(
        (p) =>
            p.name.toLowerCase().contains(k) ||
            p.city.toLowerCase().contains(k),
      );
    }
    if (type != null && type.isNotEmpty) {
      result = result.where((p) => p.type.toLowerCase() == type.toLowerCase());
    }
    return result.toList();
  }

  // Lấy danh sách review theo địa điểm
  @override
  Future<List<Review>> fetchReviews(String placeId, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = _reviews[placeId] ?? [];
    final sorted = [...list]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }
}

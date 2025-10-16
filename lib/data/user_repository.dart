// lib/data/user_repository.dart
// ------------------------------------------------------
// 📊 USER REPOSITORY
// - Quản lý dữ liệu người dùng (thông tin cá nhân, reviews, favorites)
// - Hiện tại dùng mock data, sau này có thể kết nối với Firebase/API
// ------------------------------------------------------

import '../models/user.dart';
import '../models/review.dart';
import '../models/place.dart';
import 'in_memory_place_repository.dart';

class UserRepository {
  // Lưu trữ dữ liệu user hiện tại (mock)
  User? _currentUser;

  // Repository để lấy thông tin địa điểm
  final InMemoryPlaceRepository _placeRepository = InMemoryPlaceRepository();

  // ------------------------------------------------------
  // 👤 QUẢN LÝ THÔNG TIN USER
  // ------------------------------------------------------

  // Lấy thông tin user hiện tại
  User? getCurrentUser() {
    return _currentUser ?? _createMockUser();
  }

  // Tạo mock user với dữ liệu mẫu
  User _createMockUser() {
    _currentUser = User(
      id: 'user_demo_001',
      name: 'Người dùng demo',
      email: 'demo@example.com',
      avatarUrl: 'https://i.pravatar.cc/200?img=5',
      joinDate: DateTime(2024, 1, 15),
      favoritePlaceIds: ['place_001', 'place_003', 'place_005'],
      reviewIds: ['review_001', 'review_002', 'review_003'],
      totalReviews: 3,
      averageRating: 4.2,
    );
    return _currentUser!;
  }

  // Cập nhật thông tin user
  void updateUser(User user) {
    _currentUser = user;
  }

  // ------------------------------------------------------
  // ❤️ QUẢN LÝ FAVORITES
  // ------------------------------------------------------

  // Lấy danh sách địa điểm yêu thích
  Future<List<Place>> getFavoritePlaces() async {
    final user = getCurrentUser();
    if (user == null) return [];

    final places = await _placeRepository.fetchTopPlaces();
    return places
        .where((place) => user.favoritePlaceIds.contains(place.id))
        .toList();
  }

  // Thêm/bỏ yêu thích một địa điểm
  Future<void> toggleFavorite(String placeId) async {
    final user = getCurrentUser();
    if (user == null) return;

    final favoriteIds = List<String>.from(user.favoritePlaceIds);

    if (favoriteIds.contains(placeId)) {
      favoriteIds.remove(placeId); // Bỏ yêu thích
    } else {
      favoriteIds.add(placeId); // Thêm yêu thích
    }

    final updatedUser = user.copyWith(favoritePlaceIds: favoriteIds);
    updateUser(updatedUser);
  }

  // Kiểm tra xem địa điểm có được yêu thích không
  bool isFavorite(String placeId) {
    final user = getCurrentUser();
    return user?.favoritePlaceIds.contains(placeId) ?? false;
  }

  // ------------------------------------------------------
  // 📝 QUẢN LÝ REVIEWS CỦA USER
  // ------------------------------------------------------

  // Lấy danh sách reviews đã viết
  Future<List<Review>> getUserReviews() async {
    final user = getCurrentUser();
    if (user == null) return [];

    // Mock reviews của user
    final reviews = [
      Review(
        id: 'review_001',
        placeId: 'place_001',
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatarUrl,
        userAvatarUrl: user.avatarUrl,
        rating: 4.5,
        content:
            'Địa điểm này thật tuyệt vời! Cảnh đẹp, không khí trong lành. Tôi sẽ quay lại lần nữa.',
        imageUrl: '',
        createdAt: DateTime(2024, 2, 15),
        photos: [],
      ),
      Review(
        id: 'review_002',
        placeId: 'place_002',
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatarUrl,
        userAvatarUrl: user.avatarUrl,
        rating: 5.0,
        content:
            'Trải nghiệm hoàn hảo! Dịch vụ tốt, giá cả hợp lý. Rất đáng để ghé thăm.',
        imageUrl: '',
        createdAt: DateTime(2024, 2, 10),
        photos: [],
      ),
      Review(
        id: 'review_003',
        placeId: 'place_003',
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatarUrl,
        userAvatarUrl: user.avatarUrl,
        rating: 3.0,
        content:
            'Không tệ nhưng cũng không xuất sắc. Có một số điểm cần cải thiện.',
        imageUrl: '',
        createdAt: DateTime(2024, 2, 5),
        photos: [],
      ),
    ];

    return reviews;
  }

  // Lấy thống kê reviews của user
  Map<String, dynamic> getUserReviewStats() {
    final user = getCurrentUser();
    if (user == null) return {};

    return {
      'totalReviews': user.totalReviews,
      'averageRating': user.averageRating,
      'joinDate': user.joinDate,
      'favoriteCount': user.favoritePlaceIds.length,
    };
  }

  // ------------------------------------------------------
  // 🔧 TIỆN ÍCH KHÁC
  // ------------------------------------------------------

  // Làm mới dữ liệu user (dùng khi pull-to-refresh)
  Future<void> refreshUserData() async {
    // Trong thực tế, sẽ gọi API để cập nhật dữ liệu mới nhất
    await Future.delayed(const Duration(milliseconds: 500)); // Mock delay
  }
}

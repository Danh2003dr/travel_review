// lib/data/place_repository.dart
// ------------------------------------------------------
// 🧩 INTERFACE (ABSTRACT CLASS) CHO REPOSITORY
// - Định nghĩa các hành vi mà mọi lớp Repository phải có.
// - Giúp UI (Home/Search/Detail) không phụ thuộc vào nguồn dữ liệu cụ thể.
// - Bạn có thể cắm Firestore, REST API, hoặc Local DB mà không cần đổi UI.
// ------------------------------------------------------

import '../models/place.dart';
import '../models/review.dart';

abstract class PlaceRepository {
  // ------------------------------------------------------
  // 🔹 LẤY DANH SÁCH ĐỊA ĐIỂM NỔI BẬT
  //   → Dùng cho trang Home (Top Places)
  // ------------------------------------------------------
  Future<List<Place>> fetchTopPlaces({int limit = 10});

  // ------------------------------------------------------
  // 🔹 TÌM KIẾM ĐỊA ĐIỂM
  //   → Dùng cho trang Search (theo tên, loại, thành phố)
  // ------------------------------------------------------
  Future<List<Place>> searchPlaces({
    String keyword = '', // từ khóa tìm kiếm
    String? type,        // loại địa điểm (biển, núi, văn hóa,...)
  });

  // ------------------------------------------------------
  // 🔹 LẤY CHI TIẾT 1 ĐỊA ĐIỂM THEO ID
  //   → Dùng cho trang PlaceDetailScreen
  // ------------------------------------------------------
  Future<Place?> getPlaceById(String id);

  // ------------------------------------------------------
  // 🔹 LẤY DANH SÁCH REVIEW CỦA 1 ĐỊA ĐIỂM
  //   → Dùng cho mục “Đánh giá gần đây” trong chi tiết
  // ------------------------------------------------------
  Future<List<Review>> fetchReviews(
    String placeId, {
    int limit = 10,
  });
}

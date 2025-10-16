// lib/data/firebase_place_repository.dart
// ------------------------------------------------------
// 🔥 FIREBASE PLACE REPOSITORY
// - Triển khai PlaceRepository interface với Firebase Firestore
// - Quản lý dữ liệu địa điểm du lịch từ cloud
// ------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';
import '../models/review.dart';
import 'place_repository.dart';

class FirebasePlaceRepository implements PlaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _placesCollection => _firestore.collection('places');
  CollectionReference get _reviewsCollection =>
      _firestore.collection('reviews');

  // ------------------------------------------------------
  // 🔹 LẤY DANH SÁCH ĐỊA ĐIỂM NỔI BẬT
  // ------------------------------------------------------
  @override
  Future<List<Place>> fetchTopPlaces({int limit = 10}) async {
    try {
      final snapshot = await _placesCollection
          .orderBy('ratingAvg', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Thêm document ID
        return Place.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching top places: $e');
      return [];
    }
  }

  // ------------------------------------------------------
  // 🔹 TÌM KIẾM ĐỊA ĐIỂM
  // ------------------------------------------------------
  @override
  Future<List<Place>> searchPlaces({String keyword = '', String? type}) async {
    try {
      Query query = _placesCollection;

      // Lọc theo loại địa điểm nếu có
      if (type != null && type.isNotEmpty) {
        query = query.where('type', isEqualTo: type);
      }

      final snapshot = await query.get();

      // Lọc theo từ khóa (client-side vì Firestore không hỗ trợ full-text search)
      List<Place> places = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Place.fromJson(data);
      }).toList();

      // Tìm kiếm theo keyword
      if (keyword.isNotEmpty) {
        final lowerKeyword = keyword.toLowerCase();
        places = places.where((place) {
          return place.name.toLowerCase().contains(lowerKeyword) ||
              place.city.toLowerCase().contains(lowerKeyword) ||
              place.description.toLowerCase().contains(lowerKeyword);
        }).toList();
      }

      return places;
    } catch (e) {
      print('❌ Error searching places: $e');
      return [];
    }
  }

  // ------------------------------------------------------
  // 🔹 LẤY CHI TIẾT 1 ĐỊA ĐIỂM THEO ID
  // ------------------------------------------------------
  @override
  Future<Place?> getPlaceById(String id) async {
    try {
      final doc = await _placesCollection.doc(id).get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Place.fromJson(data);
    } catch (e) {
      print('❌ Error fetching place by ID: $e');
      return null;
    }
  }

  // ------------------------------------------------------
  // 🔹 LẤY DANH SÁCH REVIEW CỦA 1 ĐỊA ĐIỂM
  // ------------------------------------------------------
  @override
  Future<List<Review>> fetchReviews(String placeId, {int limit = 10}) async {
    try {
      final snapshot = await _reviewsCollection
          .where('placeId', isEqualTo: placeId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Review.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching reviews: $e');
      return [];
    }
  }

  // ------------------------------------------------------
  // 🔧 CÁC PHƯƠNG THỨC BỔ SUNG
  // ------------------------------------------------------

  // Thêm địa điểm mới
  Future<String?> addPlace(Place place) async {
    try {
      final docRef = await _placesCollection.add(place.toJson());
      return docRef.id;
    } catch (e) {
      print('❌ Error adding place: $e');
      return null;
    }
  }

  // Cập nhật địa điểm
  Future<bool> updatePlace(String id, Map<String, dynamic> data) async {
    try {
      await _placesCollection.doc(id).update(data);
      return true;
    } catch (e) {
      print('❌ Error updating place: $e');
      return false;
    }
  }

  // Xóa địa điểm
  Future<bool> deletePlace(String id) async {
    try {
      await _placesCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('❌ Error deleting place: $e');
      return false;
    }
  }

  // Xóa review
  Future<bool> deleteReview(String placeId, String reviewId) async {
    try {
      await _reviewsCollection.doc(reviewId).delete();
      return true;
    } catch (e) {
      print('❌ Error deleting review: $e');
      return false;
    }
  }

  // Thêm review mới
  Future<String?> addReview(Review review, String placeId) async {
    try {
      // Thêm review vào collection
      final reviewData = review.toJson();
      reviewData['placeId'] = placeId;

      final docRef = await _reviewsCollection.add(reviewData);

      // Cập nhật rating trung bình của địa điểm
      await _updatePlaceRating(placeId);

      return docRef.id;
    } catch (e) {
      print('❌ Error adding review: $e');
      return null;
    }
  }

  // Cập nhật rating trung bình của địa điểm
  Future<void> _updatePlaceRating(String placeId) async {
    try {
      final reviews = await fetchReviews(placeId, limit: 1000);

      if (reviews.isEmpty) return;

      final totalRating = reviews.fold<double>(
        0.0,
        (sum, review) => sum + review.rating,
      );

      final avgRating = totalRating / reviews.length;

      await _placesCollection.doc(placeId).update({
        'ratingAvg': avgRating,
        'ratingCount': reviews.length,
      });
    } catch (e) {
      print('❌ Error updating place rating: $e');
    }
  }

  // Lấy địa điểm theo loại
  Future<List<Place>> getPlacesByType(String type, {int limit = 10}) async {
    try {
      final snapshot = await _placesCollection
          .where('type', isEqualTo: type)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Place.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching places by type: $e');
      return [];
    }
  }

  // Lấy địa điểm theo thành phố
  Future<List<Place>> getPlacesByCity(String city, {int limit = 10}) async {
    try {
      final snapshot = await _placesCollection
          .where('city', isEqualTo: city)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Place.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching places by city: $e');
      return [];
    }
  }
}

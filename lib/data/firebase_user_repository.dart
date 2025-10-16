// lib/data/firebase_user_repository.dart
// ------------------------------------------------------
// 🔥 FIREBASE USER REPOSITORY
// - Quản lý dữ liệu người dùng với Firestore
// - Xử lý favorites, reviews, và thông tin cá nhân
// ------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';
import '../models/review.dart';
import '../models/place.dart';
import '../utils/logger.dart';

/// Repository để quản lý dữ liệu user với Firebase Firestore
///
/// Cung cấp các chức năng:
/// - CRUD operations cho User
/// - Quản lý favorites (địa điểm yêu thích)
/// - Quản lý reviews của user
/// - Tích hợp với Firebase Authentication
/// - Real-time updates và caching
class FirebaseUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _reviewsCollection =>
      _firestore.collection('reviews');
  CollectionReference get _placesCollection => _firestore.collection('places');

  // ------------------------------------------------------
  // 👤 QUẢN LÝ THÔNG TIN USER
  // ------------------------------------------------------

  // Lấy thông tin user hiện tại
  Future<User?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final doc = await _usersCollection.doc(currentUser.uid).get();

      if (!doc.exists) {
        // Tạo user document nếu chưa có
        await _createUserDocument(currentUser);
        return await getCurrentUser();
      }

      final data = doc.data() as Map<String, dynamic>;
      return User.fromJson(data);
    } catch (e) {
      Logger.error(
        'Lỗi lấy thông tin user hiện tại',
        'FirebaseUserRepository',
        e,
      );
      return null;
    }
  }

  // Stream để lắng nghe thay đổi của user
  Stream<User?> getCurrentUserStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(null);
    }

    return _usersCollection.doc(currentUser.uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return User.fromJson(data);
    });
  }

  // Tạo user document khi đăng ký
  Future<void> _createUserDocument(auth.User firebaseUser) async {
    try {
      await _usersCollection.doc(firebaseUser.uid).set({
        'id': firebaseUser.uid,
        'name': firebaseUser.displayName ?? 'User',
        'email': firebaseUser.email ?? '',
        'avatarUrl': firebaseUser.photoURL ?? 'https://i.pravatar.cc/200?img=5',
        'joinDate': DateTime.now().toIso8601String(),
        'favoritePlaceIds': [],
        'reviewIds': [],
        'totalReviews': 0,
        'averageRating': 0.0,
      });
    } catch (e) {
      Logger.error('Lỗi tạo user document', 'FirebaseUserRepository', e);
    }
  }

  // Cập nhật thông tin user
  Future<void> updateUser(Map<String, dynamic> data) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User chưa đăng nhập');

      await _usersCollection.doc(currentUser.uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Logger.success(
        'Cập nhật thông tin user thành công',
        'FirebaseUserRepository',
      );
    } catch (e) {
      Logger.error('Lỗi cập nhật user', 'FirebaseUserRepository', e);
      rethrow;
    }
  }

  // Cập nhật ảnh đại diện
  Future<void> updateAvatar(String avatarUrl) async {
    await updateUser({'avatarUrl': avatarUrl});
  }

  // Cập nhật tên
  Future<void> updateName(String name) async {
    try {
      // Cập nhật trong Firestore
      await updateUser({'name': name});

      // Cập nhật trong Firebase Auth
      await _auth.currentUser?.updateDisplayName(name);
    } catch (e) {
      Logger.error('Lỗi cập nhật tên', 'FirebaseUserRepository', e);
      rethrow;
    }
  }

  // ------------------------------------------------------
  // ❤️ QUẢN LÝ FAVORITES
  // ------------------------------------------------------

  // Lấy danh sách địa điểm yêu thích
  Future<List<Place>> getUserFavorites(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) return [];

      final userData = userDoc.data() as Map<String, dynamic>;
      final favoriteIds = List<String>.from(userData['favoritePlaceIds'] ?? []);

      if (favoriteIds.isEmpty) {
        return [];
      }

      // Firestore 'in' query giới hạn 10 items, nên phải chia nhỏ
      final List<Place> allPlaces = [];
      final chunks = _chunkList(favoriteIds, 10);

      for (final chunk in chunks) {
        final snapshot = await _placesCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        final places = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Place.fromJson(data);
        }).toList();

        allPlaces.addAll(places);
      }

      return allPlaces;
    } catch (e) {
      Logger.error(
        'Lỗi lấy danh sách địa điểm yêu thích',
        'FirebaseUserRepository',
        e,
      );
      return [];
    }
  }

  // Thêm vào yêu thích
  Future<bool> addToFavorites(String userId, String placeId) async {
    try {
      await _usersCollection.doc(userId).update({
        'favoritePlaceIds': FieldValue.arrayUnion([placeId]),
      });
      return true;
    } catch (e) {
      Logger.error(
        'Lỗi thêm vào danh sách yêu thích',
        'FirebaseUserRepository',
        e,
      );
      return false;
    }
  }

  // Xóa khỏi yêu thích
  Future<bool> removeFromFavorites(String userId, String placeId) async {
    try {
      await _usersCollection.doc(userId).update({
        'favoritePlaceIds': FieldValue.arrayRemove([placeId]),
      });
      return true;
    } catch (e) {
      Logger.error(
        'Lỗi xóa khỏi danh sách yêu thích',
        'FirebaseUserRepository',
        e,
      );
      return false;
    }
  }

  // Thêm/bỏ yêu thích một địa điểm
  Future<bool> toggleFavorite(String placeId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final userDoc = _usersCollection.doc(currentUser.uid);
      final user = await getCurrentUser();

      if (user == null) return false;

      final favoriteIds = List<String>.from(user.favoritePlaceIds);

      if (favoriteIds.contains(placeId)) {
        favoriteIds.remove(placeId); // Bỏ yêu thích
      } else {
        favoriteIds.add(placeId); // Thêm yêu thích
      }

      await userDoc.update({'favoritePlaceIds': favoriteIds});
      return true;
    } catch (e) {
      Logger.error(
        'Lỗi thay đổi trạng thái yêu thích',
        'FirebaseUserRepository',
        e,
      );
      return false;
    }
  }

  // Kiểm tra xem địa điểm có được yêu thích không
  Future<bool> isFavorite(String placeId) async {
    try {
      final user = await getCurrentUser();
      return user?.favoritePlaceIds.contains(placeId) ?? false;
    } catch (e) {
      Logger.error(
        'Lỗi kiểm tra trạng thái yêu thích',
        'FirebaseUserRepository',
        e,
      );
      return false;
    }
  }

  // ------------------------------------------------------
  // 📝 QUẢN LÝ REVIEWS CỦA USER
  // ------------------------------------------------------

  // Lấy danh sách reviews đã viết
  Future<List<Review>> getUserReviews(String userId) async {
    try {
      final snapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Review.fromJson(data);
      }).toList();
    } catch (e) {
      Logger.error(
        'Lỗi lấy danh sách reviews của user',
        'FirebaseUserRepository',
        e,
      );
      return [];
    }
  }

  // Thêm review mới
  Future<String?> addReview({
    required String placeId,
    required double rating,
    required String content,
    List<String> photos = const [],
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final user = await getCurrentUser();
      if (user == null) return null;

      // Tạo review document
      final reviewData = {
        'userId': currentUser.uid,
        'userName': user.name,
        'userAvatar': user.avatarUrl,
        'placeId': placeId,
        'rating': rating,
        'content': content,
        'photos': photos,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final docRef = await _reviewsCollection.add(reviewData);

      // Cập nhật user stats
      await _updateUserReviewStats();

      return docRef.id;
    } catch (e) {
      Logger.error('Lỗi thêm review', 'FirebaseUserRepository', e);
      return null;
    }
  }

  // Cập nhật thống kê review của user
  Future<void> _updateUserReviewStats() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final reviews = await getUserReviews(currentUser.uid);

      if (reviews.isEmpty) {
        await updateUser({'totalReviews': 0, 'averageRating': 0.0});
        return;
      }

      final totalRating = reviews.fold<double>(
        0.0,
        (sum, review) => sum + review.rating,
      );
      final avgRating = totalRating / reviews.length;

      await updateUser({
        'totalReviews': reviews.length,
        'averageRating': avgRating,
        'reviewIds': reviews.map((r) => r.id).toList(),
      });
    } catch (e) {
      Logger.error(
        'Lỗi cập nhật thống kê reviews',
        'FirebaseUserRepository',
        e,
      );
    }
  }

  // Xóa review
  Future<bool> deleteReview(String reviewId) async {
    try {
      await _reviewsCollection.doc(reviewId).delete();
      await _updateUserReviewStats();
      return true;
    } catch (e) {
      Logger.error('Lỗi xóa review', 'FirebaseUserRepository', e);
      return false;
    }
  }

  // Lấy thống kê reviews của user
  Future<Map<String, dynamic>> getUserReviewStats() async {
    try {
      final user = await getCurrentUser();
      if (user == null) return {};

      return {
        'totalReviews': user.totalReviews,
        'averageRating': user.averageRating,
        'joinDate': user.joinDate,
        'favoriteCount': user.favoritePlaceIds.length,
      };
    } catch (e) {
      Logger.error('Lỗi lấy thống kê reviews', 'FirebaseUserRepository', e);
      return {};
    }
  }

  // ------------------------------------------------------
  // 🔧 TIỆN ÍCH KHÁC
  // ------------------------------------------------------

  // Làm mới dữ liệu user
  Future<void> refreshUserData() async {
    // Firestore tự động cập nhật real-time
    // Có thể thêm logic khác nếu cần
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Chia list thành các chunk nhỏ
  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}

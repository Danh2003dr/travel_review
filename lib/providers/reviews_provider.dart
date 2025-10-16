// lib/providers/reviews_provider.dart
// ------------------------------------------------------
// ⭐ REVIEWS PROVIDER
// - Quản lý reviews và ratings
// - Sync với Firestore
// ------------------------------------------------------

import 'package:flutter/foundation.dart';
import '../models/review.dart';
import '../data/firebase_place_repository.dart';

class ReviewsProvider with ChangeNotifier {
  final FirebasePlaceRepository _placeRepo = FirebasePlaceRepository();

  Map<String, List<Review>> _placeReviews = {};
  bool _isLoading = false;
  String? _errorMessage;

  // ------------------------------------------------------
  // 📊 GETTERS
  // ------------------------------------------------------
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Review> getReviewsForPlace(String placeId) {
    return _placeReviews[placeId] ?? [];
  }

  double getAverageRating(String placeId) {
    final reviews = getReviewsForPlace(placeId);
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  int getReviewsCount(String placeId) {
    return getReviewsForPlace(placeId).length;
  }

  // ------------------------------------------------------
  // 🔄 LOAD REVIEWS
  // ------------------------------------------------------
  Future<void> loadReviews(String placeId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final reviews = await _placeRepo.fetchReviews(placeId);
      _placeReviews[placeId] = reviews;

      print('✅ Loaded ${reviews.length} reviews for place $placeId');
    } catch (e) {
      _errorMessage = 'Không thể tải reviews: $e';
      print('❌ Lỗi load reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // ✍️ ADD REVIEW
  // ------------------------------------------------------
  Future<bool> addReview(String placeId, Review review) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _placeRepo.addReview(review, placeId);

      // Thêm review vào local list
      _placeReviews[placeId] ??= [];
      _placeReviews[placeId]!.add(review);

      print('✅ Added review for place $placeId');
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm review: $e';
      print('❌ Lỗi add review: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // 🗑️ DELETE REVIEW
  // ------------------------------------------------------
  Future<bool> deleteReview(String placeId, String reviewId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _placeRepo.deleteReview(placeId, reviewId);

      // Xóa review khỏi local list
      _placeReviews[placeId]?.removeWhere((review) => review.id == reviewId);

      print('✅ Deleted review $reviewId');
      return true;
    } catch (e) {
      _errorMessage = 'Không thể xóa review: $e';
      print('❌ Lỗi delete review: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // 🔍 CHECK IF USER REVIEWED
  // ------------------------------------------------------
  bool hasUserReviewed(String placeId, String userId) {
    final reviews = getReviewsForPlace(placeId);
    return reviews.any((review) => review.userId == userId);
  }

  Review? getUserReview(String placeId, String userId) {
    final reviews = getReviewsForPlace(placeId);
    try {
      return reviews.firstWhere((review) => review.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // ------------------------------------------------------
  // 🧹 CLEAR ERROR
  // ------------------------------------------------------
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ------------------------------------------------------
  // 🔄 REFRESH
  // ------------------------------------------------------
  Future<void> refresh(String placeId) async {
    await loadReviews(placeId);
  }

  // ------------------------------------------------------
  // 🧹 CLEAR CACHE
  // ------------------------------------------------------
  void clearCache() {
    _placeReviews.clear();
    notifyListeners();
  }
}

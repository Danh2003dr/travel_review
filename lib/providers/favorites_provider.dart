// lib/providers/favorites_provider.dart
// ------------------------------------------------------
// ❤️ FAVORITES PROVIDER
// - Quản lý danh sách yêu thích
// - Sync với Firestore
// ------------------------------------------------------

import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../data/firebase_user_repository.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseUserRepository _userRepo = FirebaseUserRepository();

  List<Place> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ------------------------------------------------------
  // 📊 GETTERS
  // ------------------------------------------------------
  List<Place> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get favoritesCount => _favorites.length;

  // ------------------------------------------------------
  // 🔄 LOAD FAVORITES
  // ------------------------------------------------------
  Future<void> loadFavorites(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final favorites = await _userRepo.getUserFavorites(userId);
      _favorites = favorites;

      print('✅ Loaded ${favorites.length} favorites');
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách yêu thích: $e';
      print('❌ Lỗi load favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // ❤️ ADD TO FAVORITES
  // ------------------------------------------------------
  Future<bool> addToFavorites(String userId, Place place) async {
    try {
      await _userRepo.addToFavorites(userId, place.id);
      _favorites.add(place);
      notifyListeners();

      print('✅ Added to favorites: ${place.name}');
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm vào yêu thích: $e';
      print('❌ Lỗi add favorite: $e');
      return false;
    }
  }

  // ------------------------------------------------------
  // 💔 REMOVE FROM FAVORITES
  // ------------------------------------------------------
  Future<bool> removeFromFavorites(String userId, String placeId) async {
    try {
      await _userRepo.removeFromFavorites(userId, placeId);
      _favorites.removeWhere((place) => place.id == placeId);
      notifyListeners();

      print('✅ Removed from favorites: $placeId');
      return true;
    } catch (e) {
      _errorMessage = 'Không thể xóa khỏi yêu thích: $e';
      print('❌ Lỗi remove favorite: $e');
      return false;
    }
  }

  // ------------------------------------------------------
  // 🔍 CHECK IF FAVORITE
  // ------------------------------------------------------
  bool isFavorite(String placeId) {
    return _favorites.any((place) => place.id == placeId);
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
  Future<void> refresh(String userId) async {
    await loadFavorites(userId);
  }
}

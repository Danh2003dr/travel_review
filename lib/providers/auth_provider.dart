// lib/providers/auth_provider.dart
// ------------------------------------------------------
// 🔐 AUTHENTICATION PROVIDER
// - Quản lý trạng thái đăng nhập
// - Cung cấp thông tin user cho toàn app
// ------------------------------------------------------

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user.dart' as app_user;
// Removed unused import

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  app_user.User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // ------------------------------------------------------
  // 📊 GETTERS
  // ------------------------------------------------------
  app_user.User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // ------------------------------------------------------
  // 🏁 KHỞI TẠO
  // ------------------------------------------------------
  AuthProvider() {
    _init();
  }

  void _init() {
    // Lắng nghe thay đổi trạng thái auth
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  // ------------------------------------------------------
  // 👤 LOAD USER DATA
  // ------------------------------------------------------
  Future<void> _loadUserData(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load user data từ Firestore
      final userData = await _authService.getUserData(uid);
      _user = userData;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Không thể tải thông tin người dùng: $e';
      print('❌ Lỗi load user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (_user != null) {
      await _loadUserData(_user!.id);
    }
  }

  // ------------------------------------------------------
  // 📧 ĐĂNG NHẬP EMAIL/PASSWORD
  // ------------------------------------------------------
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (result != null) {
        print('✅ Đăng nhập thành công');
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Lỗi đăng nhập: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // 📝 ĐĂNG KÝ EMAIL/PASSWORD
  // ------------------------------------------------------
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );

      if (result != null) {
        print('✅ Đăng ký thành công');
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Lỗi đăng ký: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // 🔍 GOOGLE SIGN-IN
  // ------------------------------------------------------
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.signInWithGoogle();

      if (result != null) {
        print('✅ Google Sign-In thành công');
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Lỗi Google Sign-In: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // 🚪 ĐĂNG XUẤT
  // ------------------------------------------------------
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();
      _user = null;
      _errorMessage = null;

      print('✅ Đăng xuất thành công');
    } catch (e) {
      _errorMessage = 'Lỗi đăng xuất: $e';
      print('❌ Lỗi đăng xuất: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------
  // 🔄 RESET PASSWORD
  // ------------------------------------------------------
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.resetPassword(email);
      print('✅ Gửi email reset password thành công');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ Lỗi reset password: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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
  // 🔄 REFRESH USER DATA
  // ------------------------------------------------------
  Future<void> refreshUserData() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      await _loadUserData(currentUser.uid);
    }
  }
}

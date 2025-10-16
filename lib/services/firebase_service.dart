// lib/services/firebase_service.dart
// ------------------------------------------------------
// 🔥 FIREBASE SERVICE - QUẢN LÝ KHỞI TẠO FIREBASE
// - Khởi tạo Firebase khi ứng dụng chạy
// - Cung cấp các instance Firebase cho toàn bộ ứng dụng
// ------------------------------------------------------

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_options.dart';

class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // ------------------------------------------------------
  // 🚀 KHỞI TẠO FIREBASE
  // ------------------------------------------------------
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Cấu hình Firestore settings (tùy chọn)
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }

  // ------------------------------------------------------
  // 🔧 KIỂM TRA TRẠNG THÁI
  // ------------------------------------------------------
  bool get isInitialized => Firebase.apps.isNotEmpty;

  User? get currentUser => auth.currentUser;

  bool get isLoggedIn => currentUser != null;
}

// lib/di/repo_provider.dart
// ------------------------------------------------------
// 🧩 DEPENDENCY INJECTION (DI)
// - Nơi khai báo repository dùng chung toàn app.
// - Giúp dễ dàng chuyển đổi giữa mock data và dữ liệu thật (Firestore/API).
// ------------------------------------------------------

import '../data/place_repository.dart';
import '../data/in_memory_place_repository.dart';
import '../data/firebase_place_repository.dart';
import '../data/firebase_user_repository.dart';
import '../data/firebase_collection_repository.dart';
import '../services/auth_service.dart';

// ------------------------------------------------------
// ✅ CHUYỂN ĐỔI GIỮA MOCK DATA VÀ FIREBASE
// ------------------------------------------------------
// Đặt USE_FIREBASE = true để dùng Firebase
// Đặt USE_FIREBASE = false để dùng mock data (InMemory)
const bool USE_FIREBASE = true; // ✅ Đã sẵn sàng dùng Firebase!

// ------------------------------------------------------
// 📦 PLACE REPOSITORY
// ------------------------------------------------------
final PlaceRepository placeRepo = USE_FIREBASE
    ? FirebasePlaceRepository()
    : InMemoryPlaceRepository();

// ------------------------------------------------------
// 👤 USER REPOSITORY (chỉ có Firebase version)
// ------------------------------------------------------
final FirebaseUserRepository userRepo = FirebaseUserRepository();

// ------------------------------------------------------
// 📚 COLLECTION REPOSITORY (chỉ có Firebase version)
// ------------------------------------------------------
final FirebaseCollectionRepository collectionRepo =
    FirebaseCollectionRepository();

// ------------------------------------------------------
// 🔐 AUTHENTICATION SERVICE
// ------------------------------------------------------
final AuthService authService = AuthService();

// ------------------------------------------------------
// 💡 HƯỚNG DẪN:
// 1. Khi phát triển/test UI: đặt USE_FIREBASE = false
// 2. Khi chạy thật với Firebase: đặt USE_FIREBASE = true
// 3. Nhớ cấu hình Firebase trước khi đặt USE_FIREBASE = true
//    (xem file FIREBASE_SETUP.md để biết cách cấu hình)
// ------------------------------------------------------

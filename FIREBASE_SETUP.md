# 🔥 Hướng Dẫn Cấu Hình Firebase cho Flutter Travel Review

## 📋 Mục Lục
1. [Tạo Firebase Project](#1-tạo-firebase-project)
2. [Cài Đặt Firebase CLI](#2-cài-đặt-firebase-cli)
3. [Cấu Hình Firebase cho Flutter](#3-cấu-hình-firebase-cho-flutter)
4. [Cấu Hình Firestore Database](#4-cấu-hình-firestore-database)
5. [Cấu Hình Firebase Authentication](#5-cấu-hình-firebase-authentication)
6. [Thêm Dữ Liệu Mẫu](#6-thêm-dữ-liệu-mẫu)
7. [Chạy Ứng Dụng](#7-chạy-ứng-dụng)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Tạo Firebase Project

### Bước 1: Truy cập Firebase Console
1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Đăng nhập bằng tài khoản Google
3. Click **"Add project"** hoặc **"Thêm dự án"**

### Bước 2: Tạo Project Mới
1. Nhập tên project: `flutter-travel-review` (hoặc tên bất kỳ)
2. Click **Continue**
3. Tắt Google Analytics (không bắt buộc) hoặc bật nếu muốn
4. Click **Create project**
5. Đợi Firebase tạo project (khoảng 30 giây)
6. Click **Continue**

---

## 2. Cài Đặt Firebase CLI

### Trên Windows (PowerShell)
```powershell
# Cài Node.js từ https://nodejs.org/ (nếu chưa có)

# Cài Firebase CLI
npm install -g firebase-tools

# Đăng nhập Firebase
firebase login

# Cài FlutterFire CLI
dart pub global activate flutterfire_cli
```

### Trên macOS/Linux
```bash
# Cài Node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Cài Firebase CLI
npm install -g firebase-tools

# Đăng nhập Firebase
firebase login

# Cài FlutterFire CLI
dart pub global activate flutterfire_cli
```

---

## 3. Cấu Hình Firebase cho Flutter

### Bước 1: Chạy FlutterFire Configure
```bash
# Đi tới thư mục project
cd flutter_travel_review-main

# Chạy FlutterFire configure
flutterfire configure
```

### Bước 2: Chọn Firebase Project
1. Chọn project `flutter-travel-review` đã tạo ở bước 1
2. Chọn các platform muốn hỗ trợ:
   - [x] Android
   - [x] iOS
   - [x] Web
   - [x] Windows (tùy chọn)
   - [x] macOS (tùy chọn)

### Bước 3: Kiểm Tra File Được Tạo
FlutterFire CLI sẽ tự động tạo:
- `lib/firebase_options.dart` - chứa cấu hình Firebase
- Cập nhật `android/app/google-services.json`
- Cập nhật `ios/Runner/GoogleService-Info.plist`

---

## 4. Cấu Hình Firestore Database

### Bước 1: Tạo Firestore Database
1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Chọn project **flutter-travel-review**
3. Sidebar bên trái → **Build** → **Firestore Database**
4. Click **Create database**

### Bước 2: Chọn Mode
1. Chọn **Start in test mode** (cho development)
2. Click **Next**

### Bước 3: Chọn Location
1. Chọn location gần nhất (VD: `asia-southeast1` cho Việt Nam)
2. Click **Enable**

### Bước 4: Cấu Hình Security Rules (Quan trọng!)

Vào tab **Rules** và thay thế bằng rules sau:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Places collection - public read, authenticated write
    match /places/{placeId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Reviews collection
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Collections
    match /collections/{collectionId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == userId;
    }
  }
}
```

Click **Publish** để lưu rules.

---

## 5. Cấu Hình Firebase Authentication

### Bước 1: Bật Authentication
1. Sidebar bên trái → **Build** → **Authentication**
2. Click **Get started**

### Bước 2: Bật Email/Password
1. Tab **Sign-in method**
2. Click **Email/Password**
3. Bật toggle **Enable**
4. Click **Save**

### Bước 3: Bật Google Sign-In
1. Click **Google**
2. Bật toggle **Enable**
3. Chọn **Project support email** (email của bạn)
4. Click **Save**

### Bước 4: Cấu Hình Google Sign-In cho Android

#### 4.1 Lấy SHA-1 Certificate
```bash
# Windows
cd android
./gradlew signingReport

# Tìm SHA-1 trong output (debug variant)
```

#### 4.2 Thêm SHA-1 vào Firebase
1. Firebase Console → **Project Settings** (⚙️)
2. Scroll xuống **Your apps** → chọn Android app
3. Click **Add fingerprint**
4. Paste SHA-1 certificate
5. Click **Save**
6. Download `google-services.json` mới
7. Thay thế file `android/app/google-services.json`

---

## 6. Thêm Dữ Liệu Mẫu

### Cách 1: Import từ Console (Khuyến nghị)

Tạo file `firestore_seed_data.json`:

```json
{
  "places": [
    {
      "id": "place_001",
      "name": "Vịnh Hạ Long",
      "type": "Biển",
      "city": "Quảng Ninh",
      "country": "Việt Nam",
      "description": "Di sản thiên nhiên thế giới với hàng nghìn đảo đá vôi",
      "ratingAvg": 4.8,
      "ratingCount": 1523,
      "thumbnailUrl": "https://picsum.photos/seed/halong/800/600",
      "lat": 20.9101,
      "lng": 107.1839
    },
    {
      "id": "place_002",
      "name": "Phố Cổ Hội An",
      "type": "Văn hóa",
      "city": "Hội An",
      "country": "Việt Nam",
      "description": "Thành phố cổ với kiến trúc độc đáo và văn hóa đa dạng",
      "ratingAvg": 4.7,
      "ratingCount": 2104,
      "thumbnailUrl": "https://picsum.photos/seed/hoian/800/600",
      "lat": 15.8801,
      "lng": 108.3380
    },
    {
      "id": "place_003",
      "name": "Sapa",
      "type": "Núi",
      "city": "Lào Cai",
      "country": "Việt Nam",
      "description": "Thị trấn miền núi với ruộng bậc thang tuyệt đẹp",
      "ratingAvg": 4.6,
      "ratingCount": 1876,
      "thumbnailUrl": "https://picsum.photos/seed/sapa/800/600",
      "lat": 22.3364,
      "lng": 103.8438
    }
  ],
  "collections": [
    {
      "id": "col_001",
      "title": "Top 10 Bãi Biển Đẹp Nhất Việt Nam",
      "description": "Khám phá những bãi biển tuyệt đẹp",
      "coverImageUrl": "https://picsum.photos/seed/beach/800/400",
      "placeIds": ["place_001", "place_002"],
      "category": "Biển",
      "viewCount": 12500,
      "saveCount": 850,
      "createdAt": "2024-10-01T00:00:00.000Z",
      "curatorName": "Travel Review Team",
      "curatorAvatar": "https://i.pravatar.cc/100?img=1"
    }
  ]
}
```

### Cách 2: Thêm Thủ Công từ Firebase Console
1. Vào **Firestore Database**
2. Click **Start collection**
3. Collection ID: `places`
4. Add document với các field tương ứng
5. Lặp lại cho các collection khác: `reviews`, `collections`, `users`

---

## 7. Chạy Ứng Dụng

### Bước 1: Cài Dependencies
```bash
flutter pub get
```

### Bước 2: Chọn Sử Dụng Firebase
Mở file `lib/di/repo_provider.dart`:

```dart
// Đặt thành true để sử dụng Firebase
const bool USE_FIREBASE = true;
```

### Bước 3: Chạy App
```bash
# Android
flutter run

# iOS (cần Mac)
flutter run

# Web
flutter run -d chrome
```

---

## 8. Troubleshooting

### ⚠️ Lỗi: "Firebase not initialized"
**Nguyên nhân:** FlutterFire chưa được cấu hình đúng

**Giải pháp:**
```bash
flutterfire configure --force
flutter clean
flutter pub get
```

### ⚠️ Lỗi: "Google Sign-In failed"
**Nguyên nhân:** Thiếu SHA-1 certificate hoặc `google-services.json` chưa đúng

**Giải pháp:**
1. Thêm SHA-1 certificate (xem bước 5.4)
2. Download lại `google-services.json`
3. Rebuild app: `flutter clean && flutter run`

### ⚠️ Lỗi: "Permission denied" khi truy cập Firestore
**Nguyên nhân:** Security rules chưa đúng

**Giải pháp:**
1. Kiểm tra Firestore Rules (xem bước 4.4)
2. Đảm bảo đã đăng nhập (nếu cần authentication)

### ⚠️ Lỗi Build Android
**Nguyên nhân:** Gradle hoặc dependencies lỗi

**Giải pháp:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### ⚠️ iOS Build Errors
**Nguyên nhân:** Pods chưa được cài

**Giải pháp:**
```bash
cd ios
pod install
cd ..
flutter run
```

---

## 🎉 Hoàn Thành!

Bây giờ ứng dụng của bạn đã được kết nối với Firebase và sẵn sàng sử dụng:

✅ **Firebase Authentication** - Đăng nhập/Đăng ký  
✅ **Cloud Firestore** - Lưu trữ dữ liệu  
✅ **Firebase Storage** - Lưu trữ hình ảnh (nếu cần)  
✅ **Real-time Updates** - Dữ liệu cập nhật tự động  

### 📚 Tài Liệu Tham Khảo
- [FlutterFire Docs](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

### 💡 Mẹo
- Sử dụng **Firebase Emulator Suite** cho development
- Backup Firestore data thường xuyên
- Monitor usage trong Firebase Console
- Đặt budget alerts để tránh chi phí bất ngờ

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề, hãy kiểm tra:
1. [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)
2. [Stack Overflow - Firebase Flutter](https://stackoverflow.com/questions/tagged/flutter+firebase)
3. [Firebase Support](https://firebase.google.com/support)

---

**Chúc bạn code vui vẻ! 🚀**


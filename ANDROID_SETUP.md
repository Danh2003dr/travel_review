# 🤖 CẤU HÌNH ANDROID CHO GOOGLE SIGN-IN

Hướng dẫn chi tiết để cấu hình Google Sign-In cho Android.

## 📋 Yêu Cầu

- ✅ Android Studio đã cài đặt
- ✅ Flutter project đã được tạo
- ✅ Firebase project đã được thiết lập
- ✅ `google-services.json` đã được thêm vào `android/app/`

## 🔑 BƯỚC 1: LẤY SHA-1 CERTIFICATE

### 1.1 Mở Terminal trong thư mục project
```bash
cd android
```

### 1.2 Chạy lệnh lấy SHA-1
```bash
./gradlew signingReport
```

### 1.3 Tìm SHA-1 fingerprint
Tìm phần **"Variant: debug"** và copy **SHA1** fingerprint:

```
Variant: debug
Config: debug
Store: C:\Users\YourName\.android\debug.keystore
Alias: androiddebugkey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD  ← Copy cái này
SHA-256: YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY:YY
```

## 🔧 BƯỚC 2: THÊM SHA-1 VÀO FIREBASE

### 2.1 Truy cập Firebase Console
🔗 **Link:** https://console.firebase.google.com/project/flutter-travel-review/settings/general

### 2.2 Thêm SHA-1
1. Scroll xuống **"Your apps"**
2. Tìm Android app (có icon 🤖)
3. Click **"Add fingerprint"**
4. Paste SHA-1 fingerprint đã copy
5. Click **"Save"**

### 2.3 Download google-services.json mới
1. Click **"Download google-services.json"**
2. Thay thế file cũ trong `android/app/google-services.json`

## 📱 BƯỚC 3: KIỂM TRA CẤU HÌNH

### 3.1 Kiểm tra file google-services.json
Mở `android/app/google-services.json` và đảm bảo có:

```json
{
  "project_info": {
    "project_id": "flutter-travel-review",
    "project_number": "122921125037"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:122921125037:android:YOUR_APP_ID",
        "android_client_info": {
          "package_name": "com.example.flutter_travel_review"
        }
      }
    }
  ]
}
```

### 3.2 Kiểm tra build.gradle
Mở `android/app/build.gradle.kts` và đảm bảo có:

```kotlin
android {
    compileSdk 35
    
    defaultConfig {
        applicationId "com.example.flutter_travel_review"
        minSdk 21
        targetSdk 35
        versionCode 1
        versionName "1.0"
    }
}
```

## 🧪 BƯỚC 4: TEST GOOGLE SIGN-IN

### 4.1 Clean và rebuild
```bash
flutter clean
flutter pub get
```

### 4.2 Chạy trên Android
```bash
flutter run -d android
```

### 4.3 Test Google Sign-In
1. Mở app trên Android
2. Click **"Đăng ký"** hoặc **"Đăng nhập"**
3. Click **"Đăng nhập với Google"**
4. Chọn Google account
5. Kiểm tra đăng nhập thành công

## ⚠️ XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi: "Google Sign-In failed"
**Nguyên nhân:** SHA-1 chưa được thêm vào Firebase
**Giải pháp:** 
1. Kiểm tra SHA-1 có đúng không
2. Đảm bảo đã thêm vào Firebase Console
3. Download lại `google-services.json`

### Lỗi: "Package name mismatch"
**Nguyên nhân:** Package name trong Firebase khác với Android
**Giải pháp:**
1. Kiểm tra `applicationId` trong `build.gradle.kts`
2. Đảm bảo khớp với Firebase Console

### Lỗi: "Google Play Services not available"
**Nguyên nhân:** Device không có Google Play Services
**Giải pháp:**
1. Test trên device có Google Play Services
2. Hoặc dùng Android Emulator với Google APIs

## 📋 CHECKLIST HOÀN THÀNH

- [ ] SHA-1 certificate đã được lấy
- [ ] SHA-1 đã được thêm vào Firebase Console
- [ ] google-services.json mới đã được download
- [ ] File google-services.json đã được thay thế
- [ ] Package name khớp với Firebase
- [ ] App đã được clean và rebuild
- [ ] Google Sign-In hoạt động trên Android

## 🎉 HOÀN THÀNH!

Sau khi hoàn thành tất cả các bước:

1. **Google Sign-In** sẽ hoạt động trên Android
2. **Firebase Authentication** sẽ sync giữa các platforms
3. **User data** sẽ được lưu trong Firestore
4. **App** sẵn sàng cho production

---

**Lưu ý:** Nếu bạn thay đổi keystore (cho release), cần thêm SHA-1 mới vào Firebase Console.

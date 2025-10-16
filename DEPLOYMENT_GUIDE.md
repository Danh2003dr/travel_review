# 🚀 HƯỚNG DẪN DEPLOYMENT

Hướng dẫn chi tiết để deploy Flutter Travel Review App lên các platforms.

## 📱 ANDROID DEPLOYMENT

### 1.1 Chuẩn Bị Release Keystore

```bash
# Tạo keystore (chỉ làm 1 lần)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Lưu thông tin keystore:
# - Keystore password: [lưu lại]
# - Key password: [lưu lại]
# - Alias: upload
```

### 1.2 Cấu Hình key.properties

Tạo file `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

### 1.3 Cấu Hình build.gradle.kts

Cập nhật `android/app/build.gradle.kts`:

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 1.4 Build APK/AAB

```bash
# Build APK
flutter build apk --release

# Build AAB (khuyến nghị cho Play Store)
flutter build appbundle --release
```

### 1.5 Upload lên Play Store

1. Truy cập [Google Play Console](https://play.google.com/console)
2. Tạo app mới
3. Upload AAB file từ `build/app/outputs/bundle/release/`
4. Điền thông tin app
5. Submit for review

## 🍎 iOS DEPLOYMENT

### 2.1 Chuẩn Bị Apple Developer Account

- Đăng ký [Apple Developer Program](https://developer.apple.com/programs/)
- Cài đặt Xcode trên macOS

### 2.2 Cấu Hình Xcode

1. Mở `ios/Runner.xcworkspace` trong Xcode
2. Chọn project → Runner → Signing & Capabilities
3. Chọn Team (Apple Developer Account)
4. Bundle Identifier phải unique

### 2.3 Build iOS

```bash
# Build iOS
flutter build ios --release

# Hoặc build trực tiếp trong Xcode
open ios/Runner.xcworkspace
```

### 2.4 Upload lên App Store

1. Trong Xcode: Product → Archive
2. Upload to App Store Connect
3. Điền thông tin app
4. Submit for review

## 🌐 WEB DEPLOYMENT

### 3.1 Build Web

```bash
# Build for production
flutter build web --release

# Files sẽ được tạo trong build/web/
```

### 3.2 Deploy lên Firebase Hosting

```bash
# Cài đặt Firebase CLI
npm install -g firebase-tools

# Login Firebase
firebase login

# Initialize hosting
firebase init hosting

# Deploy
fireploy deploy --only hosting
```

### 3.3 Deploy lên GitHub Pages

1. Push code lên GitHub repository
2. Vào Settings → Pages
3. Chọn source: GitHub Actions
4. Tạo workflow file `.github/workflows/deploy.yml`:

```yaml
name: Deploy Flutter Web

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.9.2'
        
    - run: flutter pub get
    - run: flutter build web --release
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

## 🔧 CẤU HÌNH PRODUCTION

### 4.1 Firebase Production

1. **Tạo Firebase project mới** cho production
2. **Cấu hình domains** trong Authentication settings
3. **Thiết lập Security Rules** chặt chẽ hơn:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Chỉ cho phép authenticated users
    match /places/{placeId} {
      allow read: if true;
      allow write: if request.auth != null && 
        request.auth.token.email_verified == true;
    }
    
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null && 
        request.auth.token.email_verified == true;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId &&
        request.auth.token.email_verified == true;
    }
  }
}
```

### 4.2 Environment Variables

Tạo file `.env`:

```env
FIREBASE_PROJECT_ID=your-production-project
FIREBASE_API_KEY=your-production-api-key
GOOGLE_MAPS_API_KEY=your-maps-api-key
```

### 4.3 App Icons & Splash Screen

```bash
# Generate app icons
flutter pub get
flutter pub run flutter_launcher_icons:main

# Generate splash screen
flutter pub run flutter_native_splash:create
```

## 📊 MONITORING & ANALYTICS

### 5.1 Firebase Analytics

```dart
// Thêm vào main.dart
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize Analytics
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  
  runApp(MyApp());
}
```

### 5.2 Crashlytics

```yaml
# Thêm vào pubspec.yaml
dependencies:
  firebase_crashlytics: ^4.1.3
```

```dart
// Thêm vào main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(MyApp());
}
```

## 🔒 SECURITY CHECKLIST

### Production Security:

- [ ] **Firebase Security Rules** đã được thiết lập chặt chẽ
- [ ] **API Keys** được bảo vệ (không hardcode)
- [ ] **User Authentication** bắt buộc cho các thao tác write
- [ ] **Input Validation** trên client và server
- [ ] **HTTPS** được sử dụng cho tất cả requests
- [ ] **Rate Limiting** được áp dụng
- [ ] **Error Handling** không expose sensitive info

## 📈 PERFORMANCE OPTIMIZATION

### 6.1 Image Optimization

```dart
// Sử dụng cached_network_image
CachedNetworkImage(
  imageUrl: place.thumbnailUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 6.2 Lazy Loading

```dart
// Sử dụng ListView.builder cho danh sách dài
ListView.builder(
  itemCount: places.length,
  itemBuilder: (context, index) => PlaceCard(place: places[index]),
)
```

### 6.3 Code Splitting

```dart
// Lazy load routes
final routes = {
  '/home': (context) => const HomeScreen(),
  '/search': (context) => const SearchScreen(),
  '/map': (context) => const MapScreen(),
};
```

## 🎯 DEPLOYMENT CHECKLIST

### Pre-deployment:

- [ ] **All tests pass** (unit, widget, integration)
- [ ] **Performance testing** completed
- [ ] **Security audit** passed
- [ ] **Firebase rules** configured
- [ ] **App icons** generated
- [ ] **Splash screen** configured
- [ ] **Analytics** integrated
- [ ] **Crashlytics** enabled

### Post-deployment:

- [ ] **App store listing** completed
- [ ] **Screenshots** uploaded
- [ ] **Description** written
- [ ] **Keywords** optimized
- [ ] **Privacy policy** linked
- [ ] **Support contact** provided

## 🚀 LAUNCH STRATEGY

### 1. Soft Launch
- Deploy to limited regions
- Gather user feedback
- Monitor performance metrics

### 2. Full Launch
- Global deployment
- Marketing campaign
- Social media promotion

### 3. Post-Launch
- Monitor user feedback
- Regular updates
- Feature enhancements

---

**Happy Deploying! 🚀**

Remember: Deployment is just the beginning. Continuous monitoring and improvement are key to success!

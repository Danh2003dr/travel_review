# 🧪 HƯỚNG DẪN TESTING

Hướng dẫn toàn diện để test tất cả tính năng của Flutter Travel Review App.

## 🎯 TESTING STRATEGY

### 1. Unit Tests
- Test individual functions và methods
- Test business logic
- Test data models

### 2. Widget Tests
- Test UI components
- Test user interactions
- Test responsive design

### 3. Integration Tests
- Test complete user flows
- Test Firebase integration
- Test cross-platform functionality

## 🚀 CHẠY TẤT CẢ TESTS

```bash
# Chạy tất cả tests
flutter test

# Chạy tests với coverage
flutter test --coverage

# Chạy specific test file
flutter test test/features/home/home_screen_test.dart

# Chạy tests với verbose output
flutter test --verbose
```

## 📱 TESTING ON DIFFERENT PLATFORMS

### Web Testing
```bash
# Test trên Chrome
flutter run -d chrome --web-port=8080

# Test responsive design
# - Mở Developer Tools (F12)
# - Test các breakpoints khác nhau
# - Test touch và mouse interactions
```

### Android Testing
```bash
# Test trên Android device/emulator
flutter run -d android

# Test permissions
# - Location access
# - Camera access
# - Storage access
```

### iOS Testing (nếu có macOS)
```bash
# Test trên iOS simulator
flutter run -d ios

# Test trên iOS device
flutter run -d ios --device-id=DEVICE_ID
```

## 🔥 FIREBASE TESTING

### Authentication Testing
```dart
// Test trong main.dart hoặc tạo test file riêng
import 'package:firebase_auth/firebase_auth.dart';

void testFirebaseAuth() async {
  try {
    // Test Email/Password signup
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'testpassword123',
        );
    
    print('✅ Email/Password signup successful');
    
    // Test sign out
    await FirebaseAuth.instance.signOut();
    print('✅ Sign out successful');
    
    // Test Email/Password signin
    UserCredential signInResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'testpassword123',
        );
    
    print('✅ Email/Password signin successful');
    
  } catch (e) {
    print('❌ Auth test failed: $e');
  }
}
```

### Firestore Testing
```dart
void testFirestore() async {
  try {
    // Test read data
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('places')
        .limit(5)
        .get();
    
    print('✅ Firestore read successful: ${snapshot.docs.length} documents');
    
    // Test write data (nếu có quyền)
    await FirebaseFirestore.instance
        .collection('test')
        .doc('test_doc')
        .set({
          'message': 'Hello from test!',
          'timestamp': FieldValue.serverTimestamp(),
        });
    
    print('✅ Firestore write successful');
    
  } catch (e) {
    print('❌ Firestore test failed: $e');
  }
}
```

### Storage Testing
```dart
void testStorage() async {
  try {
    // Test upload (cần file thật)
    // File file = File('path/to/test/image.jpg');
    // Reference ref = FirebaseStorage.instance.ref().child('test/test.jpg');
    // UploadTask uploadTask = ref.putFile(file);
    // await uploadTask;
    
    // Test download URL
    String downloadURL = await FirebaseStorage.instance
        .ref()
        .child('test/test.jpg')
        .getDownloadURL();
    
    print('✅ Storage download URL successful: $downloadURL');
    
  } catch (e) {
    print('❌ Storage test failed: $e');
  }
}
```

## 🎨 UI TESTING CHECKLIST

### Home Screen
- [ ] **Hero section** hiển thị đúng
- [ ] **Search bar** hoạt động
- [ ] **Categories** có thể click
- [ ] **Featured places** load được
- [ ] **Trending destinations** hiển thị
- [ ] **Navigation** hoạt động

### Search Screen
- [ ] **Search input** hoạt động
- [ ] **Filters** hoạt động
- [ ] **Results** hiển thị đúng
- [ ] **Sort options** hoạt động
- [ ] **Pagination** hoạt động (nếu có)

### Map Screen
- [ ] **Map** load được
- [ ] **Markers** hiển thị
- [ ] **Current location** hoạt động
- [ ] **Place details** hiển thị khi click marker
- [ ] **Navigation** hoạt động

### Authentication
- [ ] **Login form** validation
- [ ] **Register form** validation
- [ ] **Email/Password** authentication
- [ ] **Google Sign-In** hoạt động
- [ ] **Forgot password** hoạt động
- [ ] **Logout** hoạt động

### Profile Screen
- [ ] **User info** hiển thị đúng
- [ ] **Favorites** hiển thị
- [ ] **Reviews** hiển thị
- [ ] **Settings** hoạt động
- [ ] **Edit profile** hoạt động

## 🔧 DEBUGGING TOOLS

### Flutter Inspector
```bash
# Mở Flutter Inspector
flutter run -d chrome
# Sau đó mở DevTools trong browser
```

### Firebase Debug
```bash
# Enable Firebase debug mode
flutter run -d chrome --dart-define=FLUTTER_WEB_USE_SKIA=true
```

### Performance Testing
```bash
# Profile mode
flutter run --profile -d chrome

# Release mode
flutter run --release -d chrome
```

## 📊 TESTING METRICS

### Performance Metrics
- **App startup time** < 3 seconds
- **Screen transition** < 500ms
- **Data loading** < 2 seconds
- **Image loading** < 1 second

### User Experience Metrics
- **Navigation** intuitive
- **Search** fast và accurate
- **Forms** user-friendly
- **Error messages** clear

## 🐛 COMMON ISSUES & SOLUTIONS

### Issue: Firebase connection timeout
**Solution:**
```dart
// Thêm timeout configuration
FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  // Thêm timeout
  connectTimeout: Duration(seconds: 30),
  readTimeout: Duration(seconds: 30),
);
```

### Issue: Images not loading
**Solution:**
```dart
// Sử dụng CachedNetworkImage với error handling
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  // Thêm retry logic
  httpHeaders: {
    'Cache-Control': 'max-age=86400',
  },
)
```

### Issue: Google Sign-In fails
**Solution:**
1. Kiểm tra SHA-1 fingerprint
2. Kiểm tra package name
3. Kiểm tra google-services.json
4. Kiểm tra Firebase Console configuration

## 📱 DEVICE TESTING

### Test trên các devices khác nhau:
- **Desktop:** Chrome, Firefox, Safari
- **Mobile:** Android (various versions), iOS (various versions)
- **Tablet:** iPad, Android tablets

### Test các orientations:
- **Portrait mode**
- **Landscape mode**
- **Responsive design**

## 🎯 AUTOMATED TESTING

### CI/CD Pipeline
```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.9.2'
        
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test --coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v1
      with:
        file: coverage/lcov.info
```

## 📋 FINAL TESTING CHECKLIST

### Pre-release Testing:
- [ ] **All unit tests pass**
- [ ] **All widget tests pass**
- [ ] **All integration tests pass**
- [ ] **Performance tests pass**
- [ ] **Security tests pass**
- [ ] **Cross-platform tests pass**
- [ ] **Firebase integration works**
- [ ] **Authentication works**
- [ ] **Data persistence works**
- [ ] **Offline functionality works**

### User Acceptance Testing:
- [ ] **User can register/login**
- [ ] **User can search places**
- [ ] **User can view place details**
- [ ] **User can add reviews**
- [ ] **User can manage favorites**
- [ ] **User can navigate smoothly**
- [ ] **App works on different devices**
- [ ] **App handles errors gracefully**

---

**Happy Testing! 🧪**

Remember: Good testing leads to better user experience and fewer bugs in production!

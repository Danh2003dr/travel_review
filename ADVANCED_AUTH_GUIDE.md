# 🔐 HƯỚNG DẪN TÍCH HỢP AUTHENTICATION NÂNG CAO

## 📋 Tổng Quan

Dự án đã được tích hợp các tính năng authentication nâng cao:

- ✅ **Reset Password qua Email**
- ✅ **Email Verification**
- ✅ **Phone Authentication (OTP)**
- ✅ **Facebook Login**
- ✅ **Apple Sign-In**
- ✅ **Google Sign-In** (đã có sẵn)

---

## 🚀 TÍNH NĂNG ĐÃ IMPLEMENT

### 1. 🔄 Reset Password qua Email

**File:** `lib/features/auth/forgot_password_screen.dart`

**Cách sử dụng:**
1. User nhập email
2. Nhấn "Gửi email"
3. Kiểm tra hộp thư đến
4. Click vào link đặt lại mật khẩu
5. Nhập mật khẩu mới

**Code:**
```dart
await _authService.sendPasswordResetEmail(email);
```

---

### 2. ✉️ Email Verification

**File:** `lib/features/auth/email_verification_screen.dart`

**Tính năng:**
- Tự động kiểm tra trạng thái verification mỗi 3 giây
- Gửi lại email verification với countdown 60 giây
- Tự động redirect khi email đã verified

**Code:**
```dart
// Gửi email verification
await _authService.sendEmailVerification();

// Kiểm tra trạng thái
await _authService.reloadUser();
bool isVerified = _authService.isEmailVerified;
```

---

### 3. 📱 Phone Authentication

**File:** `lib/features/auth/phone_auth_screen.dart`

**Flow:**
1. User nhập số điện thoại (VD: 0912345678)
2. Hệ thống gửi OTP qua SMS
3. User nhập 6 số OTP
4. Tự động verify và đăng nhập

**Features:**
- PIN code input với animation
- Auto-verify khi nhập đủ 6 số
- Resend OTP functionality
- Format số điện thoại tự động (+84)

**Code:**
```dart
// Gửi OTP
await _authService.verifyPhoneNumber(
  phoneNumber: '+84912345678',
  codeSent: (verificationId) {
    // Lưu verificationId
  },
  verificationFailed: (error) {
    // Xử lý lỗi
  },
);

// Verify OTP
await _authService.signInWithPhoneNumber(
  verificationId: verificationId,
  smsCode: '123456',
  name: 'User Name',
);
```

---

### 4. 👤 Facebook Login

**Tính năng:**
- One-tap sign-in với Facebook
- Tự động tạo user document trong Firestore
- Lấy thông tin profile từ Facebook

**Code:**
```dart
await _authService.signInWithFacebook();
```

**Cấu hình cần thiết:**
1. Tạo Facebook App tại [Facebook Developers](https://developers.facebook.com/)
2. Enable Facebook Login product
3. Thêm OAuth redirect URIs
4. Cập nhật `AndroidManifest.xml` và `Info.plist`

---

### 5. 🍎 Apple Sign-In

**Tính năng:**
- Native Apple Sign-In
- Hỗ trợ Sign in with Apple ID
- Lấy email và full name (nếu user cho phép)

**Code:**
```dart
await _authService.signInWithApple();
```

**Cấu hình cần thiết:**
1. Enable Sign in with Apple trong Apple Developer Portal
2. Thêm capability trong Xcode
3. Configure Service ID

---

## 🛠️ CÀI ĐẶT

### 1. Dependencies

Đã thêm vào `pubspec.yaml`:
```yaml
# Advanced Authentication
flutter_facebook_auth: ^7.1.1
sign_in_with_apple: ^6.1.3
flutter_otp_text_field: ^1.2.0
pin_code_fields: ^8.0.1
```

### 2. Chạy lệnh:
```bash
flutter pub get
```

---

## 📱 CẤU HÌNH FIREBASE

### Enable Authentication Methods:

1. **Email/Password** ✅ (đã có)
2. **Google** ✅ (đã có)
3. **Phone** - Cần enable trong Firebase Console
4. **Facebook** - Cần cấu hình App ID và App Secret
5. **Apple** - Cần cấu hình Service ID

### Bước thực hiện:

#### 1. Phone Authentication:
```bash
# Firebase Console → Authentication → Sign-in method → Phone
# Enable và thêm authorized domains
```

#### 2. Facebook Login:
```bash
# Firebase Console → Authentication → Sign-in method → Facebook
# Nhập App ID và App Secret từ Facebook Developers
```

#### 3. Apple Sign-In:
```bash
# Firebase Console → Authentication → Sign-in method → Apple
# Nhập Service ID, Team ID, Key ID và Private Key
```

---

## 🔧 CẤU HÌNH PLATFORM

### Android (Facebook & Phone Auth)

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<!-- Facebook -->
<meta-data 
  android:name="com.facebook.sdk.ApplicationId"
  android:value="@string/facebook_app_id"/>

<meta-data
  android:name="com.facebook.sdk.ClientToken"
  android:value="@string/facebook_client_token"/>

<!-- Activity for Facebook -->
<activity
  android:name="com.facebook.FacebookActivity"
  android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
  android:label="@string/app_name"/>
```

**File:** `android/app/src/main/res/values/strings.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Travel Review</string>
    <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
    <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
</resources>
```

---

### iOS (Apple & Facebook)

**File:** `ios/Runner/Info.plist`

```xml
<!-- Facebook -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbYOUR_FACEBOOK_APP_ID</string>
    </array>
  </dict>
</array>

<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>Travel Review</string>

<!-- Apple Sign-In (Xcode auto-generated) -->
<key>com.apple.developer.applesignin</key>
<array>
  <string>Default</string>
</array>
```

**Xcode Configuration:**
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Signing & Capabilities → + Capability
4. Add "Sign in with Apple"

---

## 🧪 TESTING

### Test Flow:

#### 1. Email Verification:
```
1. Đăng ký tài khoản mới
2. Hệ thống tự động gửi email verification
3. Check email và click link
4. Refresh app để verify
```

#### 2. Phone Auth:
```
1. Click "Đăng nhập với SĐT"
2. Nhập số điện thoại (0912345678)
3. Nhận OTP qua SMS
4. Nhập OTP
5. Tự động đăng nhập
```

#### 3. Forgot Password:
```
1. Click "Quên mật khẩu?"
2. Nhập email
3. Check email
4. Click link đặt lại mật khẩu
5. Nhập mật khẩu mới
```

#### 4. Social Login:
```
1. Click button tương ứng (Google/Facebook/Apple)
2. Chọn tài khoản
3. Tự động đăng nhập
```

---

## 📊 CẤU TRÚC CODE

### Services:

```
lib/services/
├── auth_service.dart          # Main authentication service
├── firebase_service.dart      # Firebase initialization
└── storage_service.dart       # File upload service
```

### Screens:

```
lib/features/auth/
├── login_screen.dart                  # Login với tất cả methods
├── register_screen.dart               # Registration
├── forgot_password_screen.dart        # Reset password
├── phone_auth_screen.dart             # Phone authentication
└── email_verification_screen.dart     # Email verification
```

### Methods trong AuthService:

```dart
// Email & Password
signInWithEmail()
registerWithEmail()
sendPasswordResetEmail()
updatePassword()

// Email Verification
sendEmailVerification()
reloadUser()
isEmailVerified (getter)

// Phone
verifyPhoneNumber()
signInWithPhoneNumber()
linkPhoneNumber()

// Social Login
signInWithGoogle()
signInWithFacebook()
signInWithApple()

// Account Management
reauthenticateWithEmail()
deleteAccount()
signOut()
```

---

## 🎯 SỬ DỤNG TRONG APP

### 1. Login Screen:
- 5 options: Email, Google, Facebook, Apple, Phone
- Link đến Forgot Password
- Link đến Register

### 2. Register Screen:
- Auto send verification email sau khi đăng ký
- Redirect đến Email Verification Screen

### 3. Profile/Settings:
- Add option để change password
- Add option để link phone number
- Add option để delete account

---

## ⚠️ LƯU Ý

### Security:
1. **Không commit** Facebook App ID, Apple Service ID vào Git
2. Sử dụng **environment variables** cho production
3. Enable **reCAPTCHA** cho Phone Auth (web)
4. Set up **App Check** để chống abuse

### Testing:
1. Phone Auth cần **device thật** (emulator không nhận SMS)
2. Apple Sign-In chỉ hoạt động trên **iOS 13+**
3. Facebook Login cần **app được review** để public

### Production:
1. Enable **Email Verification** bắt buộc
2. Set up **password policy** mạnh hơn
3. Implement **rate limiting**
4. Monitor **authentication logs**

---

## 🔗 LINKS THAM KHẢO

- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [FlutterFire Docs](https://firebase.flutter.dev/)
- [Facebook Login Setup](https://developers.facebook.com/docs/facebook-login)
- [Apple Sign-In Setup](https://developer.apple.com/sign-in-with-apple/)
- [Phone Auth Best Practices](https://firebase.google.com/docs/auth/web/phone-auth)

---

## ✅ CHECKLIST TRIỂN KHAI

### Firebase Console:
- [ ] Enable Phone authentication
- [ ] Enable Facebook authentication (add App ID & Secret)
- [ ] Enable Apple authentication (add Service ID)
- [ ] Configure authorized domains
- [ ] Set up email templates

### Android:
- [ ] Add Facebook App ID to AndroidManifest.xml
- [ ] Add Facebook Client Token
- [ ] Test phone auth on real device
- [ ] Add SHA-1 fingerprint for production

### iOS:
- [ ] Add Facebook URL scheme
- [ ] Enable Sign in with Apple capability
- [ ] Configure Team ID and Bundle ID
- [ ] Test on real iOS device

### Testing:
- [ ] Test email verification flow
- [ ] Test phone auth with real number
- [ ] Test forgot password flow
- [ ] Test all social logins
- [ ] Test error handling

### Production:
- [ ] Remove test accounts
- [ ] Enable reCAPTCHA
- [ ] Set up monitoring
- [ ] Document user flows
- [ ] Train support team

---

**🎉 Chúc bạn thành công với authentication system! 🔐**


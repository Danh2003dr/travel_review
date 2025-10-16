// lib/services/auth_service.dart
// ------------------------------------------------------
// 🔐 AUTHENTICATION SERVICE
// - Quản lý đăng nhập, đăng ký, đăng xuất
// - Hỗ trợ Email/Password và Google Sign-In
// ------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ------------------------------------------------------
  // 👤 LẤY USER HIỆN TẠI
  // ------------------------------------------------------
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ------------------------------------------------------
  // 📧 ĐĂNG NHẬP BẰNG EMAIL & PASSWORD
  // ------------------------------------------------------
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // 📝 ĐĂNG KÝ BẰNG EMAIL & PASSWORD
  // ------------------------------------------------------
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Tạo tài khoản
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cập nhật display name
      await credential.user?.updateDisplayName(name);

      // Tạo document trong Firestore
      if (credential.user != null) {
        await _createUserDocument(
          userId: credential.user!.uid,
          email: email,
          name: name,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // 🔵 ĐĂNG NHẬP BẰNG GOOGLE
  // ------------------------------------------------------
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User cancelled
      }

      // Lấy authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Tạo hoặc cập nhật user document
      if (userCredential.user != null) {
        await _createUserDocument(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? 'User',
          avatarUrl: userCredential.user!.photoURL,
        );
      }

      return userCredential;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      throw 'Đăng nhập Google thất bại';
    }
  }

  // ------------------------------------------------------
  // 🚪 ĐĂNG XUẤT
  // ------------------------------------------------------
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print('❌ Sign Out Error: $e');
      rethrow;
    }
  }

  // ------------------------------------------------------
  // 📄 TẠO USER DOCUMENT TRONG FIRESTORE
  // ------------------------------------------------------
  Future<void> _createUserDocument({
    required String userId,
    required String email,
    required String name,
    String? avatarUrl,
  }) async {
    final userDoc = _firestore.collection('users').doc(userId);

    // Kiểm tra xem document đã tồn tại chưa
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Tạo mới user document
      await userDoc.set({
        'id': userId,
        'email': email,
        'name': name,
        'avatarUrl': avatarUrl ?? 'https://i.pravatar.cc/200?img=5',
        'joinDate': DateTime.now().toIso8601String(),
        'favoritePlaceIds': [],
        'reviewIds': [],
        'totalReviews': 0,
        'averageRating': 0.0,
      });
    }
  }

  // ------------------------------------------------------
  // 👤 GET USER DATA
  // ------------------------------------------------------
  Future<app_user.User?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return app_user.User.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Get User Data Error: $e');
      return null;
    }
  }

  // ------------------------------------------------------
  // 🔄 ĐẶT LẠI MẬT KHẨU
  // ------------------------------------------------------
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // ⚠️ XỬ LÝ EXCEPTION
  // ------------------------------------------------------
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu (tối thiểu 6 ký tự)';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa';
      case 'too-many-requests':
        return 'Quá nhiều yêu cầu. Vui lòng thử lại sau';
      default:
        return 'Đã xảy ra lỗi: ${e.message}';
    }
  }

  // ------------------------------------------------------
  // 🔄 RESET PASSWORD VIA EMAIL
  // ------------------------------------------------------
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // ✉️ EMAIL VERIFICATION
  // ------------------------------------------------------
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('✅ Verification email sent to ${user.email}');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // ------------------------------------------------------
  // 📱 PHONE AUTHENTICATION
  // ------------------------------------------------------
  String? _verificationId;
  int? _resendToken;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    Function(PhoneAuthCredential credential)? verificationCompleted,
    Function(String verificationId)? codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (verificationCompleted != null) {
            verificationCompleted(credential);
          } else {
            // Auto-sign in
            await _auth.signInWithCredential(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          verificationFailed(_handleAuthException(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          if (codeAutoRetrievalTimeout != null) {
            codeAutoRetrievalTimeout(verificationId);
          }
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      verificationFailed('Lỗi xác thực số điện thoại: $e');
    }
  }

  Future<UserCredential?> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
    String? name,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Tạo user document nếu là lần đầu đăng nhập
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserDocument(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: name ?? 'User',
          avatarUrl: userCredential.user!.photoURL,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // 👤 FACEBOOK SIGN-IN
  // ------------------------------------------------------
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Get Facebook access token
        final AccessToken accessToken = result.accessToken!;

        // Create Firebase credential
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in to Firebase
        final userCredential = await _auth.signInWithCredential(
          facebookAuthCredential,
        );

        // Tạo user document nếu là lần đầu đăng nhập
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _createUserDocument(
            userId: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: userCredential.user!.displayName ?? 'Facebook User',
            avatarUrl: userCredential.user!.photoURL,
          );
        }

        print('✅ Facebook sign-in successful');
        return userCredential;
      } else if (result.status == LoginStatus.cancelled) {
        throw 'Đăng nhập Facebook đã bị hủy';
      } else {
        throw 'Đăng nhập Facebook thất bại: ${result.message}';
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Lỗi đăng nhập Facebook: $e';
    }
  }

  // ------------------------------------------------------
  // 🍎 APPLE SIGN-IN
  // ------------------------------------------------------
  Future<UserCredential?> signInWithApple() async {
    try {
      // Request Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // Tạo user document nếu là lần đầu đăng nhập
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final fullName =
            appleCredential.givenName != null &&
                appleCredential.familyName != null
            ? '${appleCredential.givenName} ${appleCredential.familyName}'
            : userCredential.user!.displayName ?? 'Apple User';

        await _createUserDocument(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: fullName,
          avatarUrl: userCredential.user!.photoURL,
        );
      }

      print('✅ Apple sign-in successful');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Lỗi đăng nhập Apple: $e';
    }
  }

  // ------------------------------------------------------
  // 🔐 LINK PHONE NUMBER TO EXISTING ACCOUNT
  // ------------------------------------------------------
  Future<void> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.currentUser?.linkWithCredential(credential);
      print('✅ Phone number linked successfully');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // 🔄 UPDATE PASSWORD
  // ------------------------------------------------------
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      print('✅ Password updated successfully');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // 🔑 RE-AUTHENTICATE USER (for sensitive operations)
  // ------------------------------------------------------
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      print('✅ Re-authentication successful');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ------------------------------------------------------
  // 🗑️ DELETE ACCOUNT
  // ------------------------------------------------------
  Future<void> deleteAccount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        // Delete user document
        await _firestore.collection('users').doc(userId).delete();
        // Delete Firebase Auth user
        await _auth.currentUser?.delete();
        print('✅ Account deleted successfully');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
}

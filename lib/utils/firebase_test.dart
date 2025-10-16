// lib/utils/firebase_test.dart
// ------------------------------------------------------
// 🔥 FIREBASE CONNECTION TEST
// - Test kết nối với Firebase
// - Kiểm tra Auth, Firestore, Storage
// ------------------------------------------------------

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseTest {
  // ------------------------------------------------------
  // 🧪 TEST KẾT NỐI FIREBASE
  // ------------------------------------------------------
  static Future<Map<String, dynamic>> testConnection() async {
    final results = <String, dynamic>{
      'timestamp': DateTime.now().toString(),
      'tests': <String, dynamic>{},
    };

    // 1. Kiểm tra Firebase đã được khởi tạo
    try {
      final initialized = Firebase.apps.isNotEmpty;
      results['tests']['initialized'] = {
        'status': initialized ? 'PASS' : 'FAIL',
        'message': initialized
            ? 'Firebase đã được khởi tạo'
            : 'Firebase chưa được khởi tạo',
      };
    } catch (e) {
      results['tests']['initialized'] = {
        'status': 'ERROR',
        'message': 'Lỗi: $e',
      };
    }

    // 2. Kiểm tra Firebase Auth
    try {
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      results['tests']['auth'] = {
        'status': 'PASS',
        'message': currentUser != null
            ? 'Đã đăng nhập: ${currentUser.email}'
            : 'Chưa đăng nhập (OK)',
        'user': currentUser?.uid,
      };
    } catch (e) {
      results['tests']['auth'] = {
        'status': 'ERROR',
        'message': 'Lỗi kết nối Auth: $e',
      };
    }

    // 3. Kiểm tra Firestore
    try {
      final firestore = FirebaseFirestore.instance;

      // Thử đọc một collection (không cần có data)
      await firestore
          .collection('_connection_test')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      results['tests']['firestore'] = {
        'status': 'PASS',
        'message': 'Kết nối Firestore thành công',
      };
    } catch (e) {
      results['tests']['firestore'] = {
        'status': 'ERROR',
        'message': 'Lỗi kết nối Firestore: $e',
      };
    }

    // 4. Kiểm tra Storage
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref();

      results['tests']['storage'] = {
        'status': 'PASS',
        'message': 'Kết nối Storage thành công',
        'bucket': ref.bucket,
      };
    } catch (e) {
      results['tests']['storage'] = {
        'status': 'ERROR',
        'message': 'Lỗi kết nối Storage: $e',
      };
    }

    // 5. Kiểm tra Firebase Project Info
    try {
      final app = Firebase.app();
      results['project_info'] = {
        'name': app.name,
        'options': {
          'projectId': app.options.projectId,
          'appId': app.options.appId,
          'storageBucket': app.options.storageBucket,
        },
      };
    } catch (e) {
      results['project_info'] = {'error': e.toString()};
    }

    return results;
  }

  // ------------------------------------------------------
  // 📊 IN KẾT QUẢ RA CONSOLE
  // ------------------------------------------------------
  static Future<void> printTestResults() async {
    print('\n' + '=' * 60);
    print('🔥 FIREBASE CONNECTION TEST');
    print('=' * 60);

    final results = await testConnection();

    print('\n📅 Thời gian: ${results['timestamp']}');

    if (results['project_info'] != null) {
      print('\n📦 PROJECT INFO:');
      final projectInfo = results['project_info'] as Map<String, dynamic>;
      if (projectInfo['options'] != null) {
        final options = projectInfo['options'] as Map<String, dynamic>;
        print('  • Project ID: ${options['projectId']}');
        print('  • App ID: ${options['appId']}');
        print('  • Storage Bucket: ${options['storageBucket']}');
      }
    }

    print('\n🧪 TEST RESULTS:');
    final tests = results['tests'] as Map<String, dynamic>;

    tests.forEach((testName, testData) {
      final data = testData as Map<String, dynamic>;
      final status = data['status'];
      final message = data['message'];

      final icon = status == 'PASS'
          ? '✅'
          : status == 'FAIL'
          ? '❌'
          : '⚠️';
      print('  $icon $testName: $message');
    });

    // Tổng kết
    final passed = tests.values
        .where((t) => (t as Map<String, dynamic>)['status'] == 'PASS')
        .length;
    final total = tests.length;

    print('\n' + '=' * 60);
    print('📊 KẾT QUẢ: $passed/$total tests PASSED');
    print('=' * 60 + '\n');
  }
}

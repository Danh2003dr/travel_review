// lib/services/storage_service.dart
// ------------------------------------------------------
// 📸 FIREBASE STORAGE SERVICE
// - Quản lý upload/download ảnh lên Firebase Storage
// - Hỗ trợ upload ảnh review, avatar, place images
// ------------------------------------------------------

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  // ------------------------------------------------------
  // 📤 UPLOAD ẢNH
  // ------------------------------------------------------

  // Upload ảnh chung
  Future<String?> uploadImage({
    required File imageFile,
    required String folder, // 'reviews', 'avatars', 'places'
    String? fileName,
  }) async {
    try {
      // Tạo tên file unique nếu không được cung cấp
      final name = fileName ?? '${_uuid.v4()}.jpg';

      // Tạo reference đến Storage
      final ref = _storage.ref().child('$folder/$name');

      // Upload file
      final uploadTask = ref.putFile(imageFile);

      // Đợi upload hoàn thành
      final snapshot = await uploadTask;

      // Lấy download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ Upload thành công: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Lỗi upload ảnh: $e');
      return null;
    }
  }

  // Upload ảnh avatar
  Future<String?> uploadAvatar(File imageFile, String userId) async {
    return await uploadImage(
      imageFile: imageFile,
      folder: 'avatars',
      fileName: '$userId.jpg',
    );
  }

  // Upload ảnh review
  Future<String?> uploadReviewImage(File imageFile) async {
    return await uploadImage(imageFile: imageFile, folder: 'reviews');
  }

  // Upload nhiều ảnh review
  Future<List<String>> uploadReviewImages(List<File> imageFiles) async {
    final List<String> urls = [];

    for (final file in imageFiles) {
      final url = await uploadReviewImage(file);
      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }

  // Upload ảnh địa điểm
  Future<String?> uploadPlaceImage(File imageFile, String placeId) async {
    return await uploadImage(
      imageFile: imageFile,
      folder: 'places',
      fileName: '$placeId.jpg',
    );
  }

  // ------------------------------------------------------
  // 🗑️ XÓA ẢNH
  // ------------------------------------------------------

  // Xóa ảnh theo URL
  Future<bool> deleteImageByUrl(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print('✅ Xóa ảnh thành công: $imageUrl');
      return true;
    } catch (e) {
      print('❌ Lỗi xóa ảnh: $e');
      return false;
    }
  }

  // Xóa nhiều ảnh
  Future<void> deleteImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      await deleteImageByUrl(url);
    }
  }

  // ------------------------------------------------------
  // 📊 TIỆN ÍCH
  // ------------------------------------------------------

  // Lấy metadata của ảnh
  Future<FullMetadata?> getImageMetadata(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      return await ref.getMetadata();
    } catch (e) {
      print('❌ Lỗi lấy metadata: $e');
      return null;
    }
  }

  // Kiểm tra ảnh có tồn tại không
  Future<bool> imageExists(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}

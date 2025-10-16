// lib/data/firebase_collection_repository.dart
// ------------------------------------------------------
// 🔥 FIREBASE COLLECTION REPOSITORY
// - Quản lý dữ liệu bộ sưu tập địa điểm với Firestore
// - Cung cấp danh sách bộ sưu tập được tuyển chọn
// ------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/collection.dart';

class FirebaseCollectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _collectionsCollection =>
      _firestore.collection('collections');

  // ------------------------------------------------------
  // 📚 LẤY DANH SÁCH BỘ SƯU TẬP
  // ------------------------------------------------------

  // Lấy tất cả bộ sưu tập
  Future<List<Collection>> fetchCollections() async {
    try {
      final snapshot = await _collectionsCollection
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Collection.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching collections: $e');
      return [];
    }
  }

  // Lấy bộ sưu tập theo category
  Future<List<Collection>> fetchCollectionsByCategory(String category) async {
    try {
      if (category == 'Tất cả') {
        return await fetchCollections();
      }

      final snapshot = await _collectionsCollection
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Collection.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching collections by category: $e');
      return [];
    }
  }

  // Lấy bộ sưu tập theo ID
  Future<Collection?> fetchCollectionById(String id) async {
    try {
      final doc = await _collectionsCollection.doc(id).get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Collection.fromJson(data);
    } catch (e) {
      print('❌ Error fetching collection by ID: $e');
      return null;
    }
  }

  // Lấy các bộ sưu tập phổ biến nhất
  Future<List<Collection>> fetchPopularCollections({int limit = 10}) async {
    try {
      final snapshot = await _collectionsCollection
          .orderBy('viewCount', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Collection.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error fetching popular collections: $e');
      return [];
    }
  }

  // ------------------------------------------------------
  // ✏️ THAO TÁC VỚI BỘ SƯU TẬP
  // ------------------------------------------------------

  // Thêm bộ sưu tập mới
  Future<String?> addCollection(Collection collection) async {
    try {
      final docRef = await _collectionsCollection.add(collection.toJson());
      return docRef.id;
    } catch (e) {
      print('❌ Error adding collection: $e');
      return null;
    }
  }

  // Cập nhật bộ sưu tập
  Future<bool> updateCollection(String id, Map<String, dynamic> data) async {
    try {
      await _collectionsCollection.doc(id).update(data);
      return true;
    } catch (e) {
      print('❌ Error updating collection: $e');
      return false;
    }
  }

  // Xóa bộ sưu tập
  Future<bool> deleteCollection(String id) async {
    try {
      await _collectionsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('❌ Error deleting collection: $e');
      return false;
    }
  }

  // Tăng view count
  Future<void> incrementViewCount(String id) async {
    try {
      await _collectionsCollection.doc(id).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('❌ Error incrementing view count: $e');
    }
  }

  // Tăng save count
  Future<void> incrementSaveCount(String id) async {
    try {
      await _collectionsCollection.doc(id).update({
        'saveCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('❌ Error incrementing save count: $e');
    }
  }

  // ------------------------------------------------------
  // 🔧 TIỆN ÍCH
  // ------------------------------------------------------

  // Lấy các danh mục
  List<String> getCategories() {
    return [
      'Tất cả',
      'Biển',
      'Núi',
      'Văn hóa',
      'Ẩm thực',
      'Lãng mạn',
      'Tiết kiệm',
      'Đảo',
      'Chụp ảnh',
    ];
  }

  // Tìm kiếm bộ sưu tập
  Future<List<Collection>> searchCollections(String keyword) async {
    try {
      final snapshot = await _collectionsCollection.get();

      final collections = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Collection.fromJson(data);
      }).toList();

      // Client-side filtering
      if (keyword.isEmpty) return collections;

      final lowerKeyword = keyword.toLowerCase();
      return collections.where((collection) {
        return collection.title.toLowerCase().contains(lowerKeyword) ||
            collection.description.toLowerCase().contains(lowerKeyword) ||
            collection.category.toLowerCase().contains(lowerKeyword);
      }).toList();
    } catch (e) {
      print('❌ Error searching collections: $e');
      return [];
    }
  }
}

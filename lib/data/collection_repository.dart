// lib/data/collection_repository.dart
// ------------------------------------------------------
// 📚 COLLECTION REPOSITORY - QUẢN LÝ DỮ LIỆU BỘ SƯU TẬP
// - Cung cấp dữ liệu mock cho các bộ sưu tập địa điểm
// - Tương lai sẽ kết nối với API thật
// ------------------------------------------------------

import '../models/collection.dart';

class CollectionRepository {
  // Mock data: Danh sách các bộ sưu tập
  static Future<List<Collection>> fetchCollections() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      Collection(
        id: 'col_1',
        title: 'Top 10 Bãi Biển Đẹp Nhất Việt Nam',
        description:
            'Khám phá những bãi biển tuyệt đẹp với cát trắng, nước trong xanh và phong cảnh tuyệt vời',
        coverImageUrl: 'https://picsum.photos/seed/beach1/800/400',
        placeIds: ['place_1', 'place_2', 'place_3', 'place_4', 'place_5'],
        category: 'Biển',
        viewCount: 12500,
        saveCount: 850,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        curatorName: 'Nguyễn Văn A',
        curatorAvatar: 'https://i.pravatar.cc/100?img=1',
      ),

      Collection(
        id: 'col_2',
        title: 'Địa Điểm Lãng Mạn Cho Cặp Đôi',
        description:
            'Những nơi hoàn hảo cho chuyến du lịch cùng người thương yêu',
        coverImageUrl: 'https://picsum.photos/seed/romantic/800/400',
        placeIds: ['place_6', 'place_7', 'place_8'],
        category: 'Lãng mạn',
        viewCount: 8900,
        saveCount: 620,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        curatorName: 'Trần Thị B',
        curatorAvatar: 'https://i.pravatar.cc/100?img=2',
      ),

      Collection(
        id: 'col_3',
        title: 'Khám Phá Miền Núi Phía Bắc',
        description:
            'Hành trình chinh phục các đỉnh núi hùng vĩ và cảnh quan thiên nhiên tuyệt đẹp',
        coverImageUrl: 'https://picsum.photos/seed/mountain/800/400',
        placeIds: ['place_9', 'place_10', 'place_11', 'place_12'],
        category: 'Núi',
        viewCount: 15200,
        saveCount: 1100,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        curatorName: 'Lê Văn C',
        curatorAvatar: 'https://i.pravatar.cc/100?img=3',
      ),

      Collection(
        id: 'col_4',
        title: 'Ẩm Thực Đường Phố Sài Gòn',
        description:
            'Khám phá những món ăn đường phố ngon nhất tại thành phố Hồ Chí Minh',
        coverImageUrl: 'https://picsum.photos/seed/food/800/400',
        placeIds: ['place_13', 'place_14', 'place_15'],
        category: 'Ẩm thực',
        viewCount: 22000,
        saveCount: 1800,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        curatorName: 'Phạm Thị D',
        curatorAvatar: 'https://i.pravatar.cc/100?img=4',
      ),

      Collection(
        id: 'col_5',
        title: 'Di Sản Văn Hóa Thế Giới',
        description: 'Những di tích lịch sử được UNESCO công nhận tại Việt Nam',
        coverImageUrl: 'https://picsum.photos/seed/heritage/800/400',
        placeIds: ['place_16', 'place_17', 'place_18', 'place_19'],
        category: 'Văn hóa',
        viewCount: 18500,
        saveCount: 1350,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        curatorName: 'Hoàng Văn E',
        curatorAvatar: 'https://i.pravatar.cc/100?img=5',
      ),

      Collection(
        id: 'col_6',
        title: 'Du Lịch Bụi Miền Trung',
        description: 'Hành trình khám phá miền Trung với túi tiền tiết kiệm',
        coverImageUrl: 'https://picsum.photos/seed/central/800/400',
        placeIds: ['place_20', 'place_21', 'place_22'],
        category: 'Tiết kiệm',
        viewCount: 11200,
        saveCount: 750,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        curatorName: 'Vũ Thị F',
        curatorAvatar: 'https://i.pravatar.cc/100?img=6',
      ),

      Collection(
        id: 'col_7',
        title: 'Thiên Đường Nhiệt Đới',
        description: 'Những hòn đảo tuyệt đẹp cho kỳ nghỉ mơ ước',
        coverImageUrl: 'https://picsum.photos/seed/island/800/400',
        placeIds: ['place_23', 'place_24', 'place_25', 'place_26'],
        category: 'Đảo',
        viewCount: 19800,
        saveCount: 1500,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        curatorName: 'Đỗ Văn G',
        curatorAvatar: 'https://i.pravatar.cc/100?img=7',
      ),

      Collection(
        id: 'col_8',
        title: 'Chụp Ảnh Check-in Đẹp Nhất',
        description:
            'Những địa điểm lý tưởng cho những bức ảnh Instagram hoàn hảo',
        coverImageUrl: 'https://picsum.photos/seed/instagram/800/400',
        placeIds: ['place_27', 'place_28', 'place_29'],
        category: 'Chụp ảnh',
        viewCount: 25000,
        saveCount: 2100,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        curatorName: 'Ngô Thị H',
        curatorAvatar: 'https://i.pravatar.cc/100?img=8',
      ),
    ];
  }

  // Lấy bộ sưu tập theo category
  static Future<List<Collection>> fetchCollectionsByCategory(
    String category,
  ) async {
    final allCollections = await fetchCollections();
    return allCollections.where((c) => c.category == category).toList();
  }

  // Lấy bộ sưu tập theo ID
  static Future<Collection?> fetchCollectionById(String id) async {
    final allCollections = await fetchCollections();
    try {
      return allCollections.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Lấy các danh mục
  static List<String> getCategories() {
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
}

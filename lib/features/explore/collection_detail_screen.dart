// lib/features/explore/collection_detail_screen.dart
// ------------------------------------------------------
// 📚 COLLECTION DETAIL SCREEN - CHI TIẾT BỘ SƯU TẬP
// - Hiển thị thông tin chi tiết bộ sưu tập
// - Danh sách các địa điểm trong bộ sưu tập
// - Lưu/Chia sẻ bộ sưu tập
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../models/collection.dart';
import '../../data/in_memory_place_repository.dart';
import '../../models/place.dart';
import '../place/place_detail_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  final Collection collection;

  const CollectionDetailScreen({super.key, required this.collection});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  List<Place> _places = [];
  bool _isLoading = true;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  // Tải danh sách địa điểm trong bộ sưu tập
  Future<void> _loadPlaces() async {
    setState(() => _isLoading = true);

    try {
      final repo = InMemoryPlaceRepository();
      final allPlaces = await repo.fetchTopPlaces(limit: 100);

      // Lọc các địa điểm có trong bộ sưu tập
      // (Trong thực tế sẽ gọi API với danh sách IDs)
      final places = allPlaces.take(widget.collection.placeCount).toList();

      setState(() {
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar với ảnh cover
          _buildSliverAppBar(),

          // Thông tin bộ sưu tập
          SliverToBoxAdapter(child: _buildCollectionInfo()),

          // Danh sách địa điểm
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Địa điểm (${_places.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final place = _places[index];
                      return _buildPlaceCard(place, index + 1);
                    }, childCount: _places.length),
                  ),
                ),
        ],
      ),

      // Bottom bar với nút lưu và chia sẻ
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Sliver App Bar với ảnh cover
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.collection.coverImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 64),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Thông tin bộ sưu tập
  Widget _buildCollectionInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.collection.category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tiêu đề
          Text(
            widget.collection.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Mô tả
          Text(
            widget.collection.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Curator info
          Row(
            children: [
              if (widget.collection.curatorAvatar.isNotEmpty)
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.collection.curatorAvatar,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.collection.curatorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Người tạo bộ sưu tập',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              _buildStatItem(
                Icons.remove_red_eye,
                '${_formatCount(widget.collection.viewCount)} lượt xem',
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                Icons.bookmark,
                '${_formatCount(widget.collection.saveCount)} lượt lưu',
              ),
            ],
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }

  // Stat item
  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  // Card địa điểm
  Widget _buildPlaceCard(Place place, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openPlaceDetail(place),
        child: Row(
          children: [
            // Số thứ tự
            Container(
              width: 50,
              height: 100,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              alignment: Alignment.center,
              child: Text(
                '#$index',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            // Ảnh
            Image.network(
              place.thumbnailUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),

            // Thông tin
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${place.city}, ${place.country}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          place.ratingAvg.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${place.ratingCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom bar
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Nút lưu
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _toggleSave,
              icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
              label: Text(_isSaved ? 'Đã lưu' : 'Lưu'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nút chia sẻ
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _share,
              icon: const Icon(Icons.share),
              label: const Text('Chia sẻ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Format số
  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  // Toggle lưu
  void _toggleSave() {
    setState(() => _isSaved = !_isSaved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? 'Đã lưu bộ sưu tập' : 'Đã bỏ lưu bộ sưu tập'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Chia sẻ
  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chia sẻ đang phát triển'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Mở chi tiết địa điểm
  void _openPlaceDetail(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(placeId: place.id),
      ),
    );
  }
}

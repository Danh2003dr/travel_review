// lib/features/place/place_detail_screen.dart
// ------------------------------------------------------
// 📍 PLACE DETAIL SCREEN
// - Ảnh hero, mô tả, rating, vị trí (map placeholder)
// - Nút Viết review / Yêu thích
// - Danh sách review gần đây (mock từ repo)
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../di/repo_provider.dart';
import '../../models/place.dart';
import '../../models/review.dart';
import '../../widgets/hero_image.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/review_tile.dart';
import '../../data/user_repository.dart';
import '../review/write_review_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late Future<Place?> _futurePlace;
  late Future<List<Review>> _futureReviews;
  final UserRepository _userRepository = UserRepository();
  bool _isFavorite = false;
  bool _isLoadingFavorite = false;

  @override
  void initState() {
    super.initState();
    _futurePlace = placeRepo.getPlaceById(widget.placeId);
    _futureReviews = placeRepo.fetchReviews(widget.placeId, limit: 10);
    _checkFavoriteStatus();
  }

  // Kiểm tra trạng thái yêu thích
  void _checkFavoriteStatus() {
    _isFavorite = _userRepository.isFavorite(widget.placeId);
  }

  // Toggle yêu thích
  Future<void> _toggleFavorite() async {
    setState(() => _isLoadingFavorite = true);

    try {
      await _userRepository.toggleFavorite(widget.placeId);
      setState(() {
        _isFavorite = _userRepository.isFavorite(widget.placeId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? 'Đã thêm vào yêu thích' : 'Đã bỏ yêu thích',
            ),
            backgroundColor: _isFavorite ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      setState(() => _isLoadingFavorite = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Place?>(
        future: _futurePlace,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final place = snap.data;
          if (place == null) {
            return const EmptyView(
              message: 'Địa điểm không tồn tại hoặc đã bị ẩn.',
            );
          }

          return CustomScrollView(
            slivers: [
              // Ảnh hero trong SliverAppBar
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: _isLoadingFavorite ? null : _toggleFavorite,
                    tooltip: _isFavorite ? 'Bỏ yêu thích' : 'Thêm yêu thích',
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _showShareDialog(place),
                    tooltip: 'Chia sẻ',
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    place.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  background: HeroImage(url: place.thumbnailUrl),
                ),
              ),

              // Thông tin tổng quan
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating tổng quan
                      Row(
                        children: [
                          RatingStars(rating: place.ratingAvg, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${place.ratingAvg.toStringAsFixed(1)} (${place.ratingCount} đánh giá)',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Loại hình và địa chỉ
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              place.type,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${place.city}, ${place.country}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mô tả
                      Text(place.description),
                      const SizedBox(height: 16),

                      // Bản đồ (placeholder) — sau này thay GoogleMap
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '🌍 Bản đồ (placeholder)\nlat: ${place.lat}, lng: ${place.lng}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Hành động
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                _openWriteReview();
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Viết review'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLoadingFavorite
                                  ? null
                                  : _toggleFavorite,
                              icon: _isLoadingFavorite
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      _isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                              label: Text(
                                _isFavorite ? 'Đã yêu thích' : 'Yêu thích',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _isFavorite
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                                side: BorderSide(
                                  color: _isFavorite
                                      ? Colors.red
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Đánh giá gần đây',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // Danh sách review
              FutureBuilder<List<Review>>(
                future: _futureReviews,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  final list = snap.data ?? [];
                  if (list.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: EmptyView(
                          message: 'Chưa có review nào. Hãy là người đầu tiên!',
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ReviewTile(review: list[index]),
                      childCount: list.length,
                    ),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  // Hiển thị dialog chia sẻ
  void _showShareDialog(Place place) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chia sẻ địa điểm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Thông tin địa điểm
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      place.thumbnailUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.place),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${place.city}, ${place.country}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        RatingStars(rating: place.ratingAvg, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Các tùy chọn chia sẻ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.copy, 'Sao chép link', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã sao chép link')),
                  );
                }),
                _buildShareOption(Icons.message, 'Tin nhắn', () {
                  Navigator.pop(context);
                  _showComingSoon();
                }),
                _buildShareOption(Icons.email, 'Email', () {
                  Navigator.pop(context);
                  _showComingSoon();
                }),
                _buildShareOption(Icons.more_horiz, 'Khác', () {
                  Navigator.pop(context);
                  _showComingSoon();
                }),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget tùy chọn chia sẻ
  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Mở màn hình viết review
  Future<void> _openWriteReview() async {
    final place = await _futurePlace;
    if (place == null || !mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(placeId: place.id),
      ),
    );

    if (result == true) {
      // Refresh reviews if review was submitted
      setState(() {
        _futureReviews = placeRepo.fetchReviews(widget.placeId, limit: 10);
      });
    }
  }

  // Hiển thị thông báo "sắp ra mắt"
  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng này sẽ sớm ra mắt!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

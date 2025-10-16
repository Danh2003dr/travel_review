// lib/features/place/enhanced_place_detail_screen.dart
// ------------------------------------------------------
// 🏖️ ENHANCED PLACE DETAIL SCREEN
// - Hiển thị chi tiết địa điểm với reviews
// - Tích hợp favorites và reviews
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/place.dart';
import '../../models/review.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/hero_image.dart';
import '../review/write_review_screen.dart';

class EnhancedPlaceDetailScreen extends StatefulWidget {
  final String placeId;

  const EnhancedPlaceDetailScreen({super.key, required this.placeId});

  @override
  State<EnhancedPlaceDetailScreen> createState() =>
      _EnhancedPlaceDetailScreenState();
}

class _EnhancedPlaceDetailScreenState extends State<EnhancedPlaceDetailScreen> {
  Place? _place;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaceData();
  }

  Future<void> _loadPlaceData() async {
    // TODO: Load place data từ repository
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_place == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Không tìm thấy địa điểm')),
        body: const Center(child: Text('Địa điểm không tồn tại')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [_buildAppBar(), _buildPlaceInfo(), _buildReviewsSection()],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: HeroImage(
          url: _place!.thumbnailUrl,
          heroTag: 'place_${_place!.id}',
        ),
      ),
      actions: [
        Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            final isFavorite = favoritesProvider.isFavorite(_place!.id);

            return IconButton(
              onPressed: authProvider.isAuthenticated
                  ? () => _toggleFavorite(
                      favoritesProvider,
                      authProvider.user!.id,
                    )
                  : () => _showLoginDialog(),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            );
          },
        ),
        IconButton(
          onPressed: () => _sharePlace(),
          icon: const Icon(Icons.share, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPlaceInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _place!.name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                const SizedBox(width: 4),
                Text(
                  '${_place!.city}, ${_place!.country}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                RatingStars(rating: _place!.ratingAvg, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_place!.ratingAvg.toStringAsFixed(1)} (${_place!.ratingCount} đánh giá)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _place!.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return SliverToBoxAdapter(
      child: Consumer<ReviewsProvider>(
        builder: (context, reviewsProvider, child) {
          final reviews = reviewsProvider.getReviewsForPlace(_place!.id);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đánh giá (${reviews.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        if (authProvider.isAuthenticated) {
                          return TextButton.icon(
                            onPressed: () => _showWriteReviewDialog(),
                            icon: const Icon(Icons.edit),
                            label: const Text('Viết đánh giá'),
                          );
                        }
                        return TextButton.icon(
                          onPressed: () => _showLoginDialog(),
                          icon: const Icon(Icons.edit),
                          label: const Text('Đăng nhập để đánh giá'),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (reviews.isEmpty)
                  const Center(child: Text('Chưa có đánh giá nào'))
                else
                  ...reviews.map((review) => _buildReviewTile(review)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewTile(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review.userAvatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatDate(review.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                RatingStars(rating: review.rating, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Text(review.content),
            if (review.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  review.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return FloatingActionButton.extended(
            onPressed: () => _showWriteReviewDialog(),
            icon: const Icon(Icons.star),
            label: const Text('Đánh giá'),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else {
      return 'Vừa xong';
    }
  }

  void _toggleFavorite(FavoritesProvider favoritesProvider, String userId) {
    final isFavorite = favoritesProvider.isFavorite(_place!.id);

    if (isFavorite) {
      favoritesProvider.removeFromFavorites(userId, _place!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa ${_place!.name} khỏi yêu thích')),
      );
    } else {
      favoritesProvider.addToFavorites(userId, _place!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm ${_place!.name} vào yêu thích')),
      );
    }
  }

  void _sharePlace() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng chia sẻ sẽ được cập nhật')),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng nhập'),
        content: const Text('Bạn cần đăng nhập để sử dụng tính năng này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  void _showWriteReviewDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(placeId: _place!.id),
      ),
    );
  }
}

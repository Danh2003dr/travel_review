// lib/features/favorites/favorites_screen.dart
// ------------------------------------------------------
// ❤️ FAVORITES SCREEN - MÀN HÌNH YÊU THÍCH
// - Hiển thị danh sách địa điểm yêu thích
// - Sắp xếp, lọc, tìm kiếm trong favorites
// - Quản lý danh sách yêu thích
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../data/user_repository.dart';
import '../../models/place.dart';
import '../../widgets/favorite_place_tile.dart';
import '../../widgets/place_card.dart';
import '../place/place_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final UserRepository _userRepository = UserRepository();
  List<Place> _favoritePlaces = [];
  bool _isLoading = true;
  bool _isGridView = true;
  String _sortBy = 'date'; // 'date', 'name', 'rating'
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  // Tải danh sách yêu thích
  Future<void> _loadFavoritePlaces() async {
    setState(() => _isLoading = true);

    try {
      final favorites = await _userRepository.getFavoritePlaces();
      setState(() {
        _favoritePlaces = favorites;
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

  // Làm mới dữ liệu
  Future<void> _refreshData() async {
    await _loadFavoritePlaces();
  }

  // Bỏ yêu thích một địa điểm
  Future<void> _removeFavorite(String placeId) async {
    await _userRepository.toggleFavorite(placeId);
    await _loadFavoritePlaces();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã bỏ yêu thích')));
    }
  }

  // Lọc và sắp xếp danh sách
  List<Place> _getFilteredAndSortedPlaces() {
    var places = List<Place>.from(_favoritePlaces);

    // Lọc theo loại
    if (_filterType != 'all') {
      places = places.where((place) => place.type == _filterType).toList();
    }

    // Sắp xếp
    switch (_sortBy) {
      case 'name':
        places.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        places.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
        break;
      case 'date':
      default:
        // Giả sử địa điểm được thêm gần đây có ID lớn hơn
        places.sort((a, b) => b.id.compareTo(a.id));
        break;
    }

    return places;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Nút chuyển đổi view
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
            },
            tooltip: _isGridView ? 'Danh sách' : 'Lưới',
          ),
          // Nút sắp xếp
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() => _sortBy = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('Mới nhất'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('Tên A-Z'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'rating',
                child: Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 8),
                    Text('Đánh giá cao'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Bộ lọc
          _buildFilterBar(),

          // Nội dung chính
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _favoritePlaces.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: _isGridView ? _buildGridView() : _buildListView(),
                  ),
          ),
        ],
      ),
    );
  }

  // Widget thanh lọc
  Widget _buildFilterBar() {
    final filteredPlaces = _getFilteredAndSortedPlaces();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // Thống kê
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredPlaces.length} địa điểm',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (filteredPlaces.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAllFavorites,
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Xóa tất cả'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Chips lọc loại
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'Tất cả'),
                const SizedBox(width: 8),
                _buildFilterChip('biển', 'Biển'),
                const SizedBox(width: 8),
                _buildFilterChip('núi', 'Núi'),
                const SizedBox(width: 8),
                _buildFilterChip('văn hóa', 'Văn hóa'),
                const SizedBox(width: 8),
                _buildFilterChip('thiên nhiên', 'Thiên nhiên'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget filter chip
  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterType = value);
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  // Widget trạng thái trống
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có địa điểm yêu thích nào',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy khám phá và thêm những địa điểm bạn quan tâm vào danh sách yêu thích',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to home or search
                Navigator.of(context).pop();
                // Navigate to main tab (home)
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/main', (route) => false);
              },
              icon: const Icon(Icons.explore),
              label: const Text('Khám phá ngay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget danh sách dạng grid
  Widget _buildGridView() {
    final places = _getFilteredAndSortedPlaces();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return PlaceCard(place: place, onTap: () => _navigateToDetail(place));
      },
    );
  }

  // Widget danh sách dạng list
  Widget _buildListView() {
    final places = _getFilteredAndSortedPlaces();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return FavoritePlaceTile(
          place: place,
          onRemoveFavorite: () => _removeFavorite(place.id),
          onTap: () => _navigateToDetail(place),
        );
      },
    );
  }

  // Chuyển đến trang chi tiết
  void _navigateToDetail(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(placeId: place.id),
      ),
    );
  }

  // Xóa tất cả yêu thích
  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả yêu thích'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả địa điểm yêu thích?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Implement clear all favorites
              try {
                // Clear all favorites from repository
                for (final place in _favoritePlaces) {
                  await _userRepository.toggleFavorite(place.id);
                }
                await _loadFavoritePlaces();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa tất cả yêu thích!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi xóa yêu thích: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// lib/features/profile/profile_screen.dart
// ------------------------------------------------------
// 👤 PROFILE SCREEN - TRANG CÁ NHÂN HOÀN CHỈNH
// - Hiển thị thông tin người dùng
// - Tab My Reviews: Danh sách các review đã viết
// - Tab Favorites: Danh sách địa điểm yêu thích
// - Thống kê hoạt động của user
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/review.dart';
import '../../models/place.dart';
import '../../widgets/user_review_tile.dart';
import '../../widgets/favorite_place_tile.dart';
import '../../providers/auth_provider.dart';
import '../../di/repo_provider.dart';
import '../settings/settings_screen.dart';
import '../place/place_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Review> _userReviews = [];
  List<Place> _favoritePlaces = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Tải dữ liệu user khi khởi tạo
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.user != null) {
        // Lấy reviews của user
        _userReviews = await userRepo.getUserReviews(authProvider.user!.id);

        // Lấy favorite places
        _favoritePlaces = await userRepo.getUserFavorites(
          authProvider.user!.id,
        );

        // Tính stats
        _stats = {
          'totalReviews': _userReviews.length,
          'totalFavorites': _favoritePlaces.length,
          'avgRating': _userReviews.isEmpty
              ? 0.0
              : _userReviews.map((r) => r.rating).reduce((a, b) => a + b) /
                    _userReviews.length,
        };
      }

      setState(() {
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

  // Làm mới dữ liệu (pull-to-refresh)
  Future<void> _refreshData() async {
    await _loadUserData();
  }

  // Bỏ yêu thích một địa điểm
  Future<void> _removeFavorite(String placeId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      await userRepo.removeFromFavorites(authProvider.user!.id, placeId);
      await _loadUserData();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã bỏ yêu thích')));
      }
    }
  }

  // Hiển thị dialog chỉnh sửa profile
  void _showEditProfileDialog() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user!;

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final bioController = TextEditingController(text: user.bio ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa hồ sơ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar preview
              GestureDetector(
                onTap: _changeAvatar,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : null,
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    child: user.avatarUrl.isEmpty
                        ? Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false, // Email không thể thay đổi
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(
                  labelText: 'Tiểu sử',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () =>
                _updateProfile(nameController.text, bioController.text),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // Thay đổi avatar
  Future<void> _changeAvatar() async {
    // TODO: Implement image picker
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tính năng đang phát triển')));
  }

  // Cập nhật profile
  Future<void> _updateProfile(String name, String bio) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        await userRepo.updateUser({'name': name, 'bio': bio});

        // Refresh auth provider
        await authProvider.refreshUser();
        await _loadUserData();

        Navigator.pop(context);

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đã cập nhật hồ sơ')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi cập nhật: $e')));
      }
    }
  }

  // Widget action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).primaryColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chia sẻ profile
  void _shareProfile() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng chia sẻ đang phát triển')),
    );
  }

  // Hiển thị QR Code
  void _showQRCode() {
    // TODO: Implement QR code generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng QR Code đang phát triển')),
    );
  }

  // Hiển thị thống kê chi tiết
  void _showStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thống kê chi tiết'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Tổng reviews', '${_stats['totalReviews'] ?? 0}'),
            _buildStatRow(
              'Địa điểm yêu thích',
              '${_stats['totalFavorites'] ?? 0}',
            ),
            _buildStatRow(
              'Đánh giá trung bình',
              '${_stats['avgRating']?.toStringAsFixed(1) ?? '0.0'}',
            ),
            const Divider(),
            _buildStatRow('Tham gia từ', 'Tháng này'), // TODO: Add join date
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị stat row
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!authProvider.isAuthenticated || authProvider.user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Bạn chưa đăng nhập'),
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng đăng nhập để xem hồ sơ',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Đăng nhập'),
                ),
              ],
            ),
          );
        }

        final user = authProvider.user!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hồ sơ'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditProfileDialog(),
                tooltip: 'Chỉnh sửa hồ sơ',
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                tooltip: 'Cài đặt',
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: CustomScrollView(
              slivers: [
                // App Bar với thông tin user
                SliverAppBar(
                  expandedHeight: 240,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // Gradient background
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.9),
                                Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        // Decorative circles
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        // Content
                        SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Avatar với border và shadow
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundImage: user.avatarUrl.isNotEmpty
                                      ? NetworkImage(user.avatarUrl)
                                      : null,
                                  backgroundColor: Colors.white,
                                  child: user.avatarUrl.isEmpty
                                      ? Text(
                                          user.name[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                        )
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Tên user
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Email
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),

                              // Bio (nếu có)
                              if (user.bio != null && user.bio!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.bio!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),

                              // Thống kê
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                      'Reviews',
                                      '${_stats['totalReviews'] ?? 0}',
                                    ),
                                    _buildStatItem(
                                      'Yêu thích',
                                      '${_stats['totalFavorites'] ?? 0}',
                                    ),
                                    _buildStatItem(
                                      'Đánh giá TB',
                                      '${_stats['avgRating']?.toStringAsFixed(1) ?? '0.0'}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: 'Reviews',
                          icon: Icon(Icons.rate_review, size: 18),
                        ),
                        Tab(
                          text: 'Yêu thích',
                          icon: Icon(Icons.favorite, size: 18),
                        ),
                      ],
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                // Action buttons
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.share,
                          label: 'Chia sẻ',
                          onTap: _shareProfile,
                        ),
                        _buildActionButton(
                          icon: Icons.qr_code,
                          label: 'QR Code',
                          onTap: _showQRCode,
                        ),
                        _buildActionButton(
                          icon: Icons.analytics,
                          label: 'Thống kê',
                          onTap: _showStats,
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab Content
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab My Reviews
                      _buildReviewsTab(),

                      // Tab Favorites
                      _buildFavoritesTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget hiển thị thống kê
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  // Tab My Reviews
  Widget _buildReviewsTab() {
    if (_userReviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rate_review,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Chưa có review nào',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Hãy khám phá và đánh giá những địa điểm bạn yêu thích để tạo ra những trải nghiệm đáng nhớ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to explore screen
                  Navigator.pushNamed(context, '/explore');
                },
                icon: const Icon(Icons.explore),
                label: const Text('Khám phá ngay'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        final review = _userReviews[index];
        return UserReviewTile(review: review);
      },
    );
  }

  // Tab Favorites
  Widget _buildFavoritesTab() {
    if (_favoritePlaces.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_border,
                  size: 48,
                  color: Colors.red[300],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Chưa có địa điểm yêu thích nào',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Hãy thêm những địa điểm bạn quan tâm vào danh sách yêu thích để dễ dàng truy cập sau này',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to explore screen
                  Navigator.pushNamed(context, '/explore');
                },
                icon: const Icon(Icons.explore),
                label: const Text('Khám phá ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _favoritePlaces.length,
      itemBuilder: (context, index) {
        final place = _favoritePlaces[index];
        return FavoritePlaceTile(
          place: place,
          onRemoveFavorite: () => _removeFavorite(place.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(placeId: place.id),
              ),
            );
          },
        );
      },
    );
  }
}

// Custom delegate cho Sliver TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

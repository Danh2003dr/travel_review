// lib/features/home/home_screen_modern.dart
// ------------------------------------------------------
// 🏠 HOME SCREEN MODERN - Màn hình chính phong cách hiện đại
// ✨ ĐÃ SỬA: Cấu trúc lại với Scaffold và AppBar để có thanh tìm kiếm cố định ở trên cùng.
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'dart:ui'; // Cần cho hiệu ứng BackdropFilter (glassmorphism)
import '../../di/repo_provider.dart';
import '../../models/place.dart';
import '../place/place_detail_screen.dart';
import '../search/search_screen_modern.dart';
import '../explore/explore_screen.dart';
import '../../widgets/safe_network_image.dart';
import '../../constants/app_constants.dart';

class HomeScreenModern extends StatefulWidget {
  const HomeScreenModern({super.key});

  @override
  State<HomeScreenModern> createState() => _HomeScreenModernState();
}

// SingleTickerProviderStateMixin cần thiết cho AnimationController
class _HomeScreenModernState extends State<HomeScreenModern>
    with SingleTickerProviderStateMixin {
  /// Future để lấy và quản lý dữ liệu địa điểm từ API
  late Future<List<Place>> _futurePlaces;

  /// Controller và các đối tượng Animation cho hiệu ứng khởi động màn hình
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation; // Hiệu ứng mờ dần
  late Animation<Offset> _slideAnimation; // Hiệu ứng trượt lên

  /// Danh sách cứng (hard-coded) các danh mục chính
  final List<CategoryItem> _categories = [
    CategoryItem('Bãi biển', Icons.beach_access, const Color(0xFF4facfe)),
    CategoryItem('Núi', Icons.terrain, const Color(0xFF43e97b)),
    CategoryItem('Văn hóa', Icons.account_balance, const Color(0xFF764ba2)),
    CategoryItem('Ẩm thực', Icons.restaurant, const Color(0xFFfa709a)),
    CategoryItem('Thiên nhiên', Icons.nature_people, const Color(0xFFa8edea)),
    CategoryItem('Thành phố', Icons.location_city, const Color(0xFF667eea)),
  ];

  @override
  void initState() {
    super.initState();
    _futurePlaces = placeRepo.fetchTopPlaces(limit: 10);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // WIDGET MỚI: Xây dựng AppBar chứa thanh tìm kiếm
  AppBar _buildTopSearchBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: _goToSearch,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Tìm địa điểm, thành phố...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
          onPressed: () {
            // Xử lý sự kiện bấm chuông thông báo
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // THAY ĐỔI CẤU TRÚC:
    // 1. Dùng Scaffold làm gốc cho màn hình này.
    // 2. extendBodyBehindAppBar = true để nội dung cuộn bên dưới AppBar.
    // 3. body là một CustomScrollView.
    return Scaffold(
      extendBodyBehindAppBar: true, // Cho phép body vẽ phía sau AppBar
      appBar: _buildTopSearchBar(), // Sử dụng AppBar mới
      body: CustomScrollView(
        slivers: [
          // 1. Phần Hero (ảnh bìa)
          _buildHeroSection(context, isMobile),

          // 2. XÓA BỎ THANH TÌM KIẾM CŨ Ở ĐÂY
          // Các widget còn lại được đẩy lên trên một chút để có khoảng cách hợp lý
          SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.sectionSpacing),
          ),
          
          // 3. Các nút hành động nhanh
          SliverToBoxAdapter(child: _buildQuickActions(context)),

          // 4. Danh sách các danh mục
          SliverToBoxAdapter(child: _buildCategories(context)),

          // 5. Tiêu đề và danh sách địa điểm nổi bật
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context, 'Địa Điểm Nổi Bật', 'Xem tất cả',
            ),
          ),
          _buildFeaturedPlaces(context, isMobile),

          // 6. Tiêu đề và danh sách địa điểm thịnh hành
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'Đang Thịnh Hành', 'Khám phá'),
          ),
          _buildTrendingDestinations(context),

          // Khoảng trống dưới cùng
          SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.sectionSpacing * 2),
          ),
        ],
      ),
    );
  }

  /// Widget xây dựng Hero Section (phần đầu trang)
  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return SliverAppBar(
      expandedHeight: AppConstants.heroHeight,
      pinned: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
            ),
          ),
          child: Stack(
            children: [
              // Các hình khối trang trí...
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.explore, color: Colors.white, size: 40),
                              const SizedBox(height: 12),
                              Text(
                                'Khám Phá\nThế Giới',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tìm và khám phá những địa điểm tuyệt vời trên khắp Việt Nam.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: isMobile ? 14 : 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget xây dựng các nút hành động nhanh
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      QuickAction('Khám phá', Icons.explore, _goToExplore),
      QuickAction('Yêu thích', Icons.favorite, () {}),
      QuickAction('Bản đồ', Icons.map, () {}),
      QuickAction('Lịch trình', Icons.event, () {}),
    ];
    return Padding(
      padding: EdgeInsets.all(AppConstants.sectionSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return GestureDetector(
            onTap: action.onTap,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(action.icon,
                      color: Theme.of(context).primaryColor, size: 28),
                ),
                const SizedBox(height: 8),
                Text(action.label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Widget xây dựng danh sách các danh mục (Categories)
  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.sectionSpacing),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: EdgeInsets.only(right: AppConstants.categorySpacing),
            child: GestureDetector(
              onTap: () => _goToSearchWithCategory(category.label),
              child: Column(
                children: [
                  Container(
                    width: AppConstants.categorySize,
                    height: AppConstants.categorySize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [category.color, category.color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: category.color.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Icon(category.icon,
                        color: Colors.white,
                        size: AppConstants.categorySize * 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(category.label,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget chung cho tiêu đề các khu vực
  Widget _buildSectionHeader(BuildContext context, String title, String actionText) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppConstants.sectionSpacing, 32, AppConstants.sectionSpacing, AppConstants.cardSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: _goToExplore,
            child: Row(
              children: [
                Text(actionText),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget xây dựng danh sách địa điểm nổi bật
  Widget _buildFeaturedPlaces(BuildContext context, bool isMobile) {
    return FutureBuilder<List<Place>>(
      future: _futurePlaces,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.hasError) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.sectionSpacing),
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  width: 280,
                  margin: EdgeInsets.only(right: AppConstants.cardSpacing),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          );
        }

        final places = snapshot.data!.take(6).toList();
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.sectionSpacing),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return _buildModernPlaceCard(context, place, isMobile);
              },
            ),
          ),
        );
      },
    );
  }

  /// Widget cho một thẻ địa điểm (Place Card)
  Widget _buildModernPlaceCard(BuildContext context, Place place, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(right: AppConstants.cardSpacing),
      child: GestureDetector(
        onTap: () => _openDetail(place),
        child: Container(
          width: isMobile ? 280 : 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SafeNetworkImage(imageUrl: place.thumbnailUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.4, 0.7, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [ Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)) ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${place.city}, ${place.country}',
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16, left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          place.ratingAvg.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget xây dựng danh sách địa điểm đang thịnh hành
  Widget _buildTrendingDestinations(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: _futurePlaces,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SliverToBoxAdapter( child: Center(child: CircularProgressIndicator()));
        }
        final places = snapshot.data!.skip(6).take(4).toList();
        if (places.isEmpty) { return const SliverToBoxAdapter(child: SizedBox.shrink()); }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.sectionSpacing),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final place = places[index];
                return _buildTrendingCard(context, place);
              },
              childCount: places.length,
            ),
          ),
        );
      },
    );
  }

  /// Widget cho một thẻ địa điểm thịnh hành
  Widget _buildTrendingCard(BuildContext context, Place place) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.cardSpacing),
      child: GestureDetector(
        onTap: () => _openDetail(place),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
                child: SafeNetworkImage(
                    imageUrl: place.thumbnailUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('${place.city}, ${place.country}', style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(place.ratingAvg.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 8),
                          Text('(${place.ratingCount} đánh giá)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToSearch() { Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreenModern(initKeyword: '', initType: ''))); }
  void _goToSearchWithCategory(String category) { Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreenModern(initKeyword: '', initType: category))); }
  void _goToExplore() { Navigator.push(context, MaterialPageRoute(builder: (context) => const ExploreScreen())); }
  void _openDetail(Place place) { Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceDetailScreen(placeId: place.id))); }
}

/// Lớp Helper để lưu thông tin một Danh mục
class CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  CategoryItem(this.label, this.icon, this.color);
}

/// Lớp Helper để lưu thông tin một Hành động nhanh
class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  QuickAction(this.label, this.icon, this.onTap);
}
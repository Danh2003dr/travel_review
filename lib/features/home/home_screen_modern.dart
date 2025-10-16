// lib/features/home/home_screen_modern.dart
// ------------------------------------------------------
// 🏠 HOME SCREEN MODERN - GIAO DIỆN HIỆN ĐẠI
// - Hero section với gradient đẹp
// - Glassmorphism search bar
// - Categories với icons hiện đại
// - Featured places với animations
// - Trending destinations
// - Quick actions
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'dart:ui';
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

class _HomeScreenModernState extends State<HomeScreenModern>
    with SingleTickerProviderStateMixin {
  late Future<List<Place>> _futurePlaces;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // UI Constants - sử dụng constants từ AppConstants
  // Đã được chuyển vào AppConstants để dễ quản lý

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section với Gradient
          _buildHeroSection(context, isMobile, isTablet, isDesktop),

          // Search Bar với Glassmorphism
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: _buildGlassmorphismSearchBar(context),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(child: _buildQuickActions(context)),

          // Categories
          SliverToBoxAdapter(child: _buildCategories(context)),

          // Featured Places
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              'Địa Điểm Nổi Bật',
              'Xem tất cả',
            ),
          ),

          _buildFeaturedPlaces(context, isMobile, isTablet, isDesktop),

          // Trending Destinations
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'Đang Thịnh Hành', 'Khám phá'),
          ),

          _buildTrendingDestinations(context),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.sectionSpacing * 4),
          ),
        ],
      ),
    );
  }

  // Hero Section với gradient đẹp
  Widget _buildHeroSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return SliverAppBar(
      expandedHeight: AppConstants.heroHeight,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF667eea),
                const Color(0xFF764ba2),
                const Color(0xFFf093fb),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles với hiệu ứng đẹp hơn
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.explore,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isMobile
                                ? 'Khám Phá\nThế Giới'
                                : 'Khám Phá Thế Giới',
                            style:
                                (isMobile
                                        ? Theme.of(
                                            context,
                                          ).textTheme.headlineMedium
                                        : Theme.of(
                                            context,
                                          ).textTheme.displaySmall)
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isMobile
                                ? 'Tìm kiếm và khám phá những địa điểm tuyệt vời trên khắp Việt Nam'
                                : 'Tìm kiếm và khám phá những địa điểm tuyệt vời trên khắp Việt Nam',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: isMobile ? 12 : 13,
                              height: 1.2,
                            ),
                            maxLines: isMobile ? 2 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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

  // Search Bar với Glassmorphism đẹp hơn
  Widget _buildGlassmorphismSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.sectionSpacing),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: AppConstants.searchBarHeight,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.95),
                  Colors.white.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SizedBox(
              height: AppConstants.searchBarHeight,
              child: TextField(
                onTap: () => _goToSearch(),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Tìm địa điểm, thành phố...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF667eea),
                          const Color(0xFF764ba2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Quick Actions
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      QuickAction('Khám phá', Icons.explore, () => _goToExplore()),
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
                  width: AppConstants.categorySize * 0.8,
                  height: AppConstants.categorySize * 0.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    action.icon,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Categories với hiệu ứng đẹp hơn
  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 160,
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
              child: Container(
                width: AppConstants.categorySize + 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      category.color,
                      category.color.withValues(alpha: 0.8),
                      category.color.withValues(alpha: 0.6),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: category.color.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        category.icon,
                        color: Colors.white,
                        size: AppConstants.categorySize * 0.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      category.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.sectionSpacing,
        32,
        AppConstants.sectionSpacing,
        AppConstants.cardSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => _goToExplore(),
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

  // Featured Places
  Widget _buildFeaturedPlaces(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return FutureBuilder<List<Place>>(
      future: _futurePlaces,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.sectionSpacing,
                ),
                itemCount: 3,
                itemBuilder: (context, index) => const SizedBox(
                  width: 280,
                  child: Card(
                    child: Center(child: CircularProgressIndicator()),
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
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.sectionSpacing,
              ),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return _buildModernPlaceCard(
                  context,
                  place,
                  index,
                  isMobile,
                  isTablet,
                  isDesktop,
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Modern Place Card
  Widget _buildModernPlaceCard(
    BuildContext context,
    Place place,
    int index,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: AppConstants.categorySpacing),
      child: GestureDetector(
        onTap: () => _openDetail(place),
        child: Container(
          width: isMobile ? 280 : (isTablet ? 320 : 350),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                SafeNetworkImage(
                  imageUrl: place.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 64),
                  ),
                ),

                // Gradient overlay với hiệu ứng đẹp hơn
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating badge với hiệu ứng đẹp hơn
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.amber.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                place.ratingAvg.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Place name với typography đẹp hơn
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${place.city}, ${place.country}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Trending Destinations
  Widget _buildTrendingDestinations(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: _futurePlaces,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final places = snapshot.data!.skip(6).take(4).toList();

        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.sectionSpacing,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final place = places[index];
              return _buildTrendingCard(context, place, index + 1);
            }, childCount: places.length),
          ),
        );
      },
    );
  }

  // Trending Card
  Widget _buildTrendingCard(BuildContext context, Place place, int rank) {
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
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: SafeNetworkImage(
                  imageUrl: place.thumbnailUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            place.ratingAvg.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${place.ratingCount} reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${place.city}, ${place.country}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods
  void _goToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SearchScreenModern(initKeyword: '', initType: ''),
      ),
    );
  }

  void _goToSearchWithCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchScreenModern(initKeyword: '', initType: category),
      ),
    );
  }

  void _goToExplore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExploreScreen()),
    );
  }

  void _openDetail(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(placeId: place.id),
      ),
    );
  }
}

// Helper classes
class CategoryItem {
  final String label;
  final IconData icon;
  final Color color;

  CategoryItem(this.label, this.icon, this.color);
}

class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  QuickAction(this.label, this.icon, this.onTap);
}

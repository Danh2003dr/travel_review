// lib/features/search/search_screen_modern.dart
// ------------------------------------------------------
// 🔍 SEARCH SCREEN MODERN - TÌM KIẾM HIỆN ĐẠI
// - Search bar với real-time suggestions
// - Advanced filters với modern chips
// - Result cards với hover effects
// - Sort options với bottom sheet
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../di/repo_provider.dart';
import '../../models/place.dart';
import '../place/place_detail_screen.dart';

class SearchScreenModern extends StatefulWidget {
  final String initKeyword;
  final String initType;

  const SearchScreenModern({
    super.key,
    this.initKeyword = '',
    this.initType = '',
  });

  @override
  State<SearchScreenModern> createState() => _SearchScreenModernState();
}

class _SearchScreenModernState extends State<SearchScreenModern>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<Place> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String _selectedType = '';
  double _minRating = 0;
  double _maxRating = 5;
  String _sortBy = 'rating';

  late AnimationController _listAnimationController;
  late AnimationController _filterAnimationController;
  final List<Animation<double>> _itemAnimations = [];

  final List<FilterOption> _filters = [
    FilterOption('Tất cả', '', Icons.explore),
    FilterOption('Bãi biển', 'beach', Icons.beach_access),
    FilterOption('Núi', 'mountain', Icons.terrain),
    FilterOption('Văn hóa', 'cultural', Icons.account_balance),
    FilterOption('Thiên nhiên', 'nature', Icons.nature_people),
    FilterOption('Ẩm thực', 'restaurant', Icons.restaurant),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initKeyword;
    _selectedType = widget.initType;

    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.initKeyword.isNotEmpty || widget.initType.isNotEmpty) {
      _runSearch();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimationController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  // Thực hiện tìm kiếm
  Future<void> _runSearch() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty && _selectedType.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _itemAnimations.clear();
    });

    try {
      var allPlaces = await placeRepo.fetchTopPlaces(limit: 50);

      // Lọc theo keyword
      if (keyword.isNotEmpty) {
        allPlaces = allPlaces.where((p) {
          final matchName = p.name.toLowerCase().contains(
            keyword.toLowerCase(),
          );
          final matchCity = p.city.toLowerCase().contains(
            keyword.toLowerCase(),
          );
          final matchCountry = p.country.toLowerCase().contains(
            keyword.toLowerCase(),
          );
          return matchName || matchCity || matchCountry;
        }).toList();
      }

      // Lọc theo loại
      if (_selectedType.isNotEmpty) {
        allPlaces = allPlaces
            .where((p) => p.type.toLowerCase() == _selectedType.toLowerCase())
            .toList();
      }

      // Lọc theo rating
      allPlaces = allPlaces
          .where((p) => p.ratingAvg >= _minRating && p.ratingAvg <= _maxRating)
          .toList();

      // Sắp xếp
      switch (_sortBy) {
        case 'rating':
          allPlaces.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
          break;
        case 'name':
          allPlaces.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'reviews':
          allPlaces.sort((a, b) => b.ratingCount.compareTo(a.ratingCount));
          break;
      }

      setState(() {
        _results = allPlaces;
        _isLoading = false;
      });

      // Tạo animations cho các items
      for (int i = 0; i < _results.length; i++) {
        _itemAnimations.add(
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _listAnimationController,
              curve: Interval(
                i * 0.1,
                (i * 0.1) + 0.3,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
        );
      }

      _listAnimationController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _results = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tìm kiếm: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          _buildModernAppBar(),

          // Search Bar
          SliverToBoxAdapter(child: _buildSearchBar()),

          // Filters
          SliverToBoxAdapter(child: _buildFilters()),

          // Sort Options
          SliverToBoxAdapter(child: _buildSortOptions()),

          // Results
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!_hasSearched)
            SliverFillRemaining(child: _buildEmptyState())
          else if (_results.isEmpty)
            SliverFillRemaining(child: _buildNoResults())
          else
            _buildResults(),
        ],
      ),
    );
  }

  // Modern App Bar
  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Tìm Kiếm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search Bar hiện đại
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: (_) => _runSearch(),
          autofocus: widget.initKeyword.isEmpty,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm địa điểm, thành phố...',
            prefixIcon: const Icon(Icons.search, size: 24),
            suffixIcon: _searchController.text.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _results = [];
                            _hasSearched = false;
                          });
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          onPressed: _runSearch,
                        ),
                      ),
                    ],
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Filters với modern chips
  Widget _buildFilters() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedType == filter.value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(
                filter.icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
              label: Text(filter.label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedType = selected ? filter.value : '';
                  if (_hasSearched) _runSearch();
                });
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: isSelected ? 2 : 0,
              shadowColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.3),
            ),
          );
        },
      ),
    );
  }

  // Sort Options
  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.sort, size: 20),
          const SizedBox(width: 8),
          const Text('Sắp xếp:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Đánh giá', 'rating'),
                  const SizedBox(width: 8),
                  _buildSortChip('Tên A-Z', 'name'),
                  const SizedBox(width: 8),
                  _buildSortChip('Số reviews', 'reviews'),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showAdvancedFilters,
            tooltip: 'Bộ lọc nâng cao',
          ),
        ],
      ),
    );
  }

  // Sort Chip
  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _sortBy = value;
          if (_hasSearched) _runSearch();
        });
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  // Results list
  Widget _buildResults() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final place = _results[index];
          final animation = index < _itemAnimations.length
              ? _itemAnimations[index]
              : AlwaysStoppedAnimation(1.0);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(animation),
              child: _buildModernResultCard(place),
            ),
          );
        }, childCount: _results.length),
      ),
    );
  }

  // Modern Result Card
  Widget _buildModernResultCard(Place place) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _openDetail(place),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      place.thumbnailUrl,
                      width: 120,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 140,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              place.ratingAvg.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${place.city}, ${place.country}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          place.type,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Reviews count
                      Text(
                        '${place.ratingCount} đánh giá',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow
              Padding(
                padding: const EdgeInsets.only(right: 16),
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

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tìm kiếm địa điểm du lịch',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập tên địa điểm hoặc chọn danh mục',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // No Results
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Không tìm thấy kết quả',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Thử tìm kiếm với từ khóa khác',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Show Advanced Filters
  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAdvancedFiltersSheet(),
    );
  }

  // Advanced Filters Sheet
  Widget _buildAdvancedFiltersSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bộ Lọc Nâng Cao',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _minRating = 0;
                          _maxRating = 5;
                        });
                      },
                      child: const Text('Đặt lại'),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Rating Filter
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đánh giá',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('${_minRating.toStringAsFixed(1)} ⭐'),
                          Expanded(
                            child: RangeSlider(
                              values: RangeValues(_minRating, _maxRating),
                              min: 0,
                              max: 5,
                              divisions: 10,
                              labels: RangeLabels(
                                _minRating.toStringAsFixed(1),
                                _maxRating.toStringAsFixed(1),
                              ),
                              onChanged: (values) {
                                setModalState(() {
                                  _minRating = values.start;
                                  _maxRating = values.end;
                                });
                              },
                            ),
                          ),
                          Text('${_maxRating.toStringAsFixed(1)} ⭐'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Apply Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _runSearch());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Áp dụng bộ lọc',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

// Helper class
class FilterOption {
  final String label;
  final String value;
  final IconData icon;

  FilterOption(this.label, this.value, this.icon);
}

// lib/features/search/enhanced_search_screen.dart
// ------------------------------------------------------
// 🔍 ENHANCED SEARCH SCREEN
// - Tìm kiếm nâng cao với filters
// - Kết quả real-time
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../models/place.dart';
import '../../widgets/place_card.dart';
import '../../widgets/modern_search_bar.dart';
import '../place/enhanced_place_detail_screen.dart';

class EnhancedSearchScreen extends StatefulWidget {
  const EnhancedSearchScreen({super.key});

  @override
  State<EnhancedSearchScreen> createState() => _EnhancedSearchScreenState();
}

class _EnhancedSearchScreenState extends State<EnhancedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = '';
  double _minRating = 0.0;
  String _sortBy = 'rating'; // rating, name, distance

  List<Place> _allPlaces = [];
  List<Place> _filteredPlaces = [];
  bool _isLoading = false;

  final List<String> _placeTypes = [
    'Tất cả',
    'Biển',
    'Núi',
    'Văn hóa',
    'Thiên nhiên',
    'Ẩm thực',
    'Thành phố',
  ];

  final List<Map<String, dynamic>> _sortOptions = [
    {'value': 'rating', 'label': 'Đánh giá cao nhất'},
    {'value': 'name', 'label': 'Tên A-Z'},
    {'value': 'distance', 'label': 'Gần nhất'},
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaces() async {
    setState(() => _isLoading = true);

    // TODO: Load places từ repository
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredPlaces = _allPlaces;
    });
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      _filteredPlaces = _allPlaces.where((place) {
        // Text search
        final matchesText =
            query.isEmpty ||
            place.name.toLowerCase().contains(query) ||
            place.city.toLowerCase().contains(query) ||
            place.description.toLowerCase().contains(query);

        // Type filter
        final matchesType =
            _selectedType.isEmpty ||
            _selectedType == 'Tất cả' ||
            place.type.toLowerCase() == _selectedType.toLowerCase();

        // Rating filter
        final matchesRating = place.ratingAvg >= _minRating;

        return matchesText && matchesType && matchesRating;
      }).toList();

      _sortResults();
    });
  }

  void _sortResults() {
    switch (_sortBy) {
      case 'rating':
        _filteredPlaces.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
        break;
      case 'name':
        _filteredPlaces.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'distance':
        // TODO: Sort by distance
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm'), elevation: 0),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          ModernSearchBar(
            controller: _searchController,
            hintText: 'Tìm địa điểm, thành phố...',
            onChanged: (_) => _performSearch(),
            onSubmitted: (_) => _performSearch(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeFilter(),
          const SizedBox(height: 16),
          _buildRatingFilter(),
          const SizedBox(height: 16),
          _buildSortFilter(),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại địa điểm',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _placeTypes.map((type) {
              final isSelected = _selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? type : '';
                      _performSearch();
                    });
                  },
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Đánh giá tối thiểu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _minRating.toStringAsFixed(1),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _minRating,
          min: 0.0,
          max: 5.0,
          divisions: 10,
          onChanged: (value) {
            setState(() {
              _minRating = value;
              _performSearch();
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0.0', style: TextStyle(color: Colors.grey[600])),
            Text('5.0', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildSortFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sắp xếp theo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _sortBy,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: _sortOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(option['label']),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _sortBy = value;
                _sortResults();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredPlaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tìm thấy ${_filteredPlaces.length} địa điểm',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Xóa bộ lọc'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPlaces.length,
            itemBuilder: (context, index) {
              final place = _filteredPlaces[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PlaceCard(
                  place: place,
                  onTap: () => _openPlaceDetail(place),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedType = '';
      _minRating = 0.0;
      _sortBy = 'rating';
      _searchController.clear();
      _performSearch();
    });
  }

  void _openPlaceDetail(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedPlaceDetailScreen(placeId: place.id),
      ),
    );
  }
}

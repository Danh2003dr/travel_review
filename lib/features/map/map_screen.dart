// lib/features/map/map_screen.dart
// ------------------------------------------------------
// 🗺️ MAP SCREEN - MÀN HÌNH BẢN ĐỒ NÂNG CAO
// - Hiển thị bản đồ với các địa điểm du lịch
// - Tìm kiếm, lọc, xem chi tiết địa điểm trên bản đồ
// - Định vị vị trí hiện tại và hướng dẫn đường đi
// - Sử dụng OpenStreetMap MIỄN PHÍ
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../di/repo_provider.dart';
import '../../models/place.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/safe_network_image.dart';
import '../place/place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Place> _places = [];
  List<Place> _filteredPlaces = [];
  bool _isLoading = true;
  String _selectedType = 'all';
  String _searchQuery = '';
  bool _showSearchBar = false;
  bool _showFilters = false;
  LatLng? _currentLocation; // Vị trí hiện tại của người dùng (mock)

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _mockCurrentLocation(); // Mock vị trí người dùng
  }

  // Mock vị trí hiện tại của người dùng (Hà Nội, Việt Nam)
  void _mockCurrentLocation() {
    setState(() {
      _currentLocation = const LatLng(21.0285, 105.8542);
    });
  }

  // Tải danh sách địa điểm
  Future<void> _loadPlaces() async {
    setState(() => _isLoading = true);

    try {
      final places = await placeRepo.fetchTopPlaces();
      setState(() {
        _places = places;
        _filteredPlaces = places;
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

  // Lọc địa điểm
  void _filterPlaces() {
    setState(() {
      _filteredPlaces = _places.where((place) {
        final matchesType =
            _selectedType == 'all' || place.type == _selectedType;
        final matchesSearch =
            _searchQuery.isEmpty ||
            place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            place.city.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesType && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Bản đồ OpenStreetMap thật (MIỄN PHÍ)
          if (!_isLoading)
            MapWidget(
              places: _filteredPlaces,
              currentLocation: _currentLocation,
              onPlaceTapped: _showPlaceDetail,
            )
          else
            const Center(child: CircularProgressIndicator()),

          // Thanh tìm kiếm
          if (_showSearchBar) _buildSearchBar(),

          // Bộ lọc
          if (_showFilters) _buildFiltersPanel(),

          // Danh sách địa điểm
          _buildPlacesList(),

          // Floating action buttons
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  // Widget thanh tìm kiếm
  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm địa điểm...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchQuery = '';
                  _filterPlaces();
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
            _filterPlaces();
          },
        ),
      ),
    );
  }

  // Widget panel bộ lọc
  Widget _buildFiltersPanel() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lọc theo loại',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _showFilters = false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTypeChip('all', 'Tất cả'),
                _buildTypeChip('biển', 'Biển'),
                _buildTypeChip('núi', 'Núi'),
                _buildTypeChip('văn hóa', 'Văn hóa'),
                _buildTypeChip('thiên nhiên', 'Thiên nhiên'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget chip loại
  Widget _buildTypeChip(String value, String label) {
    final isSelected = _selectedType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedType = value);
        _filterPlaces();
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  // Widget danh sách địa điểm
  Widget _buildPlacesList() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredPlaces.length} địa điểm',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Show all places in full screen
                    },
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
            ),

            // Places list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        return _buildPlaceCard(place);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget card địa điểm
  Widget _buildPlaceCard(Place place) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showPlaceDetail(place),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: SafeNetworkImage(
                  imageUrl: place.thumbnailUrl,
                  height: 60,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  errorWidget: Container(
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.place, color: Colors.grey),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${place.city}, ${place.country}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 8),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 8),
                        const SizedBox(width: 1),
                        Text(
                          '${place.ratingAvg.toStringAsFixed(1)} (${place.ratingCount})',
                          style: const TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget floating action buttons
  Widget _buildFloatingButtons() {
    return Positioned(
      bottom: 200,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'search',
            mini: true,
            onPressed: () {
              setState(() => _showSearchBar = !_showSearchBar);
            },
            backgroundColor: Colors.white,
            child: Icon(
              _showSearchBar ? Icons.close : Icons.search,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'filter',
            mini: true,
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.filter_list,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'location',
            mini: true,
            onPressed: _getCurrentLocation,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'fit_bounds',
            mini: true,
            onPressed: _fitAllPlaces,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.fit_screen,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị chi tiết địa điểm
  void _showPlaceDetail(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(placeId: place.id),
      ),
    );
  }

  // Lấy vị trí hiện tại
  void _getCurrentLocation() {
    // Mock vị trí mới (có thể thay đổi trong tương lai)
    setState(() {
      _currentLocation = const LatLng(21.0285, 105.8542);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã cập nhật vị trí hiện tại'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Fit tất cả địa điểm vào khung nhìn
  void _fitAllPlaces() {
    if (_filteredPlaces.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hiển thị ${_filteredPlaces.length} địa điểm'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có địa điểm nào để hiển thị'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

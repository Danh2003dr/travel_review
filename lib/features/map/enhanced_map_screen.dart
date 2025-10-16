// lib/features/map/enhanced_map_screen.dart
// ------------------------------------------------------
// 🗺️ ENHANCED MAP SCREEN
// - Bản đồ tương tác với markers
// - Hiển thị địa điểm và thông tin chi tiết
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/place.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../place/enhanced_place_detail_screen.dart';

class EnhancedMapScreen extends StatefulWidget {
  const EnhancedMapScreen({super.key});

  @override
  State<EnhancedMapScreen> createState() => _EnhancedMapScreenState();
}

class _EnhancedMapScreenState extends State<EnhancedMapScreen> {
  final MapController _mapController = MapController();
  final List<Place> _places = [];
  // Removed unused field
  LatLng? _currentLocation;
  Place? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _getCurrentLocation();
  }

  Future<void> _loadPlaces() async {
    // TODO: Load places từ repository
    // Removed unused field assignment
  }

  Future<void> _getCurrentLocation() async {
    // TODO: Get current location
    _currentLocation = const LatLng(21.0285, 105.8542); // Hà Nội
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ'),
        actions: [
          IconButton(
            onPressed: _centerOnCurrentLocation,
            icon: const Icon(Icons.my_location),
          ),
          IconButton(onPressed: _toggleMapType, icon: const Icon(Icons.layers)),
        ],
      ),
      body: Stack(
        children: [
          _buildMap(),
          _buildMapControls(),
          if (_selectedPlace != null) _buildPlaceInfoCard(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? const LatLng(21.0285, 105.8542),
        initialZoom: 10.0,
        onTap: (_, __) => setState(() => _selectedPlace = null),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.flutter_travel_review',
        ),
        _buildMarkers(),
        if (_currentLocation != null) _buildCurrentLocationMarker(),
      ],
    );
  }

  Widget _buildMarkers() {
    return MarkerLayer(
      markers: _places.map((place) => _buildPlaceMarker(place)).toList(),
    );
  }

  Marker _buildPlaceMarker(Place place) {
    return Marker(
      point: LatLng(place.lat, place.lng),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () => setState(() => _selectedPlace = place),
        child: Container(
          decoration: BoxDecoration(
            color: _selectedPlace?.id == place.id ? Colors.blue : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(_getPlaceIcon(place.type), color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationMarker() {
    return MarkerLayer(
      markers: [
        Marker(
          point: _currentLocation!,
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(Icons.my_location, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          _buildZoomButton(
            Icons.add,
            () => _mapController.move(
              _mapController.camera.center,
              _mapController.camera.zoom + 1,
            ),
          ),
          const SizedBox(height: 8),
          _buildZoomButton(
            Icons.remove,
            () => _mapController.move(
              _mapController.camera.center,
              _mapController.camera.zoom - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }

  Widget _buildPlaceInfoCard() {
    if (_selectedPlace == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedPlace!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedPlace!.city}, ${_selectedPlace!.country}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      final isFavorite = favoritesProvider.isFavorite(
                        _selectedPlace!.id,
                      );

                      return IconButton(
                        onPressed: authProvider.isAuthenticated
                            ? () => _toggleFavorite(
                                favoritesProvider,
                                authProvider.user!.id,
                              )
                            : () => _showLoginDialog(),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _selectedPlace!.ratingAvg.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${_selectedPlace!.ratingCount} đánh giá)',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openPlaceDetail(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPlaceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'biển':
        return Icons.waves;
      case 'núi':
        return Icons.landscape;
      case 'văn hóa':
        return Icons.museum;
      case 'thiên nhiên':
        return Icons.park;
      case 'ẩm thực':
        return Icons.restaurant;
      default:
        return Icons.place;
    }
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0);
    }
  }

  void _toggleMapType() {
    // TODO: Toggle between different map types
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chuyển đổi bản đồ sẽ được cập nhật'),
      ),
    );
  }

  void _toggleFavorite(FavoritesProvider favoritesProvider, String userId) {
    final isFavorite = favoritesProvider.isFavorite(_selectedPlace!.id);

    if (isFavorite) {
      favoritesProvider.removeFromFavorites(userId, _selectedPlace!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa ${_selectedPlace!.name} khỏi yêu thích'),
        ),
      );
    } else {
      favoritesProvider.addToFavorites(userId, _selectedPlace!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${_selectedPlace!.name} vào yêu thích'),
        ),
      );
    }
  }

  void _openPlaceDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EnhancedPlaceDetailScreen(placeId: _selectedPlace!.id),
      ),
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
}

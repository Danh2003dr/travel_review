// lib/widgets/map_widget.dart
// ------------------------------------------------------
// 🗺️ MAP WIDGET - WIDGET BẢN ĐỒ OPENSTREETMAP
// - Hiển thị bản đồ OpenStreetMap miễn phí
// - Hỗ trợ markers, zoom, pan
// - Không giới hạn sử dụng, hoàn toàn free
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/place.dart';

class MapWidget extends StatefulWidget {
  final List<Place> places;
  final LatLng? currentLocation;
  final Function(Place)? onPlaceTapped;

  const MapWidget({
    super.key,
    required this.places,
    this.currentLocation,
    this.onPlaceTapped,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();

  // Vị trí mặc định (Hà Nội, Việt Nam)
  static const LatLng _defaultCenter = LatLng(21.0285, 105.8542);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        // Vị trí ban đầu của bản đồ
        initialCenter: widget.currentLocation ?? _defaultCenter,
        initialZoom: 13.0,
        minZoom: 5.0,
        maxZoom: 18.0,
        // Giới hạn di chuyển bản đồ trong phạm vi hợp lý
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        // Lớp tile map từ OpenStreetMap (MIỄN PHÍ)
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.flutter_travel_review',
          // Cấu hình hiển thị
          tileProvider: NetworkTileProvider(),
          // Giữ tiles trong cache để tải nhanh hơn
          tileBuilder: _tileBuilder,
        ),

        // Lớp markers cho các địa điểm
        if (widget.places.isNotEmpty) _buildMarkersLayer(),

        // Marker cho vị trí hiện tại của người dùng
        if (widget.currentLocation != null) _buildCurrentLocationMarker(),
      ],
    );
  }

  // Xây dựng lớp markers cho các địa điểm
  Widget _buildMarkersLayer() {
    final markers = widget.places.map((place) {
      // Chuyển đổi tọa độ từ Place model
      final latLng = _getPlaceLatLng(place);

      return Marker(
        point: latLng,
        width: 50,
        height: 50,
        child: GestureDetector(
          onTap: () {
            if (widget.onPlaceTapped != null) {
              widget.onPlaceTapped!(place);
            }
          },
          child: _buildPlaceMarker(place),
        ),
      );
    }).toList();

    return MarkerLayer(markers: markers);
  }

  // Marker cho vị trí hiện tại
  Widget _buildCurrentLocationMarker() {
    return MarkerLayer(
      markers: [
        Marker(
          point: widget.currentLocation!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget marker cho địa điểm
  Widget _buildPlaceMarker(Place place) {
    final color = _getPlaceColor(place.type);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Icon marker
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getPlaceIcon(place.type), color: color, size: 24),
          ),
          // Rating badge
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                place.ratingAvg.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tùy chỉnh hiển thị tiles
  Widget _tileBuilder(BuildContext context, Widget tileWidget, TileImage tile) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.multiply),
      child: tileWidget,
    );
  }

  // Chuyển đổi Place thành LatLng
  // Sử dụng tọa độ mock cho demo, trong thực tế sẽ lấy từ database
  LatLng _getPlaceLatLng(Place place) {
    // Mock coordinates cho các thành phố Việt Nam
    final cityCoordinates = {
      'Hà Nội': const LatLng(21.0285, 105.8542),
      'Hồ Chí Minh': const LatLng(10.8231, 106.6297),
      'Đà Nẵng': const LatLng(16.0544, 108.2022),
      'Hội An': const LatLng(15.8801, 108.3380),
      'Huế': const LatLng(16.4637, 107.5909),
      'Nha Trang': const LatLng(12.2388, 109.1967),
      'Đà Lạt': const LatLng(11.9404, 108.4583),
      'Phú Quốc': const LatLng(10.2899, 103.9840),
      'Sapa': const LatLng(22.3363, 103.8438),
      'Hạ Long': const LatLng(20.9599, 107.0432),
    };

    // Lấy tọa độ từ thành phố, nếu không có thì dùng vị trí mặc định với offset ngẫu nhiên
    final baseCoord = cityCoordinates[place.city] ?? _defaultCenter;

    // Thêm offset ngẫu nhiên nhỏ để các địa điểm không chồng lên nhau
    final offset = (place.id.hashCode % 100) / 10000;
    return LatLng(baseCoord.latitude + offset, baseCoord.longitude + offset);
  }

  // Icon cho từng loại địa điểm
  IconData _getPlaceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'beach':
        return Icons.beach_access;
      case 'mountain':
        return Icons.terrain;
      case 'city':
        return Icons.location_city;
      case 'historical':
        return Icons.account_balance;
      case 'nature':
        return Icons.nature_people;
      case 'cultural':
        return Icons.museum;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.place;
    }
  }

  // Màu sắc cho từng loại địa điểm
  Color _getPlaceColor(String type) {
    switch (type.toLowerCase()) {
      case 'beach':
        return Colors.blue;
      case 'mountain':
        return Colors.green;
      case 'city':
        return Colors.orange;
      case 'historical':
        return Colors.brown;
      case 'nature':
        return Colors.lightGreen;
      case 'cultural':
        return Colors.purple;
      case 'restaurant':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Di chuyển bản đồ đến vị trí cụ thể
  void moveToLocation(LatLng location, {double zoom = 15.0}) {
    _mapController.move(location, zoom);
  }

  // Di chuyển bản đồ để hiển thị tất cả các địa điểm
  void fitBounds(List<Place> places) {
    if (places.isEmpty) return;

    final latLngs = places.map(_getPlaceLatLng).toList();

    // Tính toán bounds
    double minLat = latLngs.first.latitude;
    double maxLat = latLngs.first.latitude;
    double minLng = latLngs.first.longitude;
    double maxLng = latLngs.first.longitude;

    for (final point in latLngs) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }
}

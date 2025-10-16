// lib/features/search/search_screen.dart
// ------------------------------------------------------
// 🔎 SEARCH SCREEN
// - Nhập từ khóa, chọn chip loại hình → hiển thị kết quả dạng Grid
// - Dữ liệu lấy qua PlaceRepository (mock hoặc Firestore tùy DI)
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../widgets/type_chip.dart';
import '../../widgets/place_card.dart';
import '../../widgets/skeletons/place_skeleton.dart';
import '../../widgets/empty_view.dart';
import '../../di/repo_provider.dart';
import '../../models/place.dart';
import '../place/place_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initKeyword;
  final String? initType;
  const SearchScreen({super.key, this.initKeyword = '', this.initType});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _type = '';
  Future<List<Place>>? _future;

  // Filter states
  double _minRating = 0.0;
  double _maxRating = 5.0;
  String _sortBy = 'rating'; // 'rating', 'name', 'reviews'
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initKeyword;
    _type = widget.initType ?? '';
    _future = placeRepo.searchPlaces(keyword: _controller.text, type: _type);
  }

  void _runSearch() {
    setState(() {
      _future = placeRepo
          .searchPlaces(
            keyword: _controller.text.trim(),
            type: _type.isEmpty ? null : _type,
          )
          .then((places) {
            // Apply filters
            var filteredPlaces = places.where((place) {
              return place.ratingAvg >= _minRating &&
                  place.ratingAvg <= _maxRating;
            }).toList();

            // Apply sorting
            switch (_sortBy) {
              case 'rating':
                filteredPlaces.sort(
                  (a, b) => b.ratingAvg.compareTo(a.ratingAvg),
                );
                break;
              case 'name':
                filteredPlaces.sort((a, b) => a.name.compareTo(b.name));
                break;
              case 'reviews':
                filteredPlaces.sort(
                  (a, b) => b.ratingCount.compareTo(a.ratingCount),
                );
                break;
            }

            return filteredPlaces;
          });
    });
  }

  void _openDetail(Place p) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: p.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: widget
              .initKeyword
              .isEmpty, // chỉ autofocus khi không có kw ban đầu
          onSubmitted: (_) => _runSearch(),
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Tìm địa điểm...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list : Icons.filter_list_off,
            ),
            tooltip: 'Bộ lọc',
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm',
            onPressed: _runSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Advanced Filters Panel
          if (_showFilters) _buildFiltersPanel(),

          // Hàng chips lọc loại hình
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                TypeChip(
                  label: 'Tất cả',
                  selected: _type.isEmpty,
                  onTap: () {
                    setState(() => _type = '');
                    _runSearch();
                  },
                ),
                TypeChip(
                  label: 'biển',
                  selected: _type == 'biển',
                  onTap: () {
                    setState(() => _type = 'biển');
                    _runSearch();
                  },
                ),
                TypeChip(
                  label: 'núi',
                  selected: _type == 'núi',
                  onTap: () {
                    setState(() => _type = 'núi');
                    _runSearch();
                  },
                ),
                TypeChip(
                  label: 'văn hóa',
                  selected: _type == 'văn hóa',
                  onTap: () {
                    setState(() => _type = 'văn hóa');
                    _runSearch();
                  },
                ),
                TypeChip(
                  label: 'thiên nhiên',
                  selected: _type == 'thiên nhiên',
                  onTap: () {
                    setState(() => _type = 'thiên nhiên');
                    _runSearch();
                  },
                ),
                TypeChip(
                  label: 'ẩm thực',
                  selected: _type == 'ẩm thực',
                  onTap: () {
                    setState(() => _type = 'ẩm thực');
                    _runSearch();
                  },
                ),
              ],
            ),
          ),

          // Kết quả tìm kiếm
          Expanded(
            child: FutureBuilder<List<Place>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                    itemBuilder: (context, index) => const PlaceSkeleton(),
                    itemCount: 6,
                  );
                }

                if (snap.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: EmptyView(message: 'Có lỗi khi tải dữ liệu.'),
                  );
                }

                final list = snap.data ?? [];
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: EmptyView(
                      message: 'Không tìm thấy địa điểm phù hợp.',
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final p = list[index];
                    return PlaceCard(place: p, onTap: () => _openDetail(p));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị panel bộ lọc nâng cao
  Widget _buildFiltersPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề và nút đóng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bộ lọc nâng cao',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _minRating = 0.0;
                    _maxRating = 5.0;
                    _sortBy = 'rating';
                  });
                  _runSearch();
                },
                child: const Text('Đặt lại'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sắp xếp theo
          const Text(
            'Sắp xếp theo:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSortChip('rating', 'Đánh giá cao')),
              const SizedBox(width: 8),
              Expanded(child: _buildSortChip('name', 'Tên A-Z')),
              const SizedBox(width: 8),
              Expanded(child: _buildSortChip('reviews', 'Nhiều review')),
            ],
          ),

          const SizedBox(height: 16),

          // Khoảng đánh giá
          Text(
            'Đánh giá từ ${_minRating.toStringAsFixed(1)} đến ${_maxRating.toStringAsFixed(1)} sao',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tối thiểu: ${_minRating.toStringAsFixed(1)}'),
                    Slider(
                      value: _minRating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 10,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _minRating = value;
                          if (_minRating > _maxRating) {
                            _maxRating = _minRating;
                          }
                        });
                        _runSearch();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tối đa: ${_maxRating.toStringAsFixed(1)}'),
                    Slider(
                      value: _maxRating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 10,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _maxRating = value;
                          if (_maxRating < _minRating) {
                            _minRating = _maxRating;
                          }
                        });
                        _runSearch();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Nút áp dụng bộ lọc
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _runSearch,
              icon: const Icon(Icons.filter_alt),
              label: const Text('Áp dụng bộ lọc'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget chip sắp xếp
  Widget _buildSortChip(String value, String label) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() => _sortBy = value);
        _runSearch();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

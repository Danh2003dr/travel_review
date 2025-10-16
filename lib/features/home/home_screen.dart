// lib/features/home/home_screen.dart
// ------------------------------------------------------
// 🏠 HOME SCREEN
// - Ô tìm kiếm → điều hướng Search
// - Chips lọc theo loại hình
// - Grid “Top địa điểm nổi bật” (mock qua repo)
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../../widgets/section_header.dart';
import '../../widgets/type_chip.dart';
import '../../widgets/place_card.dart';
import '../../widgets/skeletons/place_skeleton.dart';
import '../../widgets/empty_view.dart';
import '../../di/repo_provider.dart';
import '../../models/place.dart';
import '../place/place_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _selectedType =
      ''; // '', 'biển', 'núi', 'văn hóa', 'thiên nhiên', 'ẩm thực'
  late Future<List<Place>> _futureTop;

  @override
  void initState() {
    super.initState();
    // Lấy top địa điểm (mock) ngay khi mở Home
    _futureTop = placeRepo.fetchTopPlaces(limit: 6);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToSearch() async {
    final kw = _searchController.text.trim();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(initKeyword: kw, initType: _selectedType),
      ),
    );
  }

  void _openDetail(Place p) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: p.id)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // 🔎 Thanh tìm kiếm + chips lọc
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ô tìm kiếm (enter hoặc bấm mũi tên để chuyển sang SearchScreen)
                  TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _goToSearch(),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Tìm địa điểm, thành phố... (VD: Nha Trang)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _goToSearch,
                        tooltip: 'Tìm kiếm',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Chips lọc loại hình (lọc ngay trên danh sách top đang hiển thị)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TypeChip(
                          label: 'Tất cả',
                          selected: _selectedType.isEmpty,
                          onTap: () => setState(() => _selectedType = ''),
                        ),
                        TypeChip(
                          label: 'biển',
                          selected: _selectedType == 'biển',
                          onTap: () => setState(() => _selectedType = 'biển'),
                        ),
                        TypeChip(
                          label: 'núi',
                          selected: _selectedType == 'núi',
                          onTap: () => setState(() => _selectedType = 'núi'),
                        ),
                        TypeChip(
                          label: 'văn hóa',
                          selected: _selectedType == 'văn hóa',
                          onTap: () =>
                              setState(() => _selectedType = 'văn hóa'),
                        ),
                        TypeChip(
                          label: 'thiên nhiên',
                          selected: _selectedType == 'thiên nhiên',
                          onTap: () =>
                              setState(() => _selectedType = 'thiên nhiên'),
                        ),
                        TypeChip(
                          label: 'ẩm thực',
                          selected: _selectedType == 'ẩm thực',
                          onTap: () =>
                              setState(() => _selectedType = 'ẩm thực'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header “Top địa điểm nổi bật”
                  SectionHeader(
                    title: 'Top địa điểm nổi bật',
                    onSeeAll: _goToSearch, // bấm “Xem tất cả” → sang Search
                  ),
                ],
              ),
            ),
          ),

          // 🧩 Grid Top Places (FutureBuilder)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: FutureBuilder<List<Place>>(
              future: _futureTop,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  // Hiển thị skeleton trong lúc chờ dữ liệu
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const PlaceSkeleton(),
                      childCount: 6,
                    ),
                  );
                }

                if (snap.hasError) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: EmptyView(message: 'Có lỗi khi tải dữ liệu.'),
                    ),
                  );
                }

                final data = snap.data ?? [];
                if (data.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: EmptyView(message: 'Chưa có địa điểm nào.'),
                    ),
                  );
                }

                // Lọc theo loại hình nếu có chọn chip
                final filtered = _selectedType.isEmpty
                    ? data
                    : data
                          .where(
                            (p) =>
                                p.type.toLowerCase() ==
                                _selectedType.toLowerCase(),
                          )
                          .toList();

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final p = filtered[index];
                    return PlaceCard(place: p, onTap: () => _openDetail(p));
                  }, childCount: filtered.length),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

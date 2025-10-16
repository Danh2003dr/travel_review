// lib/widgets/favorite_place_tile.dart
// ------------------------------------------------------
// 🧩 FAVORITE PLACE TILE
// - Widget hiển thị một địa điểm yêu thích trong trang Profile
// - Hiển thị thông tin cơ bản và nút bỏ yêu thích
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../models/place.dart';
import 'rating_stars.dart';

class FavoritePlaceTile extends StatelessWidget {
  final Place place;
  final VoidCallback? onRemoveFavorite;
  final VoidCallback? onTap;

  const FavoritePlaceTile({
    super.key,
    required this.place,
    this.onRemoveFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Ảnh địa điểm
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  place.thumbnailUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.place, size: 40),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Thông tin địa điểm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên địa điểm
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Địa chỉ
                    Text(
                      '${place.city}, ${place.country}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Rating và loại hình
                    Row(
                      children: [
                        RatingStars(rating: place.ratingAvg, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          '(${place.ratingCount})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            place.type,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Nút bỏ yêu thích
              IconButton(
                onPressed: onRemoveFavorite,
                icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                tooltip: 'Bỏ yêu thích',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

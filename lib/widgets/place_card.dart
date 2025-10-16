// lib/widgets/place_card.dart
// ------------------------------------------------------
// 🏞️ PLACE CARD
// - Thẻ hiển thị 1 địa điểm (ảnh, tên, thành phố, rating)
// - Dùng trong HomeScreen & SearchScreen
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../models/place.dart';
import 'rating_stars.dart';
import 'safe_network_image.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;
  const PlaceCard({super.key, required this.place, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh thumbnail
            AspectRatio(
              aspectRatio: 3 / 2,
              child: SafeNetworkImage(
                imageUrl: place.thumbnailUrl,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.city}, ${place.country}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      RatingStars(rating: place.ratingAvg, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        place.ratingAvg.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/widgets/rating_stars.dart
// ------------------------------------------------------
// ⭐ RATING STARS
// - Hiển thị dãy sao tương ứng với điểm rating (0–5)
// - Dùng cho PlaceCard và PlaceDetailScreen
// ------------------------------------------------------

import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating; // 0..5
  final double size;
  final Function(double)? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final idx = i + 1;
        final isFull = rating >= idx - 0.2; // trick nhỏ cho đẹp

        Widget star = Icon(
          isFull ? Icons.star : Icons.star_border,
          size: size,
          color: Colors.amber,
        );

        if (onRatingChanged != null) {
          star = GestureDetector(
            onTap: () => onRatingChanged!(idx.toDouble()),
            child: star,
          );
        }

        return star;
      }),
    );
  }
}

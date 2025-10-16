// lib/widgets/review_tile.dart
// ------------------------------------------------------
// 💭 REVIEW TILE
// - Hiển thị 1 review của người dùng trong danh sách
// - Gồm avatar, tên, số sao, nội dung, thời gian đăng
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../models/review.dart';
import 'rating_stars.dart';
import '../utils/date_format.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(review.userAvatar)),
      title: Row(
        children: [
          Expanded(
            child: Text(
              review.userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          RatingStars(rating: review.rating, size: 14),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(review.content),
      ),
      trailing: Text(
        formatDate(review.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

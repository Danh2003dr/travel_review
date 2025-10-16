// lib/widgets/user_review_tile.dart
// ------------------------------------------------------
// 🧩 USER REVIEW TILE
// - Widget hiển thị một review của user trong trang Profile
// - Hiển thị rating, nội dung, thời gian và địa điểm đã review
// ------------------------------------------------------

import 'package:flutter/material.dart';
import '../models/review.dart';
import 'rating_stars.dart';

class UserReviewTile extends StatelessWidget {
  final Review review;
  final String? placeName; // Tên địa điểm (optional)

  const UserReviewTile({super.key, required this.review, this.placeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Rating và thời gian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingStars(rating: review.rating, size: 16),
                Text(
                  _formatDate(review.createdAt),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Tên địa điểm (nếu có)
            if (placeName != null) ...[
              Text(
                placeName!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Nội dung review
            Text(
              review.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Footer: Thông tin bổ sung
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Số ảnh đính kèm
                if (review.photos.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${review.photos.length} ảnh',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                // Nút "Xem chi tiết" hoặc "Chỉnh sửa"
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to edit review hoặc place detail
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tính năng chỉnh sửa review sẽ được thêm sau',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm format ngày tháng
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

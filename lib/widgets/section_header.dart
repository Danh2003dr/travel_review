// lib/widgets/section_header.dart
// ------------------------------------------------------
// 🧭 SECTION HEADER
// - Hiển thị tiêu đề của một khu vực nội dung (vd: Top địa điểm)
// - Có nút "Xem tất cả" (optional)
// ------------------------------------------------------

import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('Xem tất cả')),
      ],
    );
  }
}

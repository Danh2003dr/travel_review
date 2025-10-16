// lib/widgets/skeletons/place_skeleton.dart
// ------------------------------------------------------
// 🧱 PLACE SKELETON
// - Dạng khung placeholder khi đang tải dữ liệu
// ------------------------------------------------------

import 'package:flutter/material.dart';

class PlaceSkeleton extends StatelessWidget {
  const PlaceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      ),
    );
  }
}

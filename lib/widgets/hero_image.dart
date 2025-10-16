// lib/widgets/hero_image.dart
// ------------------------------------------------------
// 🖼️ HERO IMAGE
// - Hiển thị ảnh lớn trong SliverAppBar (PlaceDetailScreen)
// - Có overlay tối nhẹ để nổi bật tiêu đề
// ------------------------------------------------------

import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final String url;
  final String? heroTag;
  const HeroImage({super.key, required this.url, this.heroTag});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(url, fit: BoxFit.cover);

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        imageWidget,
        Container(color: Colors.black.withOpacity(0.25)),
      ],
    );
  }
}

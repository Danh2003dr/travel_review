// lib/widgets/safe_network_image.dart
// ------------------------------------------------------
// 🖼️ SAFE NETWORK IMAGE - Xử lý lỗi network images
// - Fallback image khi network lỗi
// - Loading placeholder
// - Consistent error handling
// ------------------------------------------------------

import 'package:flutter/material.dart';

class SafeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[200],
            borderRadius: borderRadius,
          ),
          child:
              placeholder ??
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[300],
            borderRadius: borderRadius,
          ),
          child:
              errorWidget ??
              Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: (width != null && height != null)
                      ? (width! < height! ? width! * 0.4 : height! * 0.4)
                      : 40,
                  color: Colors.grey[600],
                ),
              ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}

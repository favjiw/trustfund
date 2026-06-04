import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Rounded network image with graceful loading and error states.
class NetworkImageBox extends StatelessWidget {
  final String url;
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const NetworkImageBox({
    super.key,
    required this.url,
    required this.height,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        width: width ?? double.infinity,
        height: height,
        fit: BoxFit.cover,
        // A static placeholder is used instead of a CircularProgressIndicator:
        // Material progress indicators can trigger a Flutter semantics
        // assertion (`!semantics.parentDataDirty`) during the semantics flush.
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder(icon: Icons.image_outlined);
        },
        errorBuilder: (context, error, stackTrace) =>
            _placeholder(icon: Icons.image_not_supported_outlined),
      ),
    );
  }

  Widget _placeholder({required IconData icon}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(icon, color: AppColors.iconMuted),
      ),
    );
  }
}

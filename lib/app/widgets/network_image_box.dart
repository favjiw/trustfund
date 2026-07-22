import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/network/api_constants.dart';
import '../core/theme/app_colors.dart';

/// Rounded image box with graceful loading and error states.
///
/// Handles three URL shapes the backend has used over time:
/// - absolute URLs (`http(s)://…`) via [Image.network],
/// - inline base64 data URIs (`data:image/…;base64,…`) via [Image.memory],
/// - server-relative paths (`/uploads/…`), resolved against
///   [ApiConstants.baseUrl] before loading.
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
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (url.startsWith('data:')) {
      final bytes = _decodeDataUri(url);
      if (bytes == null) {
        return _placeholder(icon: Icons.image_not_supported_outlined);
      }
      return Image.memory(
        bytes,
        width: width ?? double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _placeholder(icon: Icons.image_not_supported_outlined),
      );
    }

    return Image.network(
      _resolveUrl(url),
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
    );
  }

  /// Resolves server-relative paths (e.g. `/uploads/…`) against the API
  /// base URL; absolute URLs pass through unchanged.
  String _resolveUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return '${ApiConstants.baseUrl}$url';
    return '${ApiConstants.baseUrl}/$url';
  }

  /// Decodes a `data:` URI into raw bytes, returning `null` when the payload
  /// is malformed.
  Uint8List? _decodeDataUri(String uri) {
    try {
      return UriData.parse(uri).contentAsBytes();
    } catch (_) {
      return null;
    }
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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A service to handle image display across different platforms
class PlatformImageService {
  /// Create a widget to display an image from different sources
  /// (file, memory, network) in a cross-platform way
  static Widget getImage({
    required dynamic imageSource,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    if (kIsWeb) {
      // On web, we need to use Uint8List with MemoryImage
      if (imageSource is Uint8List) {
        return Image.memory(
          imageSource,
          fit: fit,
          width: width,
          height: height,
        );
      } else if (imageSource is File) {
        // Web doesn't support File directly, so we should have converted it to Uint8List already
        throw UnsupportedError(
            'File objects should be converted to Uint8List for web');
      } else if (imageSource is String && Uri.parse(imageSource).isAbsolute) {
        // For network images (URLs)
        return Image.network(
          imageSource,
          fit: fit,
          width: width,
          height: height,
        );
      }
    } else {
      // On mobile platforms, we can use all image types
      if (imageSource is File) {
        return Image.file(
          imageSource,
          fit: fit,
          width: width,
          height: height,
        );
      } else if (imageSource is Uint8List) {
        return Image.memory(
          imageSource,
          fit: fit,
          width: width,
          height: height,
        );
      } else if (imageSource is String && Uri.parse(imageSource).isAbsolute) {
        return Image.network(
          imageSource,
          fit: fit,
          width: width,
          height: height,
        );
      }
    }

    // Fallback for unsupported or null cases
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}

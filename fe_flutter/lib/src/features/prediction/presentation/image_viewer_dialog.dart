import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerDialog extends StatelessWidget {
  final dynamic imageSource; // Can be File, Uint8List or String (url)
  final String? title;

  const ImageViewerDialog({
    Key? key,
    required this.imageSource,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  top:
                      title == null ? const Radius.circular(12.0) : Radius.zero,
                  bottom: const Radius.circular(12.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top:
                      title == null ? const Radius.circular(12.0) : Radius.zero,
                  bottom: const Radius.circular(12.0),
                ),
                child: PhotoView(
                  imageProvider: _getImageProvider(),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.5,
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (kIsWeb) {
      if (imageSource is Uint8List) {
        return MemoryImage(imageSource as Uint8List);
      } else if (imageSource is String && Uri.parse(imageSource).isAbsolute) {
        return NetworkImage(imageSource as String);
      } else if (imageSource is File) {
        // This shouldn't happen on web, but just in case
        throw UnsupportedError('File objects not supported on web');
      }
    } else {
      if (imageSource is File) {
        return FileImage(imageSource as File);
      } else if (imageSource is Uint8List) {
        return MemoryImage(imageSource as Uint8List);
      } else if (imageSource is String && Uri.parse(imageSource).isAbsolute) {
        return NetworkImage(imageSource as String);
      }
    }
    throw ArgumentError('Unsupported image source type');
  }
}

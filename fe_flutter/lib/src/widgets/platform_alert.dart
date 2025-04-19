import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAlert {
  static void showWebCameraNotSupportedDialog(BuildContext context) {
    if (!kIsWeb) return; // Only show on web platforms

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Access'),
        content: const Text(
          'Direct camera access might not be fully supported in web browsers. '
          'Please use the "Select Image" button to upload an image from your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

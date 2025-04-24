import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/services/image_picker_service.dart';
import '../../../features/prediction/presentation/prediction_screen.dart';

class PatientImageViewerDialog extends StatelessWidget {
  final Uint8List imageSource;
  final String title;

  const PatientImageViewerDialog({
    super.key,
    required this.imageSource,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(title),
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.memory(
                  imageSource,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _navigateToPredictionScreen(context),
              icon: const Icon(Icons.analytics),
              label: const Text('Analyse this image'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPredictionScreen(BuildContext context) {
    // Create ImageResult from the image bytes
    final imageResult = ImageResult(
      bytes: imageSource,
      name: title,
      mimeType: 'image/jpeg', // Assuming JPEG for simplicity
    );

    // Close the dialog
    Navigator.of(context).pop();

    // Navigate to prediction screen with the image
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PredictionScreen(initialImage: imageResult),
      ),
    );
  }
}

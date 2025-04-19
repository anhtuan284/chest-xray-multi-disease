import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/models/prediction_models.dart';
import '../../../core/services/image_picker_service.dart';
import '../../../core/services/platform_image_service.dart';
import '../../../core/services/prediction_service.dart';
import 'image_viewer_dialog.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final PredictionService _predictionService = PredictionService();

  ImageResult? _selectedImageResult;
  PredictionModel _selectedModel = PredictionModel.yolo;
  bool _isLoading = false;
  String? _errorMessage;

  // YOLO result is a single image
  Uint8List? _yoloResult;

  // DenseNet result is a list of images
  List<Uint8List>? _densenetResults;

  // Information about models
  final Map<PredictionModel, String> _modelDescriptions = {
    PredictionModel.yolo: 'YOLO is used for object detection in chest X-rays, '
        'identifying and highlighting potential abnormalities like nodules, '
        'infiltrations, and effusions.',
    PredictionModel.denseNet121: 'DenseNet121 classifies chest X-rays into '
        'multiple disease categories, providing heatmap visualizations that '
        'highlight areas contributing to the diagnosis.'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest X-Ray Analysis'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'About this tool',
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use different layouts for different screen sizes
          if (constraints.maxWidth > 900) {
            // Wide layout (desktop/tablet landscape)
            return _buildWideLayout();
          } else {
            // Narrow layout (mobile/tablet portrait)
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  // Wide layout for desktop/tablet landscape
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: Input section
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildImageSelector(),
                const SizedBox(height: 24.0),
                _buildModelSelector(),
                const SizedBox(height: 24.0),
                _buildPredictButton(),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (_errorMessage != null) _buildErrorMessage(),
                const SizedBox(height: 16.0),
                _buildDisclaimerCard(),
              ],
            ),
          ),
        ),

        // Right column: Results section
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_yoloResult != null || _densenetResults != null)
                  _buildResultsSection()
                else
                  _buildNoResultsPlaceholder(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Narrow layout for mobile/tablet portrait
  Widget _buildNarrowLayout() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildImageSelector(),
        const SizedBox(height: 24.0),
        _buildModelSelector(),
        const SizedBox(height: 24.0),
        _buildPredictButton(),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_errorMessage != null) _buildErrorMessage(),
        const SizedBox(height: 16.0),
        if (_yoloResult != null || _densenetResults != null)
          _buildResultsSection()
        else
          _buildNoResultsPlaceholder(),
        const SizedBox(height: 16.0),
        _buildDisclaimerCard(),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Card(
      color: Colors.red.shade50,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.image_search,
                    size: 24, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Upload X-Ray Image',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_selectedImageResult != null && _selectedImageResult!.hasImage)
              Center(
                child: GestureDetector(
                  onTap: () => _showImageViewer(_selectedImageResult!.bytes!),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: PlatformImageService.getImage(
                            imageSource: _selectedImageResult!.bytes!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          right: 8.0,
                          bottom: 8.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 16,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white, size: 20),
                              onPressed: () => _showImageViewer(
                                  _selectedImageResult!.bytes!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Center(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8.0),
                  padding: const EdgeInsets.all(6.0),
                  color: Colors.grey.shade400,
                  strokeWidth: 2,
                  dashPattern: const [6, 3],
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select an X-Ray image',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: Text(kIsWeb ? 'Upload Image' : 'Gallery'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _pickImageFromGallery,
                  ),
                ),
                if (!kIsWeb) ...[
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _pickImageFromCamera,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelector() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.model_training,
                    size: 24, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Select Model',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<PredictionModel>(
              value: _selectedModel,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: PredictionModel.values.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(
                      model == PredictionModel.yolo ? 'YOLO' : 'DenseNet121'),
                );
              }).toList(),
              onChanged: (PredictionModel? value) {
                if (value != null) {
                  setState(() {
                    _selectedModel = value;
                    // Reset results when model changes
                    _yoloResult = null;
                    _densenetResults = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Model description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedModel == PredictionModel.yolo
                        ? 'YOLO Model'
                        : 'DenseNet121 Model',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _modelDescriptions[_selectedModel] ?? '',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return ElevatedButton(
      onPressed: _selectedImageResult == null || _isLoading ? null : _predict,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade700,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isLoading ? Icons.hourglass_top : Icons.medical_services,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _isLoading ? 'Processing...' : 'Analyze X-Ray',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsPlaceholder() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Results Yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select an image and a model, then click "Analyze X-Ray" to see results',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final bool isYoloResult = _yoloResult != null;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, size: 24, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Analysis Results',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            if (isYoloResult) _buildYoloResult() else _buildDenseNetResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildYoloResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOLO Detection Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'The image shows areas where potential abnormalities were detected.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showMemoryImageViewer(_yoloResult!),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: PlatformImageService.getImage(
                    imageSource: _yoloResult!,
                    fit: BoxFit.contain,
                    height: 300,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 16,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.fullscreen,
                          color: Colors.white, size: 20),
                      onPressed: () => _showMemoryImageViewer(_yoloResult!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap on the image to view it in full screen mode',
          style: TextStyle(
              fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDenseNetResults() {
    if (_densenetResults == null || _densenetResults!.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DenseNet121 Analysis Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${_densenetResults!.length} images showing heatmaps of different disease patterns',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1,
          ),
          itemCount: _densenetResults!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showMemoryImageViewer(
                _densenetResults![index],
                title: 'Result Image ${index + 1}',
              ),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: PlatformImageService.getImage(
                        imageSource: _densenetResults![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 12,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.fullscreen,
                              color: Colors.white, size: 14),
                          onPressed: () => _showMemoryImageViewer(
                            _densenetResults![index],
                            title: 'Result Image ${index + 1}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap on any image to view it in full screen mode',
          style: TextStyle(
              fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDisclaimerCard() {
    return Card(
      elevation: 1.0,
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.amber.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.amber.shade800),
                const SizedBox(width: 8),
                Text(
                  'Important Disclaimer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'This tool is for experimental and educational purposes only. '
              'The AI models used are still under development and their results should not be '
              'used as a substitute for professional medical diagnosis. '
              'Always consult with qualified healthcare professionals for medical advice.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final imageResult = await _imagePickerService.pickImageFromGallery();
    _handleSelectedImage(imageResult);
  }

  Future<void> _pickImageFromCamera() async {
    final imageResult = await _imagePickerService.pickImageFromCamera();
    _handleSelectedImage(imageResult);
  }

  void _handleSelectedImage(ImageResult? imageResult) {
    if (imageResult != null) {
      setState(() {
        _selectedImageResult = imageResult;
        // Reset results when image changes
        _yoloResult = null;
        _densenetResults = null;
        _errorMessage = null;
      });
    }
  }

  Future<void> _predict() async {
    if (_selectedImageResult == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _yoloResult = null;
      _densenetResults = null;
    });

    try {
      if (_selectedModel == PredictionModel.yolo) {
        final result =
            await _predictionService.predictWithYolo(_selectedImageResult!);
        setState(() {
          _yoloResult = result;
        });
      } else {
        final results =
            await _predictionService.predictWithDenseNet(_selectedImageResult!);
        setState(() {
          _densenetResults = results;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageViewer(Uint8List imageBytes, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => ImageViewerDialog(
        imageSource: imageBytes,
        title: title ?? 'X-Ray Image',
      ),
    );
  }

  void _showMemoryImageViewer(Uint8List imageBytes, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => ImageViewerDialog(
        imageSource: imageBytes,
        title: title ?? 'X-Ray Analysis',
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.medical_services, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('About this Tool'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This application uses artificial intelligence to analyze chest X-ray images '
                'and detect potential abnormalities.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Available Models:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildModelInfoItem(
                'YOLO',
                'Object detection model that identifies and highlights potential '
                    'abnormalities in chest X-rays. It draws bounding boxes around '
                    'detected features.',
              ),
              const SizedBox(height: 8),
              _buildModelInfoItem(
                'DenseNet121',
                'Classification model that can identify multiple diseases from '
                    'chest X-rays. It provides heatmaps showing which areas of the '
                    'image contributed most to the diagnosis.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: const Text(
                  'This tool is experimental and should not replace professional '
                  'medical diagnosis.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildModelInfoItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

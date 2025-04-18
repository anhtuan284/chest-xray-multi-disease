import 'dart:io';

import 'package:flutter/material.dart';

/// A reusable widget to display images from various sources
/// with zoom and pan capabilities
class ImageViewWidget extends StatefulWidget {
  /// Local file path to image
  final String? localFilePath;
  
  /// URL to remote image
  final String? url;
  
  /// Maximum scale factor for zooming
  final double maxScale;
  
  /// Minimum scale factor for zooming
  final double minScale;

  const ImageViewWidget({
    super.key,
    this.localFilePath,
    this.url,
    this.maxScale = 4.0,
    this.minScale = 0.8,
  }) : assert(localFilePath != null || url != null, 
         'Either localFilePath or url must be provided');

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;
  late final AnimationController _animationController;
  Animation<Matrix4>? _animation;
  
  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animationController.addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });
  }
  
  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // Handle double tap to zoom in/out
  void _handleDoubleTap() {
    if (_doubleTapDetails == null) return;
    
    if (_transformationController.value != Matrix4.identity()) {
      // If zoomed in, reset to original size
      _animateResetInitialize();
    } else {
      // If at original size, zoom in to double-tap location
      final position = _doubleTapDetails!.localPosition;
      const zoomFactor = 2.5; // How much to zoom in
      
      // Create a zooming transformation matrix centered on tap position
      final endMatrix = Matrix4.identity()
        ..translate(position.dx, position.dy)
        ..scale(zoomFactor)
        ..translate(-position.dx, -position.dy);
        
      _animateTransform(endMatrix);
    }
  }
  
  // Animate to the specified transformation
  void _animateTransform(Matrix4 endTransformation) {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endTransformation,
    ).animate(CurveTween(curve: Curves.easeOutCubic).animate(_animationController));
    
    _animationController.forward(from: 0);
  }
  
  // Reset the transformation with animation
  void _animateResetInitialize() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurveTween(curve: Curves.easeOutCubic).animate(_animationController));
    
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _doubleTapDetails = details;
      },
      onDoubleTap: _handleDoubleTap,
      child: ClipRect(
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          boundaryMargin: const EdgeInsets.all(20.0),
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.localFilePath != null) {
      return Image.file(
        File(widget.localFilePath!),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget('Failed to load image file');
        },
      );
    } else if (widget.url != null) {
      return Image.network(
        widget.url!,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget('Failed to load image from network');
        },
      );
    }
    return const SizedBox();
  }
  
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
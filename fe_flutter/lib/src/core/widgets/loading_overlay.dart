import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loading_animation.dart';

/// A service for displaying a loading overlay on top of the current UI.
class LoadingOverlay {
  BuildContext _context;
  final String? title;
  final Widget? status;
  final bool cancelable;
  bool _isShowing = false;
  
  /// Whether the loading overlay is currently showing
  bool get isShowing => _isShowing;

  /// Hides the currently shown loading overlay
  void hide() {
    if (!_isShowing) return;
    
    // Must pop from root navigator otherwise FullScreenLoading will remain on top
    try {
      Navigator.of(_context, rootNavigator: true).pop();
      _isShowing = false;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        // Context may not be available at time of hiding
        print(
            'LoadingOverlay.hide error: $error\nStack trace:\n$stackTrace');
      }
    }
  }

  /// Shows the loading overlay
  void show() {
    if (_isShowing) return;
    
    _isShowing = true;
    showDialog(
      builder: (ctx) {
        _context = ctx; // Update context to the most recent one
        return FullScreenLoader(
            title: title, onCancel: cancelable ? hide : null, status: status);
      },
      context: _context,
      barrierDismissible: false,
    ).catchError((error) {
      _isShowing = false;
      if (kDebugMode) {
        print('LoadingOverlay.show error: $error');
      }
    });
  }

  /// Shows the loading overlay during the execution of a future
  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context, this.title,
      {required this.cancelable, this.status});

  /// Create a LoadingOverlay for the given BuildContext
  factory LoadingOverlay.of(BuildContext context,
      {String? title, bool cancelable = false, Widget? status}) {
    return LoadingOverlay._create(context, title,
        cancelable: cancelable, status: status);
  }
}

/// A full-screen loading widget with customizable appearance
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader(
      {super.key, this.title, this.onCancel, this.status, this.statusText});

  final String? title;
  final Widget? status;
  final ValueNotifier<String?>? statusText;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    const foregroundColor = Colors.white;
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button from dismissing
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const LottieLoadingAnimation(
                  size: 150.0,
                  color: Colors.white,
                ),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(title!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.apply(color: foregroundColor)),
                  ),
                if (statusText != null)
                  ValueListenableBuilder<String?>(
                      valueListenable: statusText!,
                      builder: (context, value, _) {
                        return Text(value ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.apply(color: foregroundColor));
                      }),
                if (status != null) ...[
                  const SizedBox(height: 10),
                  status!
                ],
                if (onCancel != null) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: IconButton(
                        onPressed: onCancel,
                        iconSize: 32,
                        icon: const Icon(Icons.cancel,
                            color: foregroundColor)),
                  ),
                ]
              ],
            ))),
      ),
    );
  }
}
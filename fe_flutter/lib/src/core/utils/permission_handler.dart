import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_logger.dart';

class AppPermissionHandler {
  static final _log = AppLogger.getLogger('AppPermissionHandler');
  static Completer<bool>? _activeRequest;

  /// Request microphone permission with proper coordination
  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    if (_activeRequest != null) {
      return await _activeRequest!.future;
    }
    _activeRequest = Completer<bool>();
    
    try {
      // Check current permission status
      var status = await Permission.microphone.status;
      _log.warning('Initial microphone permission status: ${status.toString()}');
      
      if (status.isGranted) {
        _activeRequest!.complete(true);
        return true;
      }

      // Always try to request permission first
      status = await Permission.microphone.request();
      _log.warning('After request status: ${status.toString()}');
      
      // On iOS, wait for permission to register
      if (Platform.isIOS) {
        await Future.delayed(const Duration(milliseconds: 800));
        status = await Permission.microphone.status;
        _log.warning('After delay status: ${status.toString()}');
        
        // If granted after delay, return success
        if (status.isGranted) {
          _activeRequest!.complete(true);
          return true;
        }
      }
      
      // Show settings dialog if not granted (covers both denied and permanently denied cases)
      if (!status.isGranted && context.mounted) {
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Prevent dismissing by tapping outside
          builder: (context) => AlertDialog(
            title: const Text('Microphone Permission Required'),
            content: const Text(
              'Microphone access is needed for recording audio notes. '
              'Please enable it in app settings.'
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        
        if (result == true) {
          // User opened settings, let's check again after a delay
          await Future.delayed(const Duration(seconds: 1));
          status = await Permission.microphone.status;
          _log.warning('Status after settings: ${status.toString()}');
        }
      }
      
      _activeRequest!.complete(status.isGranted);
      return status.isGranted;
    } catch (e) {
      _log.severe('Error requesting microphone permission', e);
      _activeRequest!.complete(false);
      return false;
    } finally {
      _activeRequest = null;
    }
  }
}
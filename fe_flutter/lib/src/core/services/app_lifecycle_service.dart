import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lifecycle_service.g.dart';

/// Service that provides access to app lifecycle state
@Riverpod(keepAlive: true)
class AppLifecycleService extends _$AppLifecycleService {
  @override
  AppLifecycleState build() {
    // Initial state when app starts
    return AppLifecycleState.resumed;
  }

  /// Update the current lifecycle state
  void updateLifecycleState(AppLifecycleState newState) {
    // Only update if state actually changed
    if (state != newState) {
      // Log the lifecycle change
      state = newState;
    }
  }

  /// Check if the app is in the foreground (resumed)
  bool get isAppForeground => state == AppLifecycleState.resumed;

  /// Check if the app is in the background (paused or inactive)
  bool get isAppBackground =>
      state == AppLifecycleState.paused || state == AppLifecycleState.inactive;

  /// Check if the app is detached
  bool get isAppDetached => state == AppLifecycleState.detached;
}

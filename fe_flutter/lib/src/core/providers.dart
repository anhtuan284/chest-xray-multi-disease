import 'package:fe_flutter/src/core/data/models/user_setting.dart';
import 'package:fe_flutter/src/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/chat/data/chat_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/repositories.dart';
import 'services/chat_api_service.dart';
import 'services/documents_api_service.dart';
import 'services/services.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  final repository = ref.watch(userSettingRepositoryProvider.notifier);
  final userSettings = ref.watch(userSettingRepositoryProvider);
  return ThemeNotifier(repository,
      isDarkMode: userSettings.isDarkMode ?? false);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepository(authService);
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

//Tutorial Repository Provider
final tutorialRepositoryProvider = Provider<TutorialRepository>((ref) {
  final tutorialService = ref.read(tutorialServiceProvider);
  return TutorialRepository(tutorialService);
});

//Tutorial Service Provider
final tutorialServiceProvider = Provider<TutorialService>((ref) {
  // replace with FakeTutorialService() for testing.
  return FakeTutorialService();
});

// User Setting Repository Provider
final userSettingRepositoryProvider =
    StateNotifierProvider<UserSettingRepository, UserSetting>((ref) {
  final userSettingService = ref.read(userSettingServiceProvider);
  return UserSettingRepository(userSettingService);
});

// User Setting Service Provider
final userSettingServiceProvider = Provider<UserSettingService>((ref) {
  return UserSettingService();
});

// Connectivity Service Provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

// Sync Service Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

// API Service Providers
final chatAPIProvider = Provider<ChatAPIService>((ref) {
  return ChatAPIService();
});

final documentsAPIProvider = Provider<DocumentsAPIService>((ref) {
  return DocumentsAPIService();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fe_flutter/src/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceService {
  final _log = AppLogger.getLogger('DeviceService');
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  PackageInfo? _packageInfo;

  /// Initialize the service by loading package information
  Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  /// Get basic device information as a map
  Future<String> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return '${webInfo.userAgent} on ${webInfo.platform}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release}, ${androidInfo.model} (${androidInfo.manufacturer})';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS ${iosInfo.systemVersion}, ${iosInfo.name} ${iosInfo.model}';
      } else if (Platform.isMacOS) {
        final macOsInfo = await _deviceInfo.macOsInfo;
        return 'macOS ${macOsInfo.osRelease} (${macOsInfo.model})';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return 'Windows ${windowsInfo.productName} (${windowsInfo.computerName})';
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        return 'Linux ${linuxInfo.prettyName}';
      } else {
        return 'Unknown platform';
      }
    } catch (e) {
      _log.warning('Failed to get device info: $e');
      return 'Unknown device';
    }
  }

  /// Get the app version
  Future<String> getAppVersion() async {
    if (_packageInfo == null) {
      await initialize();
    }
    return _packageInfo?.version ?? 'unknown';
  }
}

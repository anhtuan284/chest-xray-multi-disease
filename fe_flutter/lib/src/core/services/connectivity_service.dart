import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/app_logger.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _log = AppLogger.getLogger('ConnectivityService');

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      _log.warning('Error checking connectivity: $e');
      return false;
    }
  }

  Stream<bool> onConnectivityChanged() {
    return _connectivity.onConnectivityChanged
        .map((event) => event != ConnectivityResult.none);
  }
}

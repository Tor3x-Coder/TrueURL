import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    // connectivity_plus v6+ returns List<ConnectivityResult>
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }
}
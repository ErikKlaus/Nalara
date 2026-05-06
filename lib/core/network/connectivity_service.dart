import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    // In connectivity_plus >= 6.0.0 checkConnectivity returns List<ConnectivityResult>
    return !results.contains(ConnectivityResult.none) ||
        results.length > 1 ||
        (results.length == 1 && results.first != ConnectivityResult.none);
  }
}

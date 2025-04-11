import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mejoralo_cdt/common/infrastructure/interfaces/connectivity/connectivity.dart';

class ConnectivityImpl implements ConnectivityInterface {
  final Connectivity connectivity = Connectivity();
  StreamController<bool>? _connectionStatusController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  Stream<bool> get isConnected {
    _initStreamIfNeeded();
    return _connectionStatusController!.stream;
  }

  void _initStreamIfNeeded() {
    _connectionStatusController ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
  }

  void _startListening() {
    _subscription ??= connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final isConnected = results.any(
        (result) =>
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi,
      );
      _connectionStatusController?.add(isConnected);
    });
  }

  void _stopListening() {
    if (_connectionStatusController?.hasListener == false) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _connectionStatusController?.close();
    _subscription = null;
    _connectionStatusController = null;
  }

  @override
  Future<bool> check() async {
    final results = await connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  }
}

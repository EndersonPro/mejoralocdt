abstract class ConnectivityInterface {
  Stream<bool> get isConnected;
  Future<bool> check();
  void dispose();
}

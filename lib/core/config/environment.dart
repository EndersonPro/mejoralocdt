abstract class EnvironmentConfigInterface {
  String get baseUrl;
}

class EnvironmentAppConfig implements EnvironmentConfigInterface {
  late final String _baseUrl;

  EnvironmentAppConfig() {
    _initEnvironmentVariables();
    _validateEnvironmentVariables();
  }

  _initEnvironmentVariables() {
    _baseUrl = const String.fromEnvironment('API_URL');
  }

  _validateEnvironmentVariables() {
    if (_baseUrl.isEmpty) {
      throw Exception('API_URL is not set');
    }
  }

  @override
  String get baseUrl => _baseUrl;
}

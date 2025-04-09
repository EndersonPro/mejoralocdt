import 'package:dio/dio.dart';
import 'package:mejoralo_cdt/core/core.dart';

import '../../interfaces/http_client/http_client.dart';

class HttpClientImpl implements HttpClientInterface {
  late final Dio _httpClient;

  HttpClientImpl({required EnvironmentConfigInterface environmentConfig}) {
    _httpClient = Dio(BaseOptions(baseUrl: environmentConfig.baseUrl));
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _httpClient.get(
      path,
      queryParameters: queryParameters,
    );

    return HttpResponse(statusCode: response.statusCode, body: response.data);
  }
}

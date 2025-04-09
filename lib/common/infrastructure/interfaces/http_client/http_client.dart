import 'dart:async';

enum FetchApiError { notFound, serverError, unknown }

class FetchApiException implements Exception {
  final FetchApiError error;
  final String message;

  FetchApiException(this.error, this.message);

  @override
  String toString() => 'FetchApiException: $message';
}

class HttpResponse<T> {
  int? statusCode;
  T? body;

  HttpResponse({this.statusCode, this.body});
}

abstract class HttpClientInterface {
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
}

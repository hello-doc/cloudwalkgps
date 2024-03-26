import 'package:dio/dio.dart';

class RestClientException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;
  final RequestOptions? requestOptions;
  final StackTrace? stackTrace;

  RestClientException({
    this.message = '',
    this.statusCode,
    this.error,
    this.requestOptions,
    this.stackTrace,
  });
}

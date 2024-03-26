import 'dart:async';

import 'package:cloudwalk_gps/data/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../enums/type_request_enum.dart';
import '../../errors/rest_client_exception.dart';
import '../../utils/custom_logger.dart';
import 'interceptors/interceptor_log.dart';
import 'rest_client_service_interface.dart';

class RestClientService implements IRestClientService {
  final Dio _dio = Dio();

  RestClientService() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: Headers.jsonContentType,
    );
  }

  @override
  Future<ResponseModel> request(
      {required String url,
      TypeRequest typeRequest = TypeRequest.get,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      dynamic cancelToken,
      void Function(int p1, int p2)? updateProgress,
      void Function(int p1, int p2)? downloadProgress,
      Duration? durationCache}) async {
    final defaultHeaders = headers ?? {};

    _dio.interceptors.clear();

    try {
      _dio.interceptors.add(CustomLogInterceptor(logPrint: LoggerApp.warning, curlRequestOnResponse: kDebugMode));

      final Response response = await _dio.request(
        url,
        data: data,
        options: Options(headers: defaultHeaders, method: typeRequest.name.toUpperCase()),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: updateProgress,
        onReceiveProgress: downloadProgress,
      );

      return ResponseModel(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e, s) {
      final int? statusCode = e.response?.statusCode;

      return ResponseModel(
        error: RestClientException(
          statusCode: statusCode,
          message: e.response?.data ?? e,
          error: e.error,
          requestOptions: e.requestOptions,
          stackTrace: s,
        ),
        statusCode: statusCode,
      );
    } catch (e, s) {
      return ResponseModel(
        error: RestClientException(
          statusCode: 500,
          message: 'Invalid on request',
          error: 'Error on request $typeRequest da url: $url, error: $e',
          stackTrace: s,
        ),
      );
    }
  }
}

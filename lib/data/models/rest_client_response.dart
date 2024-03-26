class RestClientResponse {
  final Map<String, dynamic>? data;
  final int? statusCode;
  final String? statusMessage;

  RestClientResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  @override
  String toString() => 'RestClientResponse(data: $data, statusCode: $statusCode, statusMessage: $statusMessage)';
}

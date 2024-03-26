import '../../../data/models/response_model.dart';
import '../../enums/type_request_enum.dart';

abstract class IRestClientService {
  Future<ResponseModel> request(
      {required String url,
      TypeRequest typeRequest,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      dynamic cancelToken,
      void Function(int p1, int p2)? updateProgress,
      void Function(int p1, int p2)? downloadProgress,
      Duration? durationCache});
}

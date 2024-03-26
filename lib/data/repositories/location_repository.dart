import 'package:cloudwalk_gps/data/models/response_model.dart';
import 'package:cloudwalk_gps/data/repositories/location_repository_interface.dart';
import 'package:cloudwalk_gps/shared/services/rest_client/rest_client_service_interface.dart';

import '../models/geo_position_model.dart';

class LocationRepository implements ILocationRepository {
  final IRestClientService _clientService;

  LocationRepository(this._clientService);

  @override
  Future<ResponseModel<GeoPositionModel, Exception>> getLocationByIP() async {
    try {
      final response = await _clientService.request(url: 'http://ip-api.com/json');

      if (response.isSuccess) {
        return ResponseModel(
          data: GeoPositionModel(
            latitude: (response.data?['lat'] ?? 0),
            longitude: (response.data?['lon'] ?? 0),
          ),
        );
      } else {
        return ResponseModel(error: Exception('Unexpeted error'));
      }
    } catch (e) {
      return ResponseModel(error: Exception('Error on get current position by ip'));
    }
  }
}

import 'package:cloudwalk_gps/data/models/geo_position_model.dart';
import 'package:cloudwalk_gps/data/models/response_model.dart';

abstract class ILocationRepository {
  Future<ResponseModel<GeoPositionModel, Exception>> getLocationByIP();
}

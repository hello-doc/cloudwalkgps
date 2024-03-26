import 'package:cloudwalk_gps/shared/enums/location_permission_enum.dart';

import '../../../data/models/geo_position_model.dart';

abstract class ILocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermissionEnum> requestPermission();
  Future<GeoPositionModel> getCurrentPosition();
  Future<GeoPositionModel?> getLastPosition();
}

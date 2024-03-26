import 'package:cloudwalk_gps/data/models/geo_position_model.dart';
import 'package:cloudwalk_gps/shared/enums/location_permission_enum.dart';
import 'package:cloudwalk_gps/shared/services/location/location_service_interface.dart';
import 'package:geolocator/geolocator.dart';

class LocationService implements ILocationService {
  @override
  Future<GeoPositionModel> getCurrentPosition() {
    return Geolocator.getCurrentPosition()
        .then((value) => GeoPositionModel(latitude: value.latitude, longitude: value.longitude));
  }

  @override
  Future<GeoPositionModel?> getLastPosition() {
    return Geolocator.getLastKnownPosition()
        .then((value) => value == null ? null : GeoPositionModel(latitude: value.latitude, longitude: value.longitude));
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermissionEnum> requestPermission() {
    return Geolocator.requestPermission().then((value) {
      switch (value) {
        case LocationPermission.always:
          return LocationPermissionEnum.always;
        case LocationPermission.denied:
          return LocationPermissionEnum.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionEnum.deniedForever;
        case LocationPermission.whileInUse:
          return LocationPermissionEnum.whileInUse;
        case LocationPermission.unableToDetermine:
          return LocationPermissionEnum.unableToDetermine;
      }
    });
  }
}

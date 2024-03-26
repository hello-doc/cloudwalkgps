import 'dart:async';

import 'package:cloudwalk_gps/data/models/geo_position_model.dart';
import 'package:cloudwalk_gps/data/repositories/location_repository_interface.dart';
import 'package:cloudwalk_gps/shared/enums/location_permission_enum.dart';
import 'package:cloudwalk_gps/shared/services/location/location_service_interface.dart';
import 'package:cloudwalk_gps/shared/stores/connectivity_store.dart';
import 'package:cloudwalk_gps/shared/utils/custom_logger.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../shared/enums/status_type_enum.dart';

class HomeController extends GetxController {
  final ILocationRepository _locationRepository;
  final ConnectivityStore _connectivityStore;
  final ILocationService _locationService;

  HomeController(this._locationRepository, this._connectivityStore, this._locationService);

  // * Controllers
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  final Completer<GoogleMapController> mapsController = Completer<GoogleMapController>();

  // * Observables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controls status of screen
  final Rx<StatusTypeEnum> _status = Rx<StatusTypeEnum>(StatusTypeEnum.idle);
  StatusTypeEnum get status => _status.value;

  /// Controls current position of user
  final Rx<GeoPositionModel> _position = Rx<GeoPositionModel>(GeoPositionModel(latitude: 0, longitude: 0));
  LatLng get latlong => LatLng(_position.value.latitude, _position.value.longitude);
  set position(GeoPositionModel value) => _position.value = value;

  /// Controls markers
  final RxSet<Marker> markers = RxSet<Marker>();

  // * Actions
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    getLocalizationUser();
    super.onInit();
  }

  /// Gets location of user
  Future<void> getLocalizationUser() async {
    try {
      _status.value = StatusTypeEnum.loading;

      markers.clear();

      final bool serviceEnabled = await _locationService.isLocationServiceEnabled();

      if (!serviceEnabled) return _getLocationUserByIp();

      final LocationPermissionEnum permission = await _locationService.requestPermission();

      if ([LocationPermissionEnum.denied, LocationPermissionEnum.deniedForever].contains(permission)) {
        return _getLocationUserByIp();
      }

      final currentPosition = await _locationService.getCurrentPosition();

      LoggerApp.debug('Current Position by GPS: (${currentPosition.latitude},${currentPosition.longitude})');

      _setMarker(currentPosition);
    } catch (e) {
      _status.value = StatusTypeEnum.error;
      LoggerApp.error('Error on get location of the user.');
    }
  }

  /// Gets location by ip
  Future<void> _getLocationUserByIp() async {
    if (!_connectivityStore.isConnected) {
      GeoPositionModel? lastPosition = await _locationService.getLastPosition();
      if (lastPosition != null) {
        _setMarker(lastPosition);
      } else {
        _status.value = StatusTypeEnum.error;
      }
      return;
    }

    final response = await _locationRepository.getLocationByIP();
    if (response.isSuccess) {
      LoggerApp.debug('Current Position by IP: (${response.data!.latitude},${response.data!.longitude})');
      _setMarker(response.data!);
    } else {
      _status.value = StatusTypeEnum.error;
    }
  }

  /// Updates position and markers on map
  Future<void> _setMarker(GeoPositionModel currentPosition) async {
    position = currentPosition;

    markers.add(
      Marker(
        markerId: const MarkerId('myLocation'),
        position: latlong,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    _status.value = StatusTypeEnum.success;

    final GoogleMapController maps = await mapsController.future;
    return maps.animateCamera(CameraUpdate.newLatLng(latlong));
  }
}

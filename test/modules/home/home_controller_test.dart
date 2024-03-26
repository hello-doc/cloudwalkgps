import 'package:cloudwalk_gps/data/models/geo_position_model.dart';
import 'package:cloudwalk_gps/data/models/response_model.dart';
import 'package:cloudwalk_gps/data/repositories/location_repository_interface.dart';
import 'package:cloudwalk_gps/modules/home/home_controller.dart';
import 'package:cloudwalk_gps/shared/enums/location_permission_enum.dart';
import 'package:cloudwalk_gps/shared/services/location/location_service_interface.dart';
import 'package:cloudwalk_gps/shared/stores/connectivity_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/class_mocks.dart';

void main() {
  late ConnectivityStore connectivityStore;
  late ILocationRepository locationRepository;
  late ILocationService locationService;
  late HomeController homeController;

  final GeoPositionModel mockPosition = GeoPositionModel(latitude: 20.12, longitude: 12.234);

  setUp(() {
    connectivityStore = MockConnectivityStore();
    locationRepository = MockILocationRepository();
    locationService = MockILocationService();
    homeController = HomeController(locationRepository, connectivityStore, locationService);
  });

  group('[Get location]', () {
    test('should return a current position by IP when GPS is disabled', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => locationService.isLocationServiceEnabled()).thenAnswer((v) async => false);
      when(() => locationRepository.getLocationByIP()).thenAnswer((v) async => ResponseModel(data: mockPosition));

      //Act
      await homeController.getLocalizationUser();

      //Assert
      expect(homeController.latlong.latitude == mockPosition.latitude, true);
      expect(homeController.markers.length, 1);
      expect(homeController.status.isSuccess, true);
      verify(() => locationRepository.getLocationByIP()).called(1);
    });

    test('should return a current position by IP when GPS is not allowed', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => locationService.isLocationServiceEnabled()).thenAnswer((v) async => true);
      when(() => locationService.requestPermission()).thenAnswer((v) async => LocationPermissionEnum.denied);
      when(() => locationRepository.getLocationByIP()).thenAnswer((v) async => ResponseModel(data: mockPosition));

      //Act
      await homeController.getLocalizationUser();

      //Assert
      expect(homeController.latlong.latitude == mockPosition.latitude, true);
      expect(homeController.markers.length, 1);
      expect(homeController.status.isSuccess, true);
      verify(() => locationRepository.getLocationByIP()).called(1);
    });

    test('should return a current position by GPS when GPS is allowed', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(true);
      when(() => locationService.isLocationServiceEnabled()).thenAnswer((v) async => true);
      when(() => locationService.requestPermission()).thenAnswer((v) async => LocationPermissionEnum.always);
      when(() => locationService.getCurrentPosition()).thenAnswer((v) async => mockPosition);
      when(() => locationRepository.getLocationByIP()).thenAnswer((v) async => ResponseModel(data: mockPosition));

      //Act
      await homeController.getLocalizationUser();

      //Assert
      expect(homeController.latlong.latitude == mockPosition.latitude, true);
      expect(homeController.markers.length, 1);
      expect(homeController.status.isSuccess, true);
      verifyNever(() => locationRepository.getLocationByIP());
    });

    test('should return a last position when has not internet and GPS is not allowed', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(false);
      when(() => locationService.isLocationServiceEnabled()).thenAnswer((v) async => true);
      when(() => locationService.requestPermission()).thenAnswer((v) async => LocationPermissionEnum.denied);
      when(() => locationService.getLastPosition()).thenAnswer((v) async => mockPosition);
      when(() => locationRepository.getLocationByIP()).thenAnswer((v) async => ResponseModel(data: mockPosition));

      //Act
      await homeController.getLocalizationUser();

      //Assert
      expect(homeController.latlong.latitude == mockPosition.latitude, true);
      expect(homeController.markers.length, 1);
      expect(homeController.status.isSuccess, true);
      verify(() => locationService.getLastPosition()).called(1);
      verifyNever(() => locationRepository.getLocationByIP());
    });

    test('should return a exception when has not internet and GPS disabled', () async {
      //Arrange
      when(() => connectivityStore.isConnected).thenReturn(false);
      when(() => locationService.isLocationServiceEnabled()).thenAnswer((v) async => true);
      when(() => locationService.requestPermission()).thenAnswer((v) async => LocationPermissionEnum.denied);
      when(() => locationService.getLastPosition()).thenAnswer((v) async => null);
      when(() => locationRepository.getLocationByIP()).thenAnswer((v) async => ResponseModel(data: mockPosition));

      //Act
      await homeController.getLocalizationUser();

      //Assert
      expect(homeController.latlong.latitude == 0, true);
      expect(homeController.markers.length, 0);
      expect(homeController.status.isError, true);
      verify(() => locationService.getLastPosition()).called(1);
      verifyNever(() => locationRepository.getLocationByIP());
    });
  });
}

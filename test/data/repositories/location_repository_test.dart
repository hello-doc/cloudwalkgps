import 'package:cloudwalk_gps/data/models/response_model.dart';
import 'package:cloudwalk_gps/data/repositories/location_repository.dart';
import 'package:cloudwalk_gps/data/repositories/location_repository_interface.dart';
import 'package:cloudwalk_gps/shared/errors/rest_client_exception.dart';
import 'package:cloudwalk_gps/shared/services/rest_client/rest_client_service_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/class_mocks.dart';

void main() {
  late IRestClientService restClientService;
  late ILocationRepository locationRepository;

  setUp(() {
    restClientService = MockIRestClient();
    locationRepository = LocationRepository(restClientService);
  });

  group('[Get location by IP]', () {
    test('should return a current position by ip', () async {
      //Arrange
      when(() => restClientService.request(url: any(named: 'url')))
          .thenAnswer((v) async => ResponseModel(data: {'lat': 20.12, 'lon': 12.234}));

      //Act
      final response = await locationRepository.getLocationByIP();

      //Assert
      expect(response.isSuccess, true);
      expect(response.data, isA<LatLng>());
    });

    test('should return a response with exception', () async {
      //Arrange
      when(() => restClientService.request(url: any(named: 'url'))).thenThrow(RestClientException());

      //Act
      final response = await locationRepository.getLocationByIP();

      //Assert
      expect(response.isError, true);
      expect(response.error, isA<Exception>());
    });
  });
}

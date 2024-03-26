import 'package:cloudwalk_gps/data/repositories/location_repository_interface.dart';
import 'package:cloudwalk_gps/shared/services/location/location_service_interface.dart';
import 'package:cloudwalk_gps/shared/services/rest_client/rest_client_service_interface.dart';
import 'package:cloudwalk_gps/shared/stores/connectivity_store.dart';
import 'package:mocktail/mocktail.dart';

class MockIRestClient extends Mock implements IRestClientService {}

class MockILocationService extends Mock implements ILocationService {}

class MockILocationRepository extends Mock implements ILocationRepository {}

class MockConnectivityStore extends Mock implements ConnectivityStore {}

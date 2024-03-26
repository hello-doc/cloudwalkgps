import 'package:cloudwalk_gps/data/repositories/location_repository.dart';
import 'package:cloudwalk_gps/data/repositories/location_repository_interface.dart';
import 'package:cloudwalk_gps/modules/home/home_controller.dart';
import 'package:cloudwalk_gps/shared/services/location/location_service.dart';
import 'package:cloudwalk_gps/shared/services/location/location_service_interface.dart';
import 'package:cloudwalk_gps/shared/services/rest_client/rest_client_service.dart';
import 'package:cloudwalk_gps/shared/services/rest_client/rest_client_service_interface.dart';
import 'package:cloudwalk_gps/shared/stores/connectivity_store.dart';
import 'package:get/get.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IRestClientService>(() => RestClientService());
    Get.lazyPut<ILocationService>(() => LocationService());
    Get.lazyPut<ILocationRepository>(() => LocationRepository(Get.find<IRestClientService>()));
    Get.lazyPut<ConnectivityStore>(() => ConnectivityStore());
    Get.lazyPut<HomeController>(() =>
        HomeController(Get.find<ILocationRepository>(), Get.find<ConnectivityStore>(), Get.find<ILocationService>()));
  }
}

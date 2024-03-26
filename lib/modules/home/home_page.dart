import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Maps'),
      ),
      body: Obx(
        () {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.latlong,
                  zoom: 14.4746,
                ),
                buildingsEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: false,
                compassEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController googleMapsController) =>
                    controller.mapsController.complete(googleMapsController),
                markers: controller.markers,
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Visibility(
                  visible: controller.status.isSuccess,
                  child: SafeArea(
                    top: false,
                    right: false,
                    left: false,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: controller.getLocalizationUser,
                      icon: const Icon(
                        Icons.location_searching_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'My Position',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.status.isError,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 120,
                          color: Colors.orange.shade400,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Error on get current position, try again.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(onPressed: controller.getLocalizationUser, child: const Text('REFRESH'))
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.status.isLoading,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white54,
                  child: const CupertinoActivityIndicator(radius: 30),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

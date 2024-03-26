class GeoPositionModel {
  double latitude;
  double longitude;

  GeoPositionModel({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => 'GeoPositionModel(latitude: $latitude, longitude: $longitude)';
}

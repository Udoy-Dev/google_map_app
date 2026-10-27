import 'package:geolocator/geolocator.dart';
import '../../domain/entities/location_point.dart';

abstract class LocationDataSource {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<LocationPoint> getCurrentLocation();
  Stream<LocationPoint> getLocationStream();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Future<LocationPoint> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
  }

  @override
  Stream<LocationPoint> getLocationStream() {
    // Periodic stream fetching current location every 10 seconds as requested
    return Stream.periodic(const Duration(seconds: 10)).asyncMap((_) async {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp,
      );
    });
  }
}

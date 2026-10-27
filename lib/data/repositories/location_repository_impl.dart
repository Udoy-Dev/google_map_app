import 'package:geolocator/geolocator.dart';
import '../../domain/entities/location_point.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<bool> isLocationServiceEnabled() =>
      dataSource.isLocationServiceEnabled();

  @override
  Future<bool> requestPermission() async {
    var permission = await dataSource.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await dataSource.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<LocationPoint> getCurrentLocation() =>
      dataSource.getCurrentLocation();

  @override
  Stream<LocationPoint> getLocationStream() =>
      dataSource.getLocationStream();
}

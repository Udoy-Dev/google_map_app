import '../entities/location_point.dart';
import '../repositories/location_repository.dart';

class WatchLocationUpdates {
  final LocationRepository repository;

  WatchLocationUpdates(this.repository);

  Stream<LocationPoint> call() {
    return repository.getLocationStream();
  }
}

import 'package:flutter/material.dart';
import 'data/datasources/location_data_source.dart';
import 'data/repositories/location_repository_impl.dart';
import 'domain/usecases/get_current_location.dart';
import 'domain/usecases/watch_location_updates.dart';
import 'presentation/viewmodels/map_viewmodel.dart';
import 'presentation/views/map_page.dart';

void main() {
  // Dependency Injection Setup
  final locationDataSource = LocationDataSourceImpl();
  final locationRepository = LocationRepositoryImpl(locationDataSource);
  final getCurrentLocation = GetCurrentLocation(locationRepository);
  final watchLocationUpdates = WatchLocationUpdates(locationRepository);

  final mapViewModel = MapViewModel(
    getCurrentLocation: getCurrentLocation,
    watchLocationUpdates: watchLocationUpdates,
    locationRepository: locationRepository,
  );

  runApp(MyApp(mapViewModel: mapViewModel));
}

class MyApp extends StatelessWidget {
  final MapViewModel? mapViewModel;

  const MyApp({super.key, this.mapViewModel});

  @override
  Widget build(BuildContext context) {
    final viewModel = mapViewModel ??
        MapViewModel(
          getCurrentLocation: GetCurrentLocation(
            LocationRepositoryImpl(LocationDataSourceImpl()),
          ),
          watchLocationUpdates: WatchLocationUpdates(
            LocationRepositoryImpl(LocationDataSourceImpl()),
          ),
          locationRepository: LocationRepositoryImpl(
            LocationDataSourceImpl(),
          ),
        );

    return MaterialApp(
      title: 'Google Map Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MapPage(viewModel: viewModel),
    );
  }
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_point.dart';

class MapState {
  final bool isLoading;
  final String? errorMessage;
  final LocationPoint? currentLocation;
  final List<LatLng> polylineCoordinates;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const MapState({
    this.isLoading = true,
    this.errorMessage,
    this.currentLocation,
    this.polylineCoordinates = const [],
    this.markers = const {},
    this.polylines = const {},
  });

  MapState copyWith({
    bool? isLoading,
    String? errorMessage,
    LocationPoint? currentLocation,
    List<LatLng>? polylineCoordinates,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentLocation: currentLocation ?? this.currentLocation,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }
}

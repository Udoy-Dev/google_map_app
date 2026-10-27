import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/location_point.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/watch_location_updates.dart';
import 'map_state.dart';

class MapViewModel extends ChangeNotifier {
  final GetCurrentLocation getCurrentLocation;
  final WatchLocationUpdates watchLocationUpdates;
  final LocationRepository locationRepository;

  MapState _state = const MapState();
  MapState get state => _state;

  StreamSubscription<LocationPoint>? _locationSubscription;
  GoogleMapController? _mapController;

  MapViewModel({
    required this.getCurrentLocation,
    required this.watchLocationUpdates,
    required this.locationRepository,
  });

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (_state.currentLocation != null) {
      _animateCamera(
        LatLng(_state.currentLocation!.latitude, _state.currentLocation!.longitude),
      );
    }
  }

  Future<void> initializeTracking() async {
    try {
      final serviceEnabled = await locationRepository.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: 'Location services are disabled. Please enable GPS.',
        );
        notifyListeners();
        return;
      }

      final hasPermission = await locationRepository.requestPermission();
      if (!hasPermission) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: 'Location permission denied.',
        );
        notifyListeners();
        return;
      }

      final initialPoint = await getCurrentLocation();
      final initialLatLng =
          LatLng(initialPoint.latitude, initialPoint.longitude);

      final coordinates = [initialLatLng];
      _updateMapElements(coordinates, initialLatLng);

      _state = _state.copyWith(
        isLoading: false,
        currentLocation: initialPoint,
        polylineCoordinates: coordinates,
      );
      notifyListeners();

      _animateCamera(initialLatLng);
      _startListening();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Initialization error: $e',
      );
      notifyListeners();
    }
  }

  void _startListening() {
    _locationSubscription = watchLocationUpdates().listen((point) {
      final newLatLng = LatLng(point.latitude, point.longitude);

      if (_state.currentLocation == null ||
          _state.currentLocation!.latitude != point.latitude ||
          _state.currentLocation!.longitude != point.longitude) {
        final updatedCoordinates =
            List<LatLng>.from(_state.polylineCoordinates)..add(newLatLng);
        _updateMapElements(updatedCoordinates, newLatLng);

        _state = _state.copyWith(
          currentLocation: point,
          polylineCoordinates: updatedCoordinates,
        );
        notifyListeners();

        _animateCamera(newLatLng);
      }
    }, onError: (error) {
      debugPrint('Location stream error: $error');
    });
  }

  void _updateMapElements(List<LatLng> coordinates, LatLng currentLatLng) {
    final markerId = const MarkerId('current_location_marker');
    final marker = Marker(
      markerId: markerId,
      position: currentLatLng,
      infoWindow: InfoWindow(
        title: 'My current location',
        snippet:
            'Lat: ${currentLatLng.latitude.toStringAsFixed(6)}, Lng: ${currentLatLng.longitude.toStringAsFixed(6)}',
      ),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        _mapController?.showMarkerInfoWindow(markerId);
      },
    );

    final polyline = Polyline(
      polylineId: const PolylineId('tracking_polyline'),
      points: coordinates,
      color: Colors.blue,
      width: 5,
    );

    _state = _state.copyWith(
      markers: {marker},
      polylines: {polyline},
    );
  }

  void centerOnCurrentLocation() {
    if (_state.currentLocation != null) {
      _animateCamera(
        LatLng(_state.currentLocation!.latitude, _state.currentLocation!.longitude),
      );
    }
  }

  Future<void> _animateCamera(LatLng latLng) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 16.0),
        ),
      );
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/map_viewmodel.dart';

class MapPage extends StatefulWidget {
  final MapViewModel viewModel;

  const MapPage({super.key, required this.viewModel});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.initializeTracking();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture - Map Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Acquiring location...'),
                ],
              ),
            )
          : state.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                )
              : state.currentLocation == null
                  ? const Center(child: Text('No location available'))
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.currentLocation!.latitude,
                          state.currentLocation!.longitude,
                        ),
                        zoom: 16.0,
                      ),
                      markers: state.markers,
                      polylines: state.polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (controller) {
                        widget.viewModel.setMapController(controller);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.viewModel.centerOnCurrentLocation(),
        tooltip: 'Center to Current Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

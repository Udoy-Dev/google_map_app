# Real-Time Google Maps Location Tracker (Flutter)

A production-ready Flutter application featuring real-time GPS location tracking, smooth map camera animations, live polyline path tracking, and interactive marker info windows, built using **Clean Architecture** principles.

## Features

- **Automatic Map Animation**: Smoothly animates the Google Map camera to the user's current location.
- **Real-Time Location Updates**: Fetches the user's GPS position every 10 seconds and updates the map marker dynamically.
- **Polyline Path Tracking**: Draws and updates a live polyline tracking path connecting previous and current coordinates.
- **Interactive Marker Info Window**: Tapping the marker opens an info window displaying *"My current location"* as the title and precise latitude/longitude as the snippet.
- **Clean Architecture**: Decoupled Domain, Data, and Presentation layers ensuring testability, maintainability, and scalability.

---

## Project Structure

```text
lib/
├── data/
│   ├── datasources/       # External API integrations (Geolocator)
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Pure domain models (LocationPoint)
│   ├── repositories/      # Abstract repository interfaces
│   └── usecases/          # Business logic use cases
└── presentation/
    ├── viewmodels/        # UI state models and ViewModels (ChangeNotifier)
    └── views/             # Google Maps UI views
```

---

## Getting Started & Configuration

### 1. Prerequisites
- Flutter SDK (^3.13.5 or higher)
- Android SDK / iOS SDK
- Google Maps API Key

### 2. Configure Google Maps API Key
Add your Google Maps API key in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

### 3. Run the App
```bash
flutter pub get
flutter run
```

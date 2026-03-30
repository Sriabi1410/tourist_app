import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {
  double _latitude = 28.6139;
  double _longitude = 77.2090;
  bool _isTracking = false;
  bool _isLocationEnabled = true;
  bool _backgroundTracking = false;
  String _currentAddress = 'New Delhi, India';
  final List<Map<String, dynamic>> _locationHistory = [];
  final List<Map<String, dynamic>> _nearbyPlaces = [];

  double get latitude => _latitude;
  double get longitude => _longitude;
  bool get isTracking => _isTracking;
  bool get isLocationEnabled => _isLocationEnabled;
  bool get backgroundTracking => _backgroundTracking;
  String get currentAddress => _currentAddress;
  List<Map<String, dynamic>> get locationHistory => _locationHistory;
  List<Map<String, dynamic>> get nearbyPlaces => _nearbyPlaces;

  void updateLocation(double lat, double lng, {String? address}) {
    _latitude = lat;
    _longitude = lng;
    if (address != null) _currentAddress = address;
    _locationHistory.add({
      'lat': lat,
      'lng': lng,
      'address': _currentAddress,
      'timestamp': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  void startTracking() {
    _isTracking = true;
    notifyListeners();
  }

  void stopTracking() {
    _isTracking = false;
    notifyListeners();
  }

  void toggleLocationEnabled(bool value) {
    _isLocationEnabled = value;
    notifyListeners();
  }

  void toggleBackgroundTracking(bool value) {
    _backgroundTracking = value;
    notifyListeners();
  }

  void loadNearbyPlaces() {
    _nearbyPlaces.clear();
    _nearbyPlaces.addAll([
      {'name': 'City Police Station', 'type': 'police', 'distance': '0.8 km', 'lat': _latitude + 0.003, 'lng': _longitude + 0.002, 'phone': '100'},
      {'name': 'General Hospital', 'type': 'hospital', 'distance': '1.2 km', 'lat': _latitude - 0.005, 'lng': _longitude + 0.004, 'phone': '102'},
      {'name': 'Fire Station #3', 'type': 'fire', 'distance': '1.5 km', 'lat': _latitude + 0.006, 'lng': _longitude - 0.003, 'phone': '101'},
      {'name': 'US Embassy', 'type': 'embassy', 'distance': '2.1 km', 'lat': _latitude - 0.008, 'lng': _longitude - 0.006, 'phone': '+91-11-2419-8000'},
      {'name': 'Tourist Police Office', 'type': 'police', 'distance': '2.4 km', 'lat': _latitude + 0.010, 'lng': _longitude + 0.007, 'phone': '1363'},
      {'name': 'Apollo Hospital', 'type': 'hospital', 'distance': '3.0 km', 'lat': _latitude - 0.012, 'lng': _longitude + 0.009, 'phone': '+91-11-2692-5858'},
    ]);
    notifyListeners();
  }
}

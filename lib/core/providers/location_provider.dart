import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config.dart';

class LocationProvider extends ChangeNotifier {
  double _latitude = 28.6139;
  double _longitude = 77.2090;
  bool _isTracking = false;
  bool _isLocationEnabled = true;
  bool _backgroundTracking = false;
  bool _isOffline = false;
  String _currentAddress = 'New Delhi, India';
  final List<Map<String, dynamic>> _locationHistory = [];
  final List<Map<String, dynamic>> _pendingLocations = [];
  final List<Map<String, dynamic>> _nearbyPlaces = [];

  LocationProvider() {
    _loadCachedLocations().then((_) => _syncPendingLocations());
  }

  double get latitude => _latitude;
  double get longitude => _longitude;
  bool get isTracking => _isTracking;
  bool get isLocationEnabled => _isLocationEnabled;
  bool get backgroundTracking => _backgroundTracking;
  bool get isOffline => _isOffline;
  String get currentAddress => _currentAddress;
  List<Map<String, dynamic>> get locationHistory => _locationHistory;
  List<Map<String, dynamic>> get pendingLocations => _pendingLocations;
  List<Map<String, dynamic>> get nearbyPlaces => _nearbyPlaces;

  Future<void> _loadCachedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final rawHistory = prefs.getString('location_history');
    if (rawHistory != null) {
      final parsed = jsonDecode(rawHistory) as List<dynamic>;
      _locationHistory
        ..clear()
        ..addAll(parsed.map((item) => Map<String, dynamic>.from(item as Map)));
    }

    final rawPending = prefs.getString('pending_locations');
    if (rawPending != null) {
      final parsed = jsonDecode(rawPending) as List<dynamic>;
      _pendingLocations
        ..clear()
        ..addAll(parsed.map((item) => Map<String, dynamic>.from(item as Map)));
    }

    notifyListeners();
  }

  Future<void> _saveCachedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location_history', jsonEncode(_locationHistory));
  }

  Future<void> _savePendingLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_locations', jsonEncode(_pendingLocations));
  }

  Future<bool> _hasInternetConnection() async {
    final status = await Connectivity().checkConnectivity();
    final statusText = status.toString().toLowerCase();
    return !statusText.contains('none');
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.denied && permission != LocationPermission.deniedForever;
  }

  Future<void> refreshLocation() async {
    final granted = await _ensureLocationPermission();
    if (!granted) {
      _isOffline = true;
      notifyListeners();
      return;
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var address = _currentAddress;

    try {
      final places = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (places.isNotEmpty) {
        final place = places.first;
        address = '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}'.trim();
      }
    } catch (_) {
      // reverse geocoding failed, keep last known address
    }

    updateLocation(position.latitude, position.longitude, address: address);
    _isOffline = !await _hasInternetConnection();
    if (!_isOffline) {
      await syncLocation();
      await _syncPendingLocations();
    } else {
      await _saveOfflineLocation(position.latitude, position.longitude, address);
    }
  }

  void updateLocation(double lat, double lng, {String? address}) {
    _latitude = lat;
    _longitude = lng;
    if (address != null) {
      _currentAddress = address;
    }
    _locationHistory.add({
      'lat': lat,
      'lng': lng,
      'address': _currentAddress,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _saveCachedLocations();
    notifyListeners();
  }

  Future<void> syncLocation() async {
    if (ApiConfig.authToken.isEmpty) return;
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      _isOffline = true;
      notifyListeners();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/locations/update'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'latitude': _latitude,
          'longitude': _longitude,
          'address': _currentAddress,
        }),
      );

      _isOffline = response.statusCode != 200;
      if (!_isOffline) {
        _pendingLocations.clear();
        await _savePendingLocations();
      }
    } catch (_) {
      _isOffline = true;
    }

    notifyListeners();
  }

  Future<void> _saveOfflineLocation(double lat, double lng, String address) async {
    _pendingLocations.add({
      'lat': lat,
      'lng': lng,
      'address': address,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _savePendingLocations();
  }

  Future<void> _syncPendingLocations() async {
    if (ApiConfig.authToken.isEmpty) return;
    if (!await _hasInternetConnection()) return;

    final pendingCopy = List<Map<String, dynamic>>.from(_pendingLocations);
    for (final location in pendingCopy) {
      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.apiBaseUrl}/locations/update'),
          headers: ApiConfig.authHeaders,
          body: jsonEncode({
            'latitude': location['lat'],
            'longitude': location['lng'],
            'address': location['address'],
          }),
        );

        if (response.statusCode == 200) {
          _pendingLocations.removeWhere(
            (item) => item['timestamp'] == location['timestamp'],
          );
        }
      } catch (_) {
        // Keep unsynced item for later
      }
    }

    await _savePendingLocations();
    if (_pendingLocations.isEmpty) {
      _isOffline = false;
    }
    notifyListeners();
  }

  Future<String?> shareLiveLocation({int durationMinutes = 60}) async {
    if (ApiConfig.authToken.isEmpty) return null;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/locations/share'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'latitude': _latitude,
          'longitude': _longitude,
          'duration': durationMinutes,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['shareLink'] as String?;
      }
    } catch (_) {
      // fallback if share endpoint is unavailable
    }
    return null;
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

  Future<void> loadNearbyPlaces({String type = 'all'}) async {
    _nearbyPlaces.clear();
    notifyListeners();

    try {
      final uri = Uri.parse('${ApiConfig.apiBaseUrl}/locations/nearby?lat=$_latitude&lng=$_longitude&type=$type');
      final response = await http.get(uri, headers: ApiConfig.defaultHeaders);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final places = data['places'] as List<dynamic>?;
        if (places != null) {
          _nearbyPlaces.addAll(places.map((place) => Map<String, dynamic>.from(place as Map)));
          notifyListeners();
          return;
        }
      }
    } catch (_) {
      // fallback to local cached places
    }

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

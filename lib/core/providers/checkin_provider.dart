import 'package:flutter/material.dart';

class CheckinProvider extends ChangeNotifier {
  bool _autoCheckinEnabled = false;
  int _checkinIntervalMinutes = 60;
  DateTime? _lastCheckin;
  bool _hasMissedCheckin = false;
  final List<Map<String, dynamic>> _checkinHistory = [];
  final List<Map<String, dynamic>> _travelLog = [];
  double _totalDistanceKm = 0;

  bool get autoCheckinEnabled => _autoCheckinEnabled;
  int get checkinIntervalMinutes => _checkinIntervalMinutes;
  DateTime? get lastCheckin => _lastCheckin;
  bool get hasMissedCheckin => _hasMissedCheckin;
  List<Map<String, dynamic>> get checkinHistory => _checkinHistory;
  List<Map<String, dynamic>> get travelLog => _travelLog;
  double get totalDistanceKm => _totalDistanceKm;

  void checkIn({required double lat, required double lng, String? message}) {
    _lastCheckin = DateTime.now();
    _hasMissedCheckin = false;
    _checkinHistory.insert(0, {
      'timestamp': _lastCheckin!.toIso8601String(),
      'lat': lat,
      'lng': lng,
      'message': message ?? "I'm safe",
      'type': 'manual',
    });
    notifyListeners();
  }

  void setAutoCheckin(bool enabled) {
    _autoCheckinEnabled = enabled;
    notifyListeners();
  }

  void setCheckinInterval(int minutes) {
    _checkinIntervalMinutes = minutes;
    notifyListeners();
  }

  void triggerMissedCheckin() {
    _hasMissedCheckin = true;
    notifyListeners();
  }

  void addTravelActivity(Map<String, dynamic> activity) {
    _travelLog.insert(0, activity);
    notifyListeners();
  }

  void updateTotalDistance(double km) {
    _totalDistanceKm = km;
    notifyListeners();
  }
}

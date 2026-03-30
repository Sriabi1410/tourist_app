import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _biometricEnabled = false;
  bool _locationSharing = true;
  bool _crimeAlerts = true;
  bool _weatherAlerts = true;
  bool _travelAdvisories = true;
  bool _pushNotifications = true;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '07:00';
  bool _quietHoursEnabled = false;
  String _appVersion = '1.0.0';

  bool get biometricEnabled => _biometricEnabled;
  bool get locationSharing => _locationSharing;
  bool get crimeAlerts => _crimeAlerts;
  bool get weatherAlerts => _weatherAlerts;
  bool get travelAdvisories => _travelAdvisories;
  bool get pushNotifications => _pushNotifications;
  String get quietHoursStart => _quietHoursStart;
  String get quietHoursEnd => _quietHoursEnd;
  bool get quietHoursEnabled => _quietHoursEnabled;
  String get appVersion => _appVersion;

  void toggleBiometric(bool val) { _biometricEnabled = val; notifyListeners(); }
  void toggleLocationSharing(bool val) { _locationSharing = val; notifyListeners(); }
  void toggleCrimeAlerts(bool val) { _crimeAlerts = val; notifyListeners(); }
  void toggleWeatherAlerts(bool val) { _weatherAlerts = val; notifyListeners(); }
  void toggleTravelAdvisories(bool val) { _travelAdvisories = val; notifyListeners(); }
  void togglePushNotifications(bool val) { _pushNotifications = val; notifyListeners(); }
  void toggleQuietHours(bool val) { _quietHoursEnabled = val; notifyListeners(); }
  void setQuietHours(String start, String end) {
    _quietHoursStart = start;
    _quietHoursEnd = end;
    notifyListeners();
  }
}

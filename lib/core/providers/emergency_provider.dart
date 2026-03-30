import 'package:flutter/material.dart';

enum EmergencyType { medical, police, fire, naturalDisaster, theft, harassment, accident, other }
enum EmergencyStatus { pending, active, responding, resolved, cancelled }

class EmergencyEvent {
  final String id;
  final EmergencyType type;
  EmergencyStatus status;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  String? responderId;
  String? responderName;
  String? responderPhone;
  int? etaMinutes;

  EmergencyEvent({
    required this.id,
    required this.type,
    this.status = EmergencyStatus.pending,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.responderId,
    this.responderName,
    this.responderPhone,
    this.etaMinutes,
  });
}

class EmergencyProvider extends ChangeNotifier {
  bool _isSosActive = false;
  EmergencyEvent? _currentEmergency;
  final List<EmergencyEvent> _emergencyHistory = [];
  int _countdown = 3;
  bool _isCountingDown = false;

  bool get isSosActive => _isSosActive;
  EmergencyEvent? get currentEmergency => _currentEmergency;
  List<EmergencyEvent> get emergencyHistory => _emergencyHistory;
  int get countdown => _countdown;
  bool get isCountingDown => _isCountingDown;

  void startCountdown() {
    _isCountingDown = true;
    _countdown = 3;
    notifyListeners();
  }

  void updateCountdown(int value) {
    _countdown = value;
    notifyListeners();
  }

  void triggerSos({
    required EmergencyType type,
    required double lat,
    required double lng,
  }) {
    _isSosActive = true;
    _isCountingDown = false;
    _currentEmergency = EmergencyEvent(
      id: 'EMG-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      status: EmergencyStatus.active,
    );
    _emergencyHistory.insert(0, _currentEmergency!);
    notifyListeners();
  }

  void updateEmergencyStatus(EmergencyStatus status) {
    if (_currentEmergency != null) {
      _currentEmergency!.status = status;
      notifyListeners();
    }
  }

  void assignResponder({
    required String id,
    required String name,
    required String phone,
    required int eta,
  }) {
    if (_currentEmergency != null) {
      _currentEmergency!.responderId = id;
      _currentEmergency!.responderName = name;
      _currentEmergency!.responderPhone = phone;
      _currentEmergency!.etaMinutes = eta;
      _currentEmergency!.status = EmergencyStatus.responding;
      notifyListeners();
    }
  }

  void cancelSos() {
    _isSosActive = false;
    _isCountingDown = false;
    if (_currentEmergency != null) {
      _currentEmergency!.status = EmergencyStatus.cancelled;
    }
    _currentEmergency = null;
    notifyListeners();
  }

  void resolveSos() {
    _isSosActive = false;
    if (_currentEmergency != null) {
      _currentEmergency!.status = EmergencyStatus.resolved;
    }
    _currentEmergency = null;
    notifyListeners();
  }

  String getEmergencyTypeLabel(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical: return 'Medical Emergency';
      case EmergencyType.police: return 'Police Help';
      case EmergencyType.fire: return 'Fire Emergency';
      case EmergencyType.naturalDisaster: return 'Natural Disaster';
      case EmergencyType.theft: return 'Theft / Robbery';
      case EmergencyType.harassment: return 'Harassment';
      case EmergencyType.accident: return 'Accident';
      case EmergencyType.other: return 'Other Emergency';
    }
  }

  IconData getEmergencyTypeIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical: return Icons.local_hospital;
      case EmergencyType.police: return Icons.local_police;
      case EmergencyType.fire: return Icons.local_fire_department;
      case EmergencyType.naturalDisaster: return Icons.storm;
      case EmergencyType.theft: return Icons.report;
      case EmergencyType.harassment: return Icons.warning_amber;
      case EmergencyType.accident: return Icons.car_crash;
      case EmergencyType.other: return Icons.sos;
    }
  }
}

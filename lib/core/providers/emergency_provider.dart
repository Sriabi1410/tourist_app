import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;
import '../api_config.dart';

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
  final List<Map<String, dynamic>> _pendingSosEvents = [];
  int _countdown = 3;
  bool _isCountingDown = false;
  socket_io_client.Socket? _socket;

  EmergencyProvider() {
    _loadCachedEmergencies();
  }

  bool get isSosActive => _isSosActive;
  EmergencyEvent? get currentEmergency => _currentEmergency;
  List<EmergencyEvent> get emergencyHistory => _emergencyHistory;
  List<Map<String, dynamic>> get pendingSosEvents => _pendingSosEvents;
  bool get hasPendingSos => _pendingSosEvents.isNotEmpty;
  int get countdown => _countdown;
  bool get isCountingDown => _isCountingDown;

  void startCountdown() {
    _isCountingDown = true;
    _countdown = 3;
    notifyListeners();
  }

  Future<void> _loadCachedEmergencies() async {
    final prefs = await SharedPreferences.getInstance();
    final rawHistory = prefs.getString('cached_emergency_history');
    if (rawHistory != null) {
      final parsed = jsonDecode(rawHistory) as List<dynamic>;
      _emergencyHistory
        ..clear()
        ..addAll(parsed.map((item) {
          final data = Map<String, dynamic>.from(item as Map);
          final type = EmergencyType.values.firstWhere(
            (e) => e.name == (data['type'] as String? ?? ''),
            orElse: () => EmergencyType.other,
          );
          final status = EmergencyStatus.values.firstWhere(
            (e) => e.name == (data['status'] as String? ?? ''),
            orElse: () => EmergencyStatus.pending,
          );
          return EmergencyEvent(
            id: data['id'] as String? ?? 'EMG-UNKNOWN',
            type: type,
            status: status,
            latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
            longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
            timestamp: DateTime.tryParse(data['timestamp'] as String? ?? '') ?? DateTime.now(),
            responderId: data['responderId'] as String?,
            responderName: data['responderName'] as String?,
            responderPhone: data['responderPhone'] as String?,
            etaMinutes: data['etaMinutes'] as int?,
          );
        }).toList());
    }

    final rawPending = prefs.getString('pending_sos_events');
    if (rawPending != null) {
      final parsed = jsonDecode(rawPending) as List<dynamic>;
      _pendingSosEvents
        ..clear()
        ..addAll(parsed.map((item) => Map<String, dynamic>.from(item as Map)));
    }

    notifyListeners();
  }

  Future<void> _saveCachedHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_emergency_history', jsonEncode(_emergencyHistory.map((event) {
      return {
        'id': event.id,
        'type': event.type.name,
        'status': event.status.name,
        'latitude': event.latitude,
        'longitude': event.longitude,
        'timestamp': event.timestamp.toIso8601String(),
        'responderId': event.responderId,
        'responderName': event.responderName,
        'responderPhone': event.responderPhone,
        'etaMinutes': event.etaMinutes,
      };
    }).toList()));
  }

  Future<void> _savePendingSosEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_sos_events', jsonEncode(_pendingSosEvents));
  }

  Future<void> _cachePendingSos(
    EmergencyType type,
    double lat,
    double lng,
    String message,
    List<String> recipients, {
    String? userId,
    String? userName,
  }) async {
    _pendingSosEvents.add({
      'id': 'PENDING-${DateTime.now().millisecondsSinceEpoch}',
      'type': type.name,
      'latitude': lat,
      'longitude': lng,
      'message': message,
      'recipients': recipients,
      'userId': userId,
      'userName': userName,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _savePendingSosEvents();
  }

  Future<void> syncPendingSos() async {
    if (ApiConfig.authToken.isEmpty) return;
    if (_pendingSosEvents.isEmpty) return;

    final pending = List<Map<String, dynamic>>.from(_pendingSosEvents);
    for (final event in pending) {
      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.apiBaseUrl}/emergency/sos'),
          headers: ApiConfig.authHeaders,
          body: jsonEncode({
            'type': event['type'],
            'latitude': event['latitude'],
            'longitude': event['longitude'],
            'message': event['message'],
          }),
        );

        if (response.statusCode == 201) {
          _pendingSosEvents.removeWhere((item) => item['id'] == event['id']);
          await _savePendingSosEvents();
          final data = jsonDecode(response.body)['emergency'] as Map<String, dynamic>;
          final emergency = EmergencyEvent(
            id: data['id'] as String? ?? event['id'] as String,
            type: EmergencyType.values.firstWhere(
              (e) => e.name == (data['type'] as String? ?? event['type'] as String),
              orElse: () => EmergencyType.other,
            ),
            latitude: (data['latitude'] as num?)?.toDouble() ?? (event['latitude'] as num).toDouble(),
            longitude: (data['longitude'] as num?)?.toDouble() ?? (event['longitude'] as num).toDouble(),
            timestamp: DateTime.now(),
            status: EmergencyStatus.active,
          );
          _emergencyHistory.insert(0, emergency);
          await _saveCachedHistory();
        }
      } catch (_) {
        // Keep pending event to retry later
      }
    }

    notifyListeners();
  }

  Future<void> fetchActiveEmergency() async {
    if (ApiConfig.authToken.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.apiBaseUrl}/emergency/active'),
        headers: ApiConfig.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['emergency'] as Map<String, dynamic>?;
        if (data != null) {
          _currentEmergency = EmergencyEvent(
            id: data['id'] as String? ?? 'EMG-${DateTime.now().millisecondsSinceEpoch}',
            type: EmergencyType.values.firstWhere(
              (e) => e.name == (data['type'] as String? ?? ''),
              orElse: () => EmergencyType.other,
            ),
            latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
            longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
            timestamp: DateTime.tryParse(data['createdAt'] as String? ?? '') ?? DateTime.now(),
            status: EmergencyStatus.values.firstWhere(
              (e) => e.name == (data['status'] as String? ?? 'active'),
              orElse: () => EmergencyStatus.active,
            ),
            responderId: data['responderId'] as String?,
            responderName: data['responderName'] as String?,
            responderPhone: data['responderPhone'] as String?,
            etaMinutes: (data['eta'] as int?) ?? (data['eta'] != null ? int.tryParse(data['eta'].toString()) : null),
          );
          if (!_emergencyHistory.any((event) => event.id == _currentEmergency!.id)) {
            _emergencyHistory.insert(0, _currentEmergency!);
            await _saveCachedHistory();
          }
        } else {
          _currentEmergency = null;
        }
      }
    } catch (_) {
      // ignore network errors
    }
    notifyListeners();
  }

  Future<void> fetchEmergencyHistory() async {
    if (ApiConfig.authToken.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.apiBaseUrl}/emergency/history'),
        headers: ApiConfig.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['emergencies'] as List<dynamic>?;
        if (data != null) {
          _emergencyHistory
            ..clear()
            ..addAll(data.map((item) {
              final event = Map<String, dynamic>.from(item as Map);
              return EmergencyEvent(
                id: event['id'] as String? ?? 'EMG-UNKNOWN',
                type: EmergencyType.values.firstWhere(
                  (e) => e.name == (event['type'] as String? ?? ''),
                  orElse: () => EmergencyType.other,
                ),
                latitude: (event['latitude'] as num?)?.toDouble() ?? 0.0,
                longitude: (event['longitude'] as num?)?.toDouble() ?? 0.0,
                timestamp: DateTime.tryParse(event['createdAt'] as String? ?? '') ?? DateTime.now(),
                status: EmergencyStatus.values.firstWhere(
                  (e) => e.name == (event['status'] as String? ?? 'active'),
                  orElse: () => EmergencyStatus.active,
                ),
                responderId: event['responderId'] as String?,
                responderName: event['responderName'] as String?,
                responderPhone: event['responderPhone'] as String?,
                etaMinutes: (event['eta'] as int?) ?? (event['eta'] != null ? int.tryParse(event['eta'].toString()) : null),
              );
            }).toList());
          await _saveCachedHistory();
        }
      }
    } catch (_) {
      // ignore network errors
    }
    notifyListeners();
  }

  void updateCountdown(int value) {
    _countdown = value;
    notifyListeners();
  }

  Future<void> triggerSos({
    required EmergencyType type,
    required double lat,
    required double lng,
    String? userId,
    String? userName,
    List<String>? trustedContacts,
  }) async {
    _isSosActive = true;
    _isCountingDown = false;
    notifyListeners();

    final message = _buildSosMessage(type, lat, lng, userId, userName);
    final recipients = _mergeContacts(trustedContacts);

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/emergency/sos'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'type': type.name,
          'latitude': lat,
          'longitude': lng,
          'message': message,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['emergency'] as Map<String, dynamic>;
        _currentEmergency = EmergencyEvent(
          id: data['id'] as String? ?? 'EMG-${DateTime.now().millisecondsSinceEpoch}',
          type: type,
          latitude: lat,
          longitude: lng,
          timestamp: DateTime.now(),
          status: EmergencyStatus.active,
        );
        _emergencyHistory.insert(0, _currentEmergency!);
        await _saveCachedHistory();
        _connectSocket();
        notifyListeners();
        await syncPendingSos();
        return;
      }

      await _activateOfflineSos(type, lat, lng, message, recipients, userId: userId, userName: userName);
    } catch (e) {
      await _activateOfflineSos(type, lat, lng, message, recipients, userId: userId, userName: userName);
    }
  }

  Future<void> _activateOfflineSos(
    EmergencyType type,
    double lat,
    double lng,
    String message,
    List<String> recipients, {
    String? userId,
    String? userName,
  }) async {
    _currentEmergency = EmergencyEvent(
      id: 'OFF-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      status: EmergencyStatus.active,
    );
    _emergencyHistory.insert(0, _currentEmergency!);
    await _cachePendingSos(type, lat, lng, message, recipients, userId: userId, userName: userName);
    await _saveCachedHistory();
    await _sendSmsAlert(message, recipients);
    notifyListeners();
  }

  String _buildSosMessage(
    EmergencyType type,
    double lat,
    double lng,
    String? userId,
    String? userName,
  ) {
    final name = userName?.isNotEmpty == true ? userName : 'Unknown User';
    final id = userId?.isNotEmpty == true ? userId : 'Unknown ID';
    return '''Emergency! I need help.
Type: ${getEmergencyTypeLabel(type)}
User: $name ($id)
Location: https://maps.google.com/?q=$lat,$lng''';
  }

  List<String> _mergeContacts(List<String>? trustedContacts) {
    final contacts = <String>[];
    contacts.addAll(ApiConfig.emergencyNumbers);
    if (trustedContacts != null) {
      for (final contact in trustedContacts) {
        if (contact.trim().isNotEmpty && !contacts.contains(contact.trim())) {
          contacts.add(contact.trim());
        }
      }
    }
    return contacts;
  }

  Future<void> _sendSmsAlert(String message, List<String> recipients) async {
    if (recipients.isEmpty) return;

    final uri = Uri(
      scheme: 'sms',
      path: recipients.join(','),
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Unable to launch SMS client for $uri');
    }
  }

  void _connectSocket() {
    if (_socket != null && _socket!.connected) return;
    _socket = socket_io_client.io(ApiConfig.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.on('sos_update', (data) {
      if (_currentEmergency != null && data['id'] == _currentEmergency!.id) {
        if (data['status'] == 'responding') {
          assignResponder(
            id: data['responderId'] ?? 'RES-01',
            name: data['responderName'] ?? 'Responder',
            phone: data['responderPhone'] ?? '',
            eta: data['eta'] != null ? int.tryParse(data['eta'].toString()) ?? 5 : 5,
          );
        } else if (data['status'] == 'resolved') {
          resolveSos();
        }
      }
    });
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
      case EmergencyType.medical:
        return 'Medical Emergency';
      case EmergencyType.police:
        return 'Police Help';
      case EmergencyType.fire:
        return 'Fire Emergency';
      case EmergencyType.naturalDisaster:
        return 'Natural Disaster';
      case EmergencyType.theft:
        return 'Theft / Robbery';
      case EmergencyType.harassment:
        return 'Harassment';
      case EmergencyType.accident:
        return 'Accident';
      case EmergencyType.other:
        return 'Other Emergency';
    }
  }

  IconData getEmergencyTypeIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return Icons.local_hospital;
      case EmergencyType.police:
        return Icons.local_police;
      case EmergencyType.fire:
        return Icons.local_fire_department;
      case EmergencyType.naturalDisaster:
        return Icons.storm;
      case EmergencyType.theft:
        return Icons.report;
      case EmergencyType.harassment:
        return Icons.warning_amber;
      case EmergencyType.accident:
        return Icons.car_crash;
      case EmergencyType.other:
        return Icons.sos;
    }
  }
}

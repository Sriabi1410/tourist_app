import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _userId = '';
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _nationality = '';
  String _avatarUrl = '';
  List<Map<String, String>> _emergencyContacts = [];

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get nationality => _nationality;
  String get avatarUrl => _avatarUrl;
  List<Map<String, String>> get emergencyContacts => _emergencyContacts;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _userId = 'USR-${DateTime.now().millisecondsSinceEpoch}';
    _userEmail = email;
    _userName = email.split('@').first;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String nationality,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _userId = 'USR-${DateTime.now().millisecondsSinceEpoch}';
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _nationality = nationality;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
    return otp.length == 6;
  }

  void updateProfile({String? name, String? email, String? phone, String? nationality}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (nationality != null) _nationality = nationality;
    notifyListeners();
  }

  void addEmergencyContact(Map<String, String> contact) {
    _emergencyContacts.add(contact);
    notifyListeners();
  }

  void removeEmergencyContact(int index) {
    _emergencyContacts.removeAt(index);
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userId = '';
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _nationality = '';
    _emergencyContacts = [];
    notifyListeners();
  }
}

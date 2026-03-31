import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _userId = '';
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _nationality = '';
  String _avatarUrl = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _token = '';
  String _pendingEmail = '';
  String _errorMessage = '';
  List<Map<String, String>> _emergencyContacts = [];

  AuthProvider() {
    _loadSession();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get nationality => _nationality;
  String get avatarUrl => _avatarUrl;
  String get token => _token;
  String get pendingEmail => _pendingEmail;
  String get errorMessage => _errorMessage;
  List<Map<String, String>> get emergencyContacts => _emergencyContacts;

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('user_token') ?? '';
    _userId = prefs.getString('user_id') ?? '';
    _userName = prefs.getString('user_name') ?? '';
    _userEmail = prefs.getString('user_email') ?? '';
    _userPhone = prefs.getString('user_phone') ?? '';
    _nationality = prefs.getString('nationality') ?? '';
    final savedContacts = prefs.getStringList('emergency_contacts') ?? [];
    _emergencyContacts = savedContacts
        .map((json) => Map<String, String>.from(jsonDecode(json) as Map))
        .toList();
    if (_token.isNotEmpty) {
      ApiConfig.authToken = _token;
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', _token);
    await prefs.setString('user_id', _userId);
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_email', _userEmail);
    await prefs.setString('user_phone', _userPhone);
    await prefs.setString('nationality', _nationality);
    await prefs.setStringList(
      'emergency_contacts',
      _emergencyContacts.map((contact) => jsonEncode(contact)).toList(),
    );
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('nationality');
    await prefs.remove('emergency_contacts');
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    UserCredential? firebaseCredential;
    try {
      firebaseCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Firebase authentication failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/auth/login'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _token = data['token'] ?? '';
        _userId = data['user']?['id'] ?? '';
        _userName = data['user']?['name'] ?? email.split('@').first;
        _userEmail = data['user']?['email'] ?? email;
        _userPhone = data['user']?['phone'] ?? '';
        _nationality = data['user']?['nationality'] ?? '';
        _isLoggedIn = true;
        ApiConfig.authToken = _token;
        await _saveSession();

        final user = firebaseCredential.user;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set(
            {
              'backendUserId': _userId,
              'name': _userName,
              'email': _userEmail,
              'phone': _userPhone,
              'nationality': _nationality,
              'lastLogin': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }

        return true;
      }

      if (firebaseCredential != null) {
        await _firebaseAuth.signOut();
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      _errorMessage = payload['error'] ?? 'Login failed';
      return false;
    } catch (e) {
      _errorMessage = 'Unable to reach the server. Please check your internet connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String nationality,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    UserCredential? firebaseCredential;
    try {
      firebaseCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = firebaseCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'nationality': nationality,
          'createdAt': FieldValue.serverTimestamp(),
          'backendRegistered': false,
        });
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Firebase registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/auth/register'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'nationality': nationality,
        }),
      );

      if (response.statusCode == 201) {
        _pendingEmail = email;
        _userName = name;
        _userEmail = email;
        _userPhone = phone;
        _nationality = nationality;
        _userId = '';
        _isLoggedIn = false;
        notifyListeners();
        return true;
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      _errorMessage = payload['error'] ?? 'Registration failed';
      if (firebaseCredential != null && firebaseCredential.user != null) {
        await firebaseCredential.user!.delete();
        await _firebaseAuth.signOut();
      }
      return false;
    } catch (e) {
      _errorMessage = 'Unable to reach the server. Please check your internet connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/auth/verify-otp'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({'email': _pendingEmail.isNotEmpty ? _pendingEmail : _userEmail, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _token = data['token'] ?? '';
        _userId = data['user']?['id'] ?? _userId;
        _userName = data['user']?['name'] ?? _userName;
        _userEmail = data['user']?['email'] ?? _userEmail;
        _isLoggedIn = true;
        ApiConfig.authToken = _token;
        await _saveSession();

        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser != null) {
          await _firestore.collection('users').doc(firebaseUser.uid).set(
            {
              'backendUserId': _userId,
              'name': _userName,
              'email': _userEmail,
              'phone': _userPhone,
              'nationality': _nationality,
              'verifiedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }

        return true;
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      _errorMessage = payload['error'] ?? 'OTP verification failed';
      return false;
    } catch (e) {
      _errorMessage = 'Unable to reach the server. Please check your internet connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile({String? name, String? email, String? phone, String? nationality}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (nationality != null) _nationality = nationality;
    _saveSession();
    notifyListeners();
  }

  void addEmergencyContact(Map<String, String> contact) {
    _emergencyContacts.add(contact);
    _saveSession();
    notifyListeners();
  }

  void removeEmergencyContact(int index) {
    _emergencyContacts.removeAt(index);
    _saveSession();
    notifyListeners();
  }

  Future<void> logout() async {
    if (_token.isNotEmpty) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.apiBaseUrl}/auth/logout'),
          headers: ApiConfig.authHeaders,
        );
      } catch (_) {
        // ignore logout errors
      }
    }

    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      // ignore firebase logout errors
    }

    _isLoggedIn = false;
    _userId = '';
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _nationality = '';
    _avatarUrl = '';
    _token = '';
    _pendingEmail = '';
    _emergencyContacts = [];
    ApiConfig.authToken = '';
    await _clearSession();
    notifyListeners();
  }
}

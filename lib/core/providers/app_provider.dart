import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String _selectedLanguage = 'English';
  bool _isOnline = true;
  bool _hasCompletedOnboarding = false;
  int _currentNavIndex = 0;

  String get selectedLanguage => _selectedLanguage;
  bool get isOnline => _isOnline;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  int get currentNavIndex => _currentNavIndex;

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void setOnlineStatus(bool status) {
    _isOnline = status;
    notifyListeners();
  }

  void completeOnboarding() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }
}

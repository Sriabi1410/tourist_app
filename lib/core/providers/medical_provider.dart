import 'package:flutter/material.dart';

class MedicalProvider extends ChangeNotifier {
  String _bloodType = '';
  String _allergies = '';
  String _medications = '';
  String _conditions = '';
  String _insuranceProvider = '';
  String _insuranceNumber = '';
  List<Map<String, String>> _medicalContacts = [];
  bool _shareWithResponders = true;

  String get bloodType => _bloodType;
  String get allergies => _allergies;
  String get medications => _medications;
  String get conditions => _conditions;
  String get insuranceProvider => _insuranceProvider;
  String get insuranceNumber => _insuranceNumber;
  List<Map<String, String>> get medicalContacts => _medicalContacts;
  bool get shareWithResponders => _shareWithResponders;

  void updateMedicalProfile({
    String? bloodType,
    String? allergies,
    String? medications,
    String? conditions,
    String? insuranceProvider,
    String? insuranceNumber,
  }) {
    if (bloodType != null) _bloodType = bloodType;
    if (allergies != null) _allergies = allergies;
    if (medications != null) _medications = medications;
    if (conditions != null) _conditions = conditions;
    if (insuranceProvider != null) _insuranceProvider = insuranceProvider;
    if (insuranceNumber != null) _insuranceNumber = insuranceNumber;
    notifyListeners();
  }

  void addMedicalContact(Map<String, String> contact) {
    _medicalContacts.add(contact);
    notifyListeners();
  }

  void removeMedicalContact(int index) {
    _medicalContacts.removeAt(index);
    notifyListeners();
  }

  void toggleShareWithResponders(bool value) {
    _shareWithResponders = value;
    notifyListeners();
  }
}

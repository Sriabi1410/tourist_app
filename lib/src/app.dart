import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/emergency_contacts_page.dart';
import 'pages/emergency_sos_page.dart';
import 'pages/location_tracking_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/settings_page.dart';
import 'utils/routes.dart';

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Emergency Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE63946)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginPage(),
        Routes.register: (context) => const RegisterPage(),
        Routes.dashboard: (context) => const DashboardPage(),
        Routes.emergencySos: (context) => const EmergencySosPage(),
        Routes.locationTracking: (context) => const LocationTrackingPage(),
        Routes.emergencyContacts: (context) => const EmergencyContactsPage(),
        Routes.settings: (context) => const SettingsPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../modules/auth/splash_screen.dart';
import '../modules/auth/language_selection_screen.dart';
import '../modules/auth/onboarding_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/auth/otp_verification_screen.dart';
import '../modules/auth/profile_screen.dart';
import '../modules/emergency/home_dashboard_screen.dart';
import '../modules/emergency/emergency_sos_screen.dart';
import '../modules/emergency/emergency_type_screen.dart';
import '../modules/emergency/live_location_screen.dart';
import '../modules/emergency/emergency_confirmation_screen.dart';
import '../modules/emergency/emergency_tracking_screen.dart';
import '../modules/location/nearby_help_screen.dart';
import '../modules/location/navigation_screen.dart';
import '../modules/location/safe_route_screen.dart';
import '../modules/location/offline_maps_screen.dart';
import '../modules/location/location_settings_screen.dart';
import '../modules/alerts/safety_alerts_screen.dart';
import '../modules/alerts/crime_warning_screen.dart';
import '../modules/alerts/weather_alert_screen.dart';
import '../modules/alerts/travel_advisory_screen.dart';
import '../modules/alerts/notification_settings_screen.dart';
import '../modules/medical/medical_profile_screen.dart';
import '../modules/medical/edit_medical_screen.dart';
import '../modules/medical/emergency_medical_contact_screen.dart';
import '../modules/medical/health_data_sharing_screen.dart';
import '../modules/documents/document_vault_screen.dart';
import '../modules/documents/upload_document_screen.dart';
import '../modules/documents/view_document_screen.dart';
import '../modules/documents/delete_document_screen.dart';
import '../modules/checkin/safety_checkin_screen.dart';
import '../modules/checkin/auto_checkin_settings_screen.dart';
import '../modules/checkin/missed_checkin_screen.dart';
import '../modules/checkin/travel_activity_screen.dart';
import '../modules/offline/offline_data_screen.dart';
import '../modules/offline/download_contacts_screen.dart';
import '../modules/offline/sms_config_screen.dart';
import '../modules/settings/privacy_security_screen.dart';
import '../modules/settings/biometric_setup_screen.dart';
import '../modules/settings/change_password_screen.dart';
import '../modules/settings/delete_account_screen.dart';
import '../modules/settings/about_support_screen.dart';
import '../modules/settings/faq_screen.dart';

abstract final class AppRoutes {
  // Module 1: User Management
  static const String splash = '/';
  static const String languageSelect = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otp-verify';
  static const String profile = '/profile';

  // Module 2: Emergency Management
  static const String home = '/home';
  static const String emergencySos = '/emergency/sos';
  static const String emergencyType = '/emergency/type';
  static const String liveLocation = '/emergency/live-location';
  static const String emergencyConfirm = '/emergency/confirm';
  static const String emergencyTrack = '/emergency/track';

  // Module 3: Location & Navigation
  static const String nearbyHelp = '/location/nearby';
  static const String navigation = '/location/navigate';
  static const String safeRoute = '/location/safe-route';
  static const String offlineMaps = '/location/offline-maps';
  static const String locationSettings = '/location/settings';

  // Module 4: Safety Alerts
  static const String safetyAlerts = '/alerts/safety';
  static const String crimeWarning = '/alerts/crime';
  static const String weatherAlert = '/alerts/weather';
  static const String travelAdvisory = '/alerts/advisory';
  static const String notificationSettings = '/alerts/settings';

  // Module 5: Medical
  static const String medicalProfile = '/medical/profile';
  static const String editMedical = '/medical/edit';
  static const String emergencyMedContact = '/medical/contacts';
  static const String healthDataShare = '/medical/share';

  // Module 6: Documents
  static const String documentVault = '/documents/vault';
  static const String uploadDocument = '/documents/upload';
  static const String viewDocument = '/documents/view';
  static const String deleteDocument = '/documents/delete';

  // Module 7: Check-In
  static const String safetyCheckin = '/checkin/safety';
  static const String autoCheckin = '/checkin/auto';
  static const String missedCheckin = '/checkin/missed';
  static const String travelActivity = '/checkin/activity';

  // Module 8: Offline
  static const String offlineData = '/offline/data';
  static const String downloadContacts = '/offline/contacts';
  static const String smsConfig = '/offline/sms';

  // Module 9: Settings
  static const String privacySecurity = '/settings/privacy';
  static const String biometricSetup = '/settings/biometric';
  static const String changePassword = '/settings/password';
  static const String deleteAccount = '/settings/delete-account';
  static const String aboutSupport = '/settings/about';
  static const String faq = '/settings/faq';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        languageSelect: (_) => const LanguageSelectionScreen(),
        onboarding: (_) => const OnboardingScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        otpVerify: (_) => const OtpVerificationScreen(),
        profile: (_) => const ProfileScreen(),
        home: (_) => const HomeDashboardScreen(),
        emergencySos: (_) => const EmergencySosScreen(),
        emergencyType: (_) => const EmergencyTypeScreen(),
        liveLocation: (_) => const LiveLocationScreen(),
        emergencyConfirm: (_) => const EmergencyConfirmationScreen(),
        emergencyTrack: (_) => const EmergencyTrackingScreen(),
        nearbyHelp: (_) => const NearbyHelpScreen(),
        navigation: (_) => const NavigationScreen(),
        safeRoute: (_) => const SafeRouteScreen(),
        offlineMaps: (_) => const OfflineMapsScreen(),
        locationSettings: (_) => const LocationSettingsScreen(),
        safetyAlerts: (_) => const SafetyAlertsScreen(),
        crimeWarning: (_) => const CrimeWarningScreen(),
        weatherAlert: (_) => const WeatherAlertScreen(),
        travelAdvisory: (_) => const TravelAdvisoryScreen(),
        notificationSettings: (_) => const NotificationSettingsScreen(),
        medicalProfile: (_) => const MedicalProfileScreen(),
        editMedical: (_) => const EditMedicalScreen(),
        emergencyMedContact: (_) => const EmergencyMedicalContactScreen(),
        healthDataShare: (_) => const HealthDataSharingScreen(),
        documentVault: (_) => const DocumentVaultScreen(),
        uploadDocument: (_) => const UploadDocumentScreen(),
        viewDocument: (_) => const ViewDocumentScreen(),
        deleteDocument: (_) => const DeleteDocumentScreen(),
        safetyCheckin: (_) => const SafetyCheckinScreen(),
        autoCheckin: (_) => const AutoCheckinSettingsScreen(),
        missedCheckin: (_) => const MissedCheckinScreen(),
        travelActivity: (_) => const TravelActivityScreen(),
        offlineData: (_) => const OfflineDataScreen(),
        downloadContacts: (_) => const DownloadContactsScreen(),
        smsConfig: (_) => const SmsConfigScreen(),
        privacySecurity: (_) => const PrivacySecurityScreen(),
        biometricSetup: (_) => const BiometricSetupScreen(),
        changePassword: (_) => const ChangePasswordScreen(),
        deleteAccount: (_) => const DeleteAccountScreen(),
        aboutSupport: (_) => const AboutSupportScreen(),
        faq: (_) => const FaqScreen(),
      };
}

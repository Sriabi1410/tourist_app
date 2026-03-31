class ApiConfig {
  // Use 10.0.2.2 for Android Emulator connecting to localhost.
  // For physical devices, replace with your computer's local Wi-Fi IP (e.g., '192.168.1.5').
  // For iOS Simulator, 'localhost' usually works, but 127.0.0.1 is standard.
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const String socketUrl = 'http://10.0.2.2:3000';
  static String authToken = '';

  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
      };

  static Map<String, String> get authHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  static const List<String> emergencyNumbers = ['112', '911', '100'];

  static String get apiBaseUrl => '$baseUrl/api';
}

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _shakeToSOS = true;
  bool _autoCheckIn = false;
  bool _fingerprintLock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Marie Thompson', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('ID: TRV-00129 • Nationality: UK', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            activeThumbColor: const Color(0xFFE63946),
            title: const Text('Shake to trigger SOS'),
            subtitle: const Text('Enable emergency trigger by shaking the device'),
            value: _shakeToSOS,
            onChanged: (value) => setState(() => _shakeToSOS = value),
          ),
          SwitchListTile(
            activeThumbColor: const Color(0xFF3B82F6),
            title: const Text('Auto check-in'),
            subtitle: const Text('Periodic location check-ins while traveling'),
            value: _autoCheckIn,
            onChanged: (value) => setState(() => _autoCheckIn = value),
          ),
          SwitchListTile(
            activeThumbColor: const Color(0xFF10B981),
            title: const Text('Fingerprint / PIN lock'),
            subtitle: const Text('Secure your emergency settings locally'),
            value: _fingerprintLock,
            onChanged: (value) => setState(() => _fingerprintLock = value),
          ),
          const SizedBox(height: 18),
          const ListTile(
            leading: Icon(Icons.data_saver_on_outlined, color: Colors.deepPurple),
            title: Text('Offline data'),
            subtitle: Text('Preferences and sensitive info are stored securely on device'),
          ),
          const ListTile(
            leading: Icon(Icons.sync_outlined, color: Colors.indigo),
            title: Text('Sync settings'),
            subtitle: Text('Cloud sync active when online to keep preferences updated'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/routes.dart';
import '../widgets/action_card.dart';
import '../widgets/status_chip.dart';
import '../services/location_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _locationService = LocationService();
  String _address = 'Fetching location...';
  String _coords = '--, --';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null && mounted) {
        setState(() {
          _coords = '${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E';
          _address = 'Current Position'; 
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = 'Location error';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1F2937)),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLocation,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(context),
              const SizedBox(height: 28),
              _buildQuickActions(context),
              const SizedBox(height: 28),
              _buildFeatureSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  StatusChip(online: true, label: 'Online'),
                  SizedBox(width: 12),
                  Text('Protected', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
              if (_isLoading)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3B82F6))),
            ],
          ),
          const SizedBox(height: 24),
          const Text('CURRENT LOCATION', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(_address, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
          const SizedBox(height: 4),
          Text(_coords, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 20, color: Color(0xFF3B82F6)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Precision GPS active. Real-time safety monitoring is enabled.',
                    style: TextStyle(color: Color(0xFF4B5563), fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: Icons.local_hospital_outlined,
                title: 'Medical Hub',
                subtitle: 'Nearby hospitals',
                onTap: () {},
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ActionCard(
                icon: Icons.share_location_outlined,
                title: 'Live Tracking',
                subtitle: 'Share live position',
                onTap: () => Navigator.pushNamed(context, Routes.locationTracking),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Emergency Center', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.25,
          children: [
            _featureButton(context, icon: Icons.warning_amber_rounded, label: 'SOS', route: Routes.emergencySos, color: const Color(0xFFEF4444)),
            _featureButton(context, icon: Icons.map_outlined, label: 'Tracking', route: Routes.locationTracking, color: const Color(0xFF3B82F6)),
            _featureButton(context, icon: Icons.people_outline, label: 'Contacts', route: Routes.emergencyContacts, color: const Color(0xFF10B981)),
            _featureButton(context, icon: Icons.settings_outlined, label: 'Settings', route: Routes.settings, color: const Color(0xFF6366F1)),
          ],
        ),
      ],
    );
  }

  Widget _featureButton(BuildContext context, {required IconData icon, required String label, required String route, required Color color}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
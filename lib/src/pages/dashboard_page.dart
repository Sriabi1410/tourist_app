import 'package:flutter/material.dart';
import '../utils/routes.dart';
import '../widgets/action_card.dart';
import '../widgets/status_chip.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context),
            const SizedBox(height: 22),
            _buildQuickActions(context),
            const SizedBox(height: 22),
            _buildFeatureSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              StatusChip(online: true, label: 'Online'),
              SizedBox(width: 12),
              Text('Last sync: 2 min ago', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Current location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          const Text('Paris, France', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('48.8566° N, 2.3522° E', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: const Text('Ready for instant help. Limited features active when offline.', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                icon: Icons.group_work_outlined,
                title: 'Find Nearby Help',
                subtitle: 'Hospitals, police, embassies',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ActionCard(
                icon: Icons.share_location_outlined,
                title: 'Share Location',
                subtitle: 'Send your live position',
                onTap: () {
                  Navigator.pushNamed(context, Routes.locationTracking);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ActionCard(
          icon: Icons.book_outlined,
          title: 'Safety Guide',
          subtitle: 'Offline travel safety tips',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Access fast', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _featureButton(context, icon: Icons.warning_amber_outlined, label: 'Emergency SOS', route: Routes.emergencySos, color: const Color(0xFFEC4E4E)),
            _featureButton(context, icon: Icons.location_on_outlined, label: 'Location', route: Routes.locationTracking, color: const Color(0xFF3B82F6)),
            _featureButton(context, icon: Icons.contact_phone_outlined, label: 'Contacts', route: Routes.emergencyContacts, color: const Color(0xFF10B981)),
            _featureButton(context, icon: Icons.settings_outlined, label: 'Settings', route: Routes.settings, color: const Color(0xFF8B5CF6)),
          ],
        ),
      ],
    );
  }

  Widget _featureButton(BuildContext context, {required IconData icon, required String label, required String route, required Color color}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: (MediaQuery.of(context).size.width - 68) / 2,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

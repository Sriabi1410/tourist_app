import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/location_provider.dart';
import '../../widgets/glass_card.dart';

class NearbyHelpScreen extends StatefulWidget {
  const NearbyHelpScreen({super.key});
  @override
  State<NearbyHelpScreen> createState() => _NearbyHelpScreenState();
}

class _NearbyHelpScreenState extends State<NearbyHelpScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadNearbyPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationProvider>();
    var places = loc.nearbyPlaces;
    if (_filter != 'all') places = places.where((p) => p['type'] == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Help'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // Map area
          FadeInDown(
            child: Container(
              height: 220, width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder)),
              child: Stack(children: [
                Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.map_rounded, color: AppColors.primary.withOpacity(0.3), size: 50),
                  const SizedBox(height: 8),
                  const Text('OpenStreetMap View', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text('${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ])),
                Positioned(top: 12, right: 12, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.my_location, color: AppColors.success, size: 14), SizedBox(width: 4),
                    Text('GPS Active', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                  ]),
                )),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _FilterChip(label: 'All', value: 'all', selected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
                _FilterChip(label: '🚔 Police', value: 'police', selected: _filter == 'police', onTap: () => setState(() => _filter = 'police')),
                _FilterChip(label: '🏥 Hospital', value: 'hospital', selected: _filter == 'hospital', onTap: () => setState(() => _filter = 'hospital')),
                _FilterChip(label: '🔥 Fire', value: 'fire', selected: _filter == 'fire', onTap: () => setState(() => _filter = 'fire')),
                _FilterChip(label: '🏛️ Embassy', value: 'embassy', selected: _filter == 'embassy', onTap: () => setState(() => _filter = 'embassy')),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          // Places list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: places.length,
              itemBuilder: (ctx, i) {
                final p = places[i];
                final color = _getTypeColor(p['type']);
                final icon = _getTypeIcon(p['type']);
                return FadeInUp(
                  delay: Duration(milliseconds: 80 * i),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      onTap: () {},
                      child: Row(children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, color: color, size: 22)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p['name'], style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                          Row(children: [
                            Text(p['distance'], style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                            const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                            Text(p['phone'], style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ]),
                        ])),
                        Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.call, color: AppColors.success, size: 18)),
                        const SizedBox(width: 8),
                        Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.info.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.directions, color: AppColors.info, size: 18)),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'police': return AppColors.info;
      case 'hospital': return AppColors.secondary;
      case 'fire': return AppColors.accentWarm;
      case 'embassy': return AppColors.primary;
      default: return AppColors.textMuted;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'police': return Icons.local_police;
      case 'hospital': return Icons.local_hospital;
      case 'fire': return Icons.local_fire_department;
      case 'embassy': return Icons.account_balance;
      default: return Icons.place;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label, value; final bool selected; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.value, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withOpacity(0.12) : AppColors.glassFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.primary : AppColors.glassBorder),
          ),
          child: Text(label, style: TextStyle(color: selected ? AppColors.primary : AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

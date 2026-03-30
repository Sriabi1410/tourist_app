import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class TravelActivityScreen extends StatelessWidget {
  const TravelActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final activities = [
      {'title': 'Visited India Gate', 'time': '10:30 AM', 'distance': '2.1 km', 'icon': Icons.place, 'color': AppColors.primary},
      {'title': 'Walking — Rajpath', 'time': '11:00 AM', 'distance': '0.8 km', 'icon': Icons.directions_walk, 'color': AppColors.secondary},
      {'title': 'Lunch at Restaurant', 'time': '12:30 PM', 'distance': '0.3 km', 'icon': Icons.restaurant, 'color': AppColors.accentWarm},
      {'title': 'Red Fort Visit', 'time': '2:00 PM', 'distance': '3.4 km', 'icon': Icons.museum, 'color': AppColors.accent},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Activity'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: Row(children: [
          Expanded(child: _StatCard(icon: Icons.route, label: 'Distance', value: '6.6 km', color: AppColors.primary)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(icon: Icons.timer, label: 'Active', value: '4h 30m', color: AppColors.secondary)),
          const SizedBox(width: 10),
          Expanded(child: _StatCard(icon: Icons.place, label: 'Places', value: '4', color: AppColors.accentWarm)),
        ])),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Today\'s Activity', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 14),
        ...activities.asMap().entries.map((e) {
          final a = e.value; final color = a['color'] as Color;
          return FadeInUp(delay: Duration(milliseconds: 150 + e.key * 80), child: Padding(padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(a['icon'] as IconData, color: color, size: 20)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a['title'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${a['time']} • ${a['distance']}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ])),
            ]))));
        }),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return GlassCard(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12), child: Column(children: [
      Icon(icon, color: color, size: 22), const SizedBox(height: 6),
      Text(value, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
    ]));
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class WeatherAlertScreen extends StatelessWidget {
  const WeatherAlertScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Alerts'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(gradient: LinearGradient(colors: [AppColors.accentWarm.withOpacity(0.1), AppColors.accentWarm.withOpacity(0.03)]),
          borderColor: AppColors.accentWarm.withOpacity(0.2),
          child: Row(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.accentWarm.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.cloud, color: AppColors.accentWarm, size: 28)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Heavy Rain Warning', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              Text('Expected 40mm rainfall in next 6 hours', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ])),
          ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Current Conditions', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: Row(children: [
          Expanded(child: _WeatherCard(icon: Icons.thermostat, label: 'Temp', value: '28°C', color: AppColors.accent)),
          const SizedBox(width: 10),
          Expanded(child: _WeatherCard(icon: Icons.water_drop, label: 'Humidity', value: '85%', color: AppColors.info)),
          const SizedBox(width: 10),
          Expanded(child: _WeatherCard(icon: Icons.air, label: 'Wind', value: '12 km/h', color: AppColors.secondary)),
        ])),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 200), child: const Text('Safety Tips', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...['Carry an umbrella or raincoat', 'Avoid low-lying flood-prone areas', 'Keep emergency contacts accessible', 'Stay updated with weather reports'].asMap().entries.map((e) =>
          FadeInUp(delay: Duration(milliseconds: 250 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 8), child: GlassCard(padding: const EdgeInsets.all(12),
            child: Row(children: [const Icon(Icons.tips_and_updates, color: AppColors.accentWarm, size: 18), const SizedBox(width: 10),
              Expanded(child: Text(e.value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)))]),
          )))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _WeatherCard({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return GlassCard(padding: const EdgeInsets.symmetric(vertical: 16), child: Column(children: [
      Icon(icon, color: color, size: 24),
      const SizedBox(height: 8),
      Text(value, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
    ]));
  }
}

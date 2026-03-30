import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/location_provider.dart';
import '../../widgets/glass_card.dart';

class LocationSettingsScreen extends StatelessWidget {
  const LocationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Location Settings'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: const Text('GPS & Tracking', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 100), child: _SettingTile(icon: Icons.location_on, title: 'Location Services', subtitle: 'Enable GPS tracking', value: loc.isLocationEnabled, onChanged: (v) => loc.toggleLocationEnabled(v))),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 150), child: _SettingTile(icon: Icons.location_searching, title: 'Background Tracking', subtitle: 'Track location in background', value: loc.backgroundTracking, onChanged: (v) => loc.toggleBackgroundTracking(v))),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 200), child: _SettingTile(icon: Icons.share_location, title: 'Live Sharing', subtitle: 'Share location with contacts', value: loc.isTracking, onChanged: (v) => v ? loc.startTracking() : loc.stopTracking())),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 250), child: const Text('Accuracy', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 300), child: GlassCard(child: Column(children: [
          _AccuracyOption(title: 'High Accuracy', subtitle: 'Uses GPS + WiFi + Mobile', selected: true),
          const Divider(color: AppColors.glassBorder, height: 16),
          _AccuracyOption(title: 'Battery Saving', subtitle: 'Uses WiFi + Mobile only', selected: false),
          const Divider(color: AppColors.glassBorder, height: 16),
          _AccuracyOption(title: 'Device Only', subtitle: 'Uses GPS only', selected: false),
        ]))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon; final String title, subtitle; final bool value; final ValueChanged<bool> onChanged;
  const _SettingTile({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return GlassCard(child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 20)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])),
      Switch(value: value, onChanged: onChanged),
    ]));
  }
}

class _AccuracyOption extends StatelessWidget {
  final String title, subtitle; final bool selected;
  const _AccuracyOption({required this.title, required this.subtitle, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Radio(value: selected, groupValue: true, onChanged: (_) {}, activeColor: AppColors.primary),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])),
    ]);
  }
}

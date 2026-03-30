import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: const Text('Alert Types', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 100), child: _ToggleTile(icon: Icons.notifications, title: 'Push Notifications', subtitle: 'Receive all notifications', value: settings.pushNotifications, onChanged: settings.togglePushNotifications, color: AppColors.primary)),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 150), child: _ToggleTile(icon: Icons.report, title: 'Crime Alerts', subtitle: 'Nearby crime reports', value: settings.crimeAlerts, onChanged: settings.toggleCrimeAlerts, color: AppColors.sosRed)),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 200), child: _ToggleTile(icon: Icons.cloud, title: 'Weather Alerts', subtitle: 'Severe weather warnings', value: settings.weatherAlerts, onChanged: settings.toggleWeatherAlerts, color: AppColors.accentWarm)),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 250), child: _ToggleTile(icon: Icons.flag, title: 'Travel Advisories', subtitle: 'Government travel updates', value: settings.travelAdvisories, onChanged: settings.toggleTravelAdvisories, color: AppColors.info)),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 300), child: const Text('Quiet Hours', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 350), child: _ToggleTile(icon: Icons.do_not_disturb, title: 'Quiet Hours', subtitle: '${settings.quietHoursStart} — ${settings.quietHoursEnd}', value: settings.quietHoursEnabled, onChanged: settings.toggleQuietHours, color: AppColors.primary)),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon; final String title, subtitle; final bool value; final ValueChanged<bool> onChanged; final Color color;
  const _ToggleTile({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged, required this.color});
  @override
  Widget build(BuildContext context) {
    return GlassCard(child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])),
      Switch(value: value, onChanged: onChanged),
    ]));
  }
}

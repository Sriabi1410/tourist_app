import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/location_provider.dart';
import '../../core/providers/emergency_provider.dart';
import '../../widgets/glass_card.dart';

class OfflineDataScreen extends StatelessWidget {
  const OfflineDataScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Data'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.08), AppColors.success.withOpacity(0.02)]),
          borderColor: AppColors.success.withOpacity(0.2),
          child: const Row(children: [Icon(Icons.cloud_done, color: AppColors.success, size: 24), SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Synced', style: TextStyle(color: AppColors.success, fontSize: 15, fontWeight: FontWeight.w700)),
              Text('Last sync: 2 minutes ago', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ]))]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Offline Storage', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...[
          {'title': 'Emergency Contacts', 'subtitle': '${context.watch<AuthProvider>().emergencyContacts.length} contacts saved', 'icon': Icons.contacts, 'color': AppColors.primary, 'meta': '24 KB'},
          {'title': 'Offline Maps', 'subtitle': '2 regions downloaded', 'icon': Icons.map, 'color': AppColors.info, 'meta': '97 MB'},
          {'title': 'Safety Guides', 'subtitle': '5 guides cached', 'icon': Icons.menu_book, 'color': AppColors.secondary, 'meta': '3.2 MB'},
          {'title': 'Location Logs', 'subtitle': '${context.watch<LocationProvider>().locationHistory.length} entries', 'icon': Icons.location_on, 'color': AppColors.accentWarm, 'meta': '156 KB'},
          {'title': 'Emergency Logs', 'subtitle': '${context.watch<EmergencyProvider>().pendingSosEvents.length} pending uploads', 'icon': Icons.sos, 'color': AppColors.sosRed, 'meta': '${context.watch<EmergencyProvider>().pendingSosEvents.length * 3} KB'},
        ].asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 150 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: (e.value['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(e.value['icon'] as IconData, color: e.value['color'] as Color, size: 20)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value['title'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(e.value['subtitle'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
            Text(e.value['meta'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
          ]))))),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 500), child: Row(children: [
          Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.downloadContacts),
            child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary.withOpacity(0.15))),
              child: const Column(children: [Icon(Icons.download, color: AppColors.primary, size: 22), SizedBox(height: 4), Text('Download', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600))])))),
          const SizedBox(width: 12),
          Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.smsConfig),
            child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.secondary.withOpacity(0.15))),
              child: const Column(children: [Icon(Icons.sms, color: AppColors.secondary, size: 22), SizedBox(height: 4), Text('SMS Config', style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w600))])))),
        ])),
        const SizedBox(height: 30),
      ])),
    );
  }
}

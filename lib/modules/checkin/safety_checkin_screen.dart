import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/checkin_provider.dart';
import '../../core/providers/location_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class SafetyCheckinScreen extends StatelessWidget {
  const SafetyCheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    final loc = context.watch<LocationProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Check-In'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.settings, size: 22), onPressed: () => Navigator.pushNamed(context, AppRoutes.autoCheckin))]),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
        const SizedBox(height: 20),
        FadeInDown(child: GestureDetector(
          onTap: () { checkin.checkIn(lat: loc.latitude, lng: loc.longitude); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check-in sent! You're safe ✓"))); },
          child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.secondaryGradient,
            boxShadow: [BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)]),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_rounded, color: Colors.white, size: 48),
              SizedBox(height: 4),
              Text("I'm Safe", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            ])),
        )),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: GlassCard(child: Row(children: [
          const Icon(Icons.access_time, color: AppColors.primary, size: 20), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Last Check-In', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            Text(checkin.lastCheckin != null ? '${checkin.lastCheckin!.hour}:${checkin.lastCheckin!.minute.toString().padLeft(2, '0')}' : 'No check-ins yet',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: const Text('Safe', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700))),
        ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 200), child: const Align(alignment: Alignment.centerLeft, child: Text('Check-In History', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 12),
        if (checkin.checkinHistory.isEmpty) FadeInUp(delay: const Duration(milliseconds: 250), child: GlassCard(child: const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No check-ins yet. Tap the button above!', style: TextStyle(color: AppColors.textMuted, fontSize: 13))))))
        else ...checkin.checkinHistory.asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 250 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(padding: const EdgeInsets.all(12), child: Row(children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(e.value['message'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
            Text(e.value['type'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ]))))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

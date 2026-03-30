import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/checkin_provider.dart';
import '../../widgets/glass_card.dart';

class AutoCheckinSettingsScreen extends StatelessWidget {
  const AutoCheckinSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Auto Check-In'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.schedule, color: AppColors.primary, size: 22)),
          const SizedBox(width: 14),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Auto Check-In', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            Text('Automatically send check-ins', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ])),
          Switch(value: checkin.autoCheckinEnabled, onChanged: (v) => checkin.setAutoCheckin(v)),
        ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Check-In Interval', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...[30, 60, 120, 240].asMap().entries.map((e) {
          final mins = e.value; final label = mins < 60 ? '$mins min' : '${mins ~/ 60} hour${mins > 60 ? 's' : ''}';
          return FadeInUp(delay: Duration(milliseconds: 150 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(onTap: () => checkin.setCheckinInterval(mins),
              child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                borderColor: checkin.checkinIntervalMinutes == mins ? AppColors.primary.withOpacity(0.4) : null,
                child: Row(children: [
                  Radio(value: mins, groupValue: checkin.checkinIntervalMinutes, onChanged: (v) => checkin.setCheckinInterval(v!), activeColor: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Every $label', style: TextStyle(color: checkin.checkinIntervalMinutes == mins ? AppColors.primary : AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                ])))));
        }),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 400), child: GlassCard(
          gradient: LinearGradient(colors: [AppColors.accentWarm.withOpacity(0.08), AppColors.accentWarm.withOpacity(0.02)]),
          child: const Row(children: [Icon(Icons.info_outline, color: AppColors.accentWarm, size: 18), SizedBox(width: 10),
            Expanded(child: Text('If you miss a check-in, your emergency contacts will be notified automatically.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)))]))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

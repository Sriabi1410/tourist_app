import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class MissedCheckinScreen extends StatelessWidget {
  const MissedCheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Missed Check-In'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FadeInDown(child: Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.accentWarm.withOpacity(0.15), borderRadius: BorderRadius.circular(28)),
          child: const Icon(Icons.warning_amber_rounded, color: AppColors.accentWarm, size: 48))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Missed Check-In!', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800))),
        const SizedBox(height: 8),
        FadeInUp(delay: const Duration(milliseconds: 150), child: const Text('You missed your scheduled check-in.\nYour contacts will be alerted if you don\'t respond.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 14))),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 200), child: GlassCard(
          gradient: LinearGradient(colors: [AppColors.sosRed.withOpacity(0.08), AppColors.sosRed.withOpacity(0.02)]),
          child: const Row(children: [Icon(Icons.timer, color: AppColors.sosRed, size: 20), SizedBox(width: 10),
            Text('Contacts notified in 5 minutes', style: TextStyle(color: AppColors.sosRed, fontSize: 13, fontWeight: FontWeight.w600))]))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 250), child: GradientButton(text: "I'm Safe — Check In Now", gradient: AppColors.secondaryGradient, icon: Icons.check_circle, onPressed: () => Navigator.pop(context))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 300), child: GradientButton(text: 'I Need Help', gradient: AppColors.sosGradient, icon: Icons.sos, onPressed: () {})),
      ])),
    );
  }
}

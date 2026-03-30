import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/custom_text_field.dart';

class SmsConfigScreen extends StatelessWidget {
  const SmsConfigScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS SOS Config'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(
          gradient: LinearGradient(colors: [AppColors.info.withOpacity(0.08), AppColors.info.withOpacity(0.02)]),
          child: const Row(children: [Icon(Icons.info_outline, color: AppColors.info, size: 20), SizedBox(width: 10),
            Expanded(child: Text('When offline, SOS alerts will be sent via SMS to your trusted contacts.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)))]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('SMS Message Template', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: GlassCard(child: const Text(
          '🆘 EMERGENCY! I need help.\nLocation: {GPS_COORDINATES}\nUser: {USER_NAME}\nID: {USER_ID}\nSent from SafeRoam App',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'monospace', height: 1.6)))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 200), child: const Text('Trusted SMS Numbers', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...['+91 98765 43210', '+91 91234 56789'].asMap().entries.map((e) =>
          FadeInUp(delay: Duration(milliseconds: 250 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(children: [
              const Icon(Icons.phone, color: AppColors.success, size: 18), const SizedBox(width: 12),
              Text(e.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
              const Spacer(),
              const Icon(Icons.close, color: AppColors.textMuted, size: 18),
            ]))))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 400), child: GradientButton(text: 'Add Trusted Number', icon: Icons.add, outlined: true, onPressed: () {})),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 450), child: GradientButton(text: 'Send Test SMS', icon: Icons.sms, gradient: AppColors.secondaryGradient, onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test SMS sent successfully!')));
        })),
        const SizedBox(height: 30),
      ])),
    );
  }
}

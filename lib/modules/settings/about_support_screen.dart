import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class AboutSupportScreen extends StatelessWidget {
  const AboutSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About & Support'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
        const SizedBox(height: 24),
        FadeInDown(child: Container(width: 80, height: 80, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(22)),
          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 40))),
        const SizedBox(height: 16),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('SafeRoam', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800))),
        FadeInUp(delay: const Duration(milliseconds: 120), child: const Text('v1.0.0 • Tourist Safety App', style: TextStyle(color: AppColors.textMuted, fontSize: 13))),
        const SizedBox(height: 24),
        ...[ ('Contact Support', 'support@saferoam.app', Icons.email_outlined, AppColors.primary),
             ('Rate the App', 'Share your feedback', Icons.star_outline, AppColors.accentWarm),
             ('Privacy Policy', 'Read our privacy policy', Icons.privacy_tip_outlined, AppColors.info),
             ('Terms of Service', 'Read our terms', Icons.description_outlined, AppColors.secondary),
             ('Open Source Licenses', 'Third-party licenses', Icons.code, AppColors.primary),
        ].asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 150 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: e.value.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(e.value.$3, color: e.value.$4, size: 20)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value.$1, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(e.value.$2, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ]))))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 500), child: const Text('Made with ❤️ for tourist safety', style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

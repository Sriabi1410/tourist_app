import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class TravelAdvisoryScreen extends StatelessWidget {
  const TravelAdvisoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Advisory'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.03)]),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(Icons.flag, color: AppColors.primary, size: 24), SizedBox(width: 10),
              Text('India — Level 2', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))]),
            SizedBox(height: 8),
            Text('Exercise Increased Caution', style: TextStyle(color: AppColors.accentWarm, fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text('Travelers should exercise increased caution due to crime and terrorism risks in certain regions.', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Regional Advisories', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...[ ('Delhi NCR', 'Exercise normal caution', AppColors.success, 'Level 1'),
             ('Kashmir Region', 'Reconsider travel', AppColors.sosRed, 'Level 3'),
             ('Goa', 'Exercise normal caution', AppColors.success, 'Level 1'),
             ('Mumbai', 'Exercise increased caution', AppColors.accentWarm, 'Level 2'),
        ].asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 150 + e.key * 80), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value.$1, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(e.value.$2, style: TextStyle(color: e.value.$3, fontSize: 12)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: e.value.$3.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(e.value.$4, style: TextStyle(color: e.value.$3, fontSize: 11, fontWeight: FontWeight.w700))),
          ]))))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

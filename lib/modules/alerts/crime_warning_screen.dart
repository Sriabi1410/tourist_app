import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class CrimeWarningScreen extends StatelessWidget {
  const CrimeWarningScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crime Warnings'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder)),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.map, color: AppColors.sosRed.withOpacity(0.3), size: 50),
            const SizedBox(height: 8),
            const Text('Crime Heatmap', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ])))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Recent Reports', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...[
          ('Pickpocketing', 'Connaught Place', '30 min ago', AppColors.sosRed),
          ('Tourist Scam', 'Red Fort', '2 hrs ago', AppColors.accentWarm),
          ('Bag Snatching', 'Karol Bagh', '5 hrs ago', AppColors.accent),
        ].asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 150 + e.key * 80), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: e.value.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.report, color: e.value.$4, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value.$1, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
              Text('${e.value.$2} • ${e.value.$3}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
          ]))))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

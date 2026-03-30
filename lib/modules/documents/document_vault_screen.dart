import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class DocumentVaultScreen extends StatelessWidget {
  const DocumentVaultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final docs = [
      {'name': 'Passport', 'type': 'passport', 'date': 'Mar 15, 2026', 'icon': Icons.book, 'color': AppColors.primary},
      {'name': 'Travel Visa', 'type': 'visa', 'date': 'Mar 10, 2026', 'icon': Icons.card_membership, 'color': AppColors.secondary},
      {'name': 'Travel Insurance', 'type': 'insurance', 'date': 'Mar 5, 2026', 'icon': Icons.health_and_safety, 'color': AppColors.info},
      {'name': 'Hotel Booking', 'type': 'booking', 'date': 'Mar 1, 2026', 'icon': Icons.hotel, 'color': AppColors.accentWarm},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Document Vault'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [Container(margin: const EdgeInsets.only(right: 16), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.lock, color: AppColors.success, size: 14), SizedBox(width: 4),
            Text('Encrypted', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600))]))]),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('4 Documents', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            Text('Securely stored & encrypted', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.folder_special, color: AppColors.primary, size: 24)),
        ]))),
        const SizedBox(height: 20),
        ...docs.asMap().entries.map((e) {
          final d = e.value; final color = d['color'] as Color;
          return FadeInUp(delay: Duration(milliseconds: 100 + e.key * 60), child: Padding(padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.viewDocument),
              child: Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(d['icon'] as IconData, color: color, size: 22)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d['name'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('Added ${d['date']}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
              ]))));
        }),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 400), child: GradientButton(text: 'Upload Document', icon: Icons.upload_file, onPressed: () => Navigator.pushNamed(context, AppRoutes.uploadDocument))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

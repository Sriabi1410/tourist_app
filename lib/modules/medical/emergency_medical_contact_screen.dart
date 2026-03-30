import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class EmergencyMedicalContactScreen extends StatelessWidget {
  const EmergencyMedicalContactScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Dr. Rahul Sharma', 'type': 'Primary Doctor', 'phone': '+91 98765 43210', 'icon': Icons.person, 'color': AppColors.primary},
      {'name': 'Apollo Hospital', 'type': 'Hospital', 'phone': '+91 11 2692 5858', 'icon': Icons.local_hospital, 'color': AppColors.secondary},
      {'name': 'Star Health Insurance', 'type': 'Insurance', 'phone': '1800 102 4477', 'icon': Icons.health_and_safety, 'color': AppColors.info},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Contacts'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        ...contacts.asMap().entries.map((e) {
          final c = e.value; final color = c['color'] as Color;
          return FadeInUp(delay: Duration(milliseconds: 80 * e.key), child: Padding(padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(c['icon'] as IconData, color: color, size: 22)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['name'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text('${c['type']} • ${c['phone']}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ])),
              Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.call, color: AppColors.success, size: 18)),
            ]))));
        }),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 300), child: GradientButton(text: 'Add Medical Contact', icon: Icons.add, outlined: true, onPressed: () {})),
        const SizedBox(height: 30),
      ])),
    );
  }
}

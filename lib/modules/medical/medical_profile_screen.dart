import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/medical_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class MedicalProfileScreen extends StatelessWidget {
  const MedicalProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final med = context.watch<MedicalProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Profile'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.edit_outlined, size: 22), onPressed: () => Navigator.pushNamed(context, AppRoutes.editMedical))]),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: Container(width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.1), AppColors.accent.withOpacity(0.03)]), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.accent.withOpacity(0.2))),
          child: Column(children: [
            Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.medical_information, color: AppColors.accent, size: 32)),
            const SizedBox(height: 12),
            const Text('Medical ID Card', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Blood Type: ${med.bloodType.isNotEmpty ? med.bloodType : "Not Set"}', style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w600)),
          ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Medical Details', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: GlassCard(child: Column(children: [
          _InfoRow(icon: Icons.bloodtype, label: 'Blood Type', value: med.bloodType.isNotEmpty ? med.bloodType : 'Not set'),
          const Divider(color: AppColors.glassBorder, height: 20),
          _InfoRow(icon: Icons.warning_amber, label: 'Allergies', value: med.allergies.isNotEmpty ? med.allergies : 'None'),
          const Divider(color: AppColors.glassBorder, height: 20),
          _InfoRow(icon: Icons.medication, label: 'Medications', value: med.medications.isNotEmpty ? med.medications : 'None'),
          const Divider(color: AppColors.glassBorder, height: 20),
          _InfoRow(icon: Icons.healing, label: 'Conditions', value: med.conditions.isNotEmpty ? med.conditions : 'None'),
        ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 200), child: const Text('Insurance', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 250), child: GlassCard(child: Column(children: [
          _InfoRow(icon: Icons.health_and_safety, label: 'Provider', value: med.insuranceProvider.isNotEmpty ? med.insuranceProvider : 'Not set'),
          const Divider(color: AppColors.glassBorder, height: 20),
          _InfoRow(icon: Icons.numbers, label: 'Policy #', value: med.insuranceNumber.isNotEmpty ? med.insuranceNumber : 'Not set'),
        ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 300), child: Row(children: [
          Expanded(child: GradientButton(text: 'Edit Profile', icon: Icons.edit, onPressed: () => Navigator.pushNamed(context, AppRoutes.editMedical))),
          const SizedBox(width: 12),
          Expanded(child: GradientButton(text: 'Share', icon: Icons.qr_code, gradient: AppColors.secondaryGradient, onPressed: () => Navigator.pushNamed(context, AppRoutes.healthDataShare))),
        ])),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: AppColors.primary, size: 18), const SizedBox(width: 12),
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      const Spacer(),
      Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
    ]);
  }
}

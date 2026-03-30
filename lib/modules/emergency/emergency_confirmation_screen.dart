import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glass_card.dart';

class EmergencyConfirmationScreen extends StatelessWidget {
  const EmergencyConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Emergency'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.sosRed.withOpacity(0.1), AppColors.sosRed.withOpacity(0.03)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.sosRed.withOpacity(0.2)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.sosRed, size: 48),
                    SizedBox(height: 12),
                    Text('Confirm Emergency Alert', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                    SizedBox(height: 6),
                    Text('This will notify emergency services\nand your trusted contacts', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Emergency Details', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 150),
              child: GlassCard(
                child: Column(
                  children: [
                    _DetailRow(icon: Icons.category, label: 'Type', value: 'Medical Emergency'),
                    const Divider(color: AppColors.glassBorder, height: 20),
                    _DetailRow(icon: Icons.location_on, label: 'Location', value: '28.6139°N, 77.2090°E'),
                    const Divider(color: AppColors.glassBorder, height: 20),
                    _DetailRow(icon: Icons.access_time, label: 'Time', value: 'Now'),
                    const Divider(color: AppColors.glassBorder, height: 20),
                    _DetailRow(icon: Icons.signal_cellular_alt, label: 'Mode', value: 'Online (Internet)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 200), child: const Text('Will be notified', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  _ContactNotify(icon: Icons.local_police, name: 'Local Police (100)', color: AppColors.info),
                  const SizedBox(height: 8),
                  _ContactNotify(icon: Icons.local_hospital, name: 'Ambulance (102)', color: AppColors.secondary),
                  const SizedBox(height: 8),
                  _ContactNotify(icon: Icons.person, name: 'Emergency Contact 1', color: AppColors.accentWarm),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: GradientButton(
                text: 'SEND EMERGENCY ALERT',
                gradient: AppColors.sosGradient,
                icon: Icons.sos_rounded,
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.emergencySos),
              ),
            ),
            const SizedBox(height: 14),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              child: GradientButton(
                text: 'Cancel',
                outlined: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ContactNotify extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  const _ContactNotify({required this.icon, required this.name, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Icon(Icons.notifications_active, color: color, size: 18),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../widgets/glass_card.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: const Text('Privacy & Security', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...[
          ('Biometric Lock', 'Fingerprint / Face ID', Icons.fingerprint, AppRoutes.biometricSetup, AppColors.primary),
          ('Change Password', 'Update your password', Icons.lock_outline, AppRoutes.changePassword, AppColors.secondary),
          ('Privacy Controls', 'Data sharing preferences', Icons.privacy_tip, '', AppColors.info),
        ].asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 80 * e.key), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(onTap: () { if (e.value.$4.isNotEmpty) Navigator.pushNamed(context, e.value.$4); },
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: e.value.$5.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(e.value.$3, color: e.value.$5, size: 20)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.value.$1, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(e.value.$2, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ])),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
            ]))))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 250), child: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 300), child: GlassCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notificationSettings),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.accentWarm.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.notifications_outlined, color: AppColors.accentWarm, size: 20)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Notification Settings', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text('Manage alert preferences', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 350), child: const Text('Support', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...[
          ('About & Support', 'App info, contact us', Icons.info_outline, AppRoutes.aboutSupport, AppColors.info),
          ('FAQ', 'Frequently asked questions', Icons.help_outline, AppRoutes.faq, AppColors.secondary),
        ].asMap().entries.map((e) => FadeInUp(delay: Duration(milliseconds: 400 + 60 * e.key), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(onTap: () => Navigator.pushNamed(context, e.value.$4),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: e.value.$5.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(e.value.$3, color: e.value.$5, size: 20)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.value.$1, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(e.value.$2, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ])),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
            ]))))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 550), child: GlassCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.deleteAccount),
          borderColor: AppColors.sosRed.withOpacity(0.2),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.sosRed.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.delete_outline, color: AppColors.sosRed, size: 20)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Delete Account', style: TextStyle(color: AppColors.sosRed, fontSize: 14, fontWeight: FontWeight.w600)),
              Text('Permanently remove your data', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
          ]))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

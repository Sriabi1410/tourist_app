import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../widgets/gradient_button.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FadeInDown(child: Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.sosRed.withOpacity(0.12), borderRadius: BorderRadius.circular(22)),
          child: const Icon(Icons.warning_amber, color: AppColors.sosRed, size: 40))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Delete Account?', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: const Text('This will permanently delete:\n• Your profile and data\n• Emergency contacts\n• Medical profile\n• All documents\n\nThis action cannot be undone.',
          textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.6))),
        const SizedBox(height: 30),
        FadeInUp(delay: const Duration(milliseconds: 200), child: GradientButton(text: 'Delete My Account', gradient: AppColors.sosGradient, icon: Icons.delete_forever, onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 250), child: GradientButton(text: 'Keep My Account', outlined: true, onPressed: () => Navigator.pop(context))),
      ])),
    );
  }
}

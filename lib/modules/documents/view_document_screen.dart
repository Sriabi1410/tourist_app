import 'package:flutter/material.dart';
import '../../app/colors.dart';
import '../../widgets/gradient_button.dart';

class ViewDocumentScreen extends StatelessWidget {
  const ViewDocumentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Document'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.share, size: 22), onPressed: () {}), IconButton(icon: const Icon(Icons.download, size: 22), onPressed: () {})]),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
        const SizedBox(height: 12),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder)),
          child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.description, color: AppColors.primary, size: 64),
            SizedBox(height: 12),
            Text('Passport.pdf', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Added Mar 15, 2026 • 2.4 MB', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
        )),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: GradientButton(text: 'Download', icon: Icons.download, onPressed: () {})),
          const SizedBox(width: 12),
          Expanded(child: GradientButton(text: 'Share', icon: Icons.share, gradient: AppColors.secondaryGradient, onPressed: () {})),
        ]),
        const SizedBox(height: 24),
      ])),
    );
  }
}

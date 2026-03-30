import 'package:flutter/material.dart';
import '../../app/colors.dart';
import '../../widgets/gradient_button.dart';

class DeleteDocumentScreen extends StatelessWidget {
  const DeleteDocumentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Document'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.sosRed.withOpacity(0.12), borderRadius: BorderRadius.circular(22)),
          child: const Icon(Icons.delete_forever, color: AppColors.sosRed, size: 40)),
        const SizedBox(height: 24),
        const Text('Delete Document?', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('This action cannot be undone.\nThe document will be permanently removed.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        const SizedBox(height: 32),
        GradientButton(text: 'Delete Permanently', gradient: AppColors.sosGradient, icon: Icons.delete, onPressed: () { Navigator.pop(context); }),
        const SizedBox(height: 12),
        GradientButton(text: 'Cancel', outlined: true, onPressed: () => Navigator.pop(context)),
      ])),
    );
  }
}

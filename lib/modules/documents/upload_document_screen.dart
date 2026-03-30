import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});
  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  String _selectedType = 'Passport';
  final _types = ['Passport', 'Visa', 'Insurance', 'ID Card', 'Booking', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Document'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GestureDetector(
          onTap: () {},
          child: Container(height: 200, width: double.infinity,
            decoration: BoxDecoration(color: AppColors.glassFill, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, style: BorderStyle.solid, width: 1.5)),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 48),
              SizedBox(height: 12),
              Text('Tap to upload document', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Camera or Gallery • PDF, JPG, PNG', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ]),
          ),
        )),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Document Type', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: Wrap(spacing: 8, runSpacing: 8, children: _types.map((t) => GestureDetector(
          onTap: () => setState(() => _selectedType = t),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _selectedType == t ? AppColors.primary.withOpacity(0.12) : AppColors.glassFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _selectedType == t ? AppColors.primary : AppColors.glassBorder)),
            child: Text(t, style: TextStyle(color: _selectedType == t ? AppColors.primary : AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        )).toList())),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 200), child: Row(children: [
          Expanded(child: _UploadOption(icon: Icons.camera_alt, label: 'Camera', color: AppColors.primary, onTap: () {})),
          const SizedBox(width: 12),
          Expanded(child: _UploadOption(icon: Icons.photo_library, label: 'Gallery', color: AppColors.secondary, onTap: () {})),
          const SizedBox(width: 12),
          Expanded(child: _UploadOption(icon: Icons.picture_as_pdf, label: 'File', color: AppColors.accent, onTap: () {})),
        ])),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 300), child: GradientButton(text: 'Upload & Encrypt', icon: Icons.lock, onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document uploaded successfully'))); })),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _UploadOption({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.15))),
      child: Column(children: [Icon(icon, color: color, size: 24), const SizedBox(height: 6), Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600))])));
  }
}

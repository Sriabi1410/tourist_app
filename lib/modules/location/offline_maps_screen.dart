import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class OfflineMapsScreen extends StatelessWidget {
  const OfflineMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final regions = [
      {'name': 'New Delhi', 'size': '45 MB', 'downloaded': true},
      {'name': 'Mumbai', 'size': '52 MB', 'downloaded': true},
      {'name': 'Bangalore', 'size': '38 MB', 'downloaded': false},
      {'name': 'Goa', 'size': '22 MB', 'downloaded': false},
      {'name': 'Jaipur', 'size': '28 MB', 'downloaded': false},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Maps'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: GlassCard(child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.info.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.sd_storage, color: AppColors.info, size: 22)),
          const SizedBox(width: 14),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Storage Used', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            Text('97 MB of 500 MB', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          const Text('19%', style: TextStyle(color: AppColors.info, fontSize: 16, fontWeight: FontWeight.w700)),
        ]))),
        const SizedBox(height: 6),
        FadeInDown(delay: const Duration(milliseconds: 50), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: 0.19, backgroundColor: AppColors.glassFill, valueColor: const AlwaysStoppedAnimation(AppColors.info), minHeight: 4)))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Map Regions', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        ...regions.asMap().entries.map((e) {
          final i = e.key; final r = e.value;
          final downloaded = r['downloaded'] as bool;
          return FadeInUp(delay: Duration(milliseconds: 150 + i * 60), child: Padding(padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(
                color: (downloaded ? AppColors.success : AppColors.primary).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(downloaded ? Icons.check_circle : Icons.download_rounded, color: downloaded ? AppColors.success : AppColors.primary, size: 20)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['name'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(r['size'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ])),
              if (downloaded) GestureDetector(
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.sosRed.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Delete', style: TextStyle(color: AppColors.sosRed, fontSize: 11, fontWeight: FontWeight.w600))))
              else GestureDetector(
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Download', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)))),
            ]))));
        }),
        const SizedBox(height: 30),
      ])),
    );
  }
}

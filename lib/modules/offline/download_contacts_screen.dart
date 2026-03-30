import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class DownloadContactsScreen extends StatelessWidget {
  const DownloadContactsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final countries = [
      {'name': 'India', 'flag': '🇮🇳', 'contacts': 8, 'downloaded': true},
      {'name': 'United States', 'flag': '🇺🇸', 'contacts': 6, 'downloaded': false},
      {'name': 'United Kingdom', 'flag': '🇬🇧', 'contacts': 5, 'downloaded': false},
      {'name': 'Thailand', 'flag': '🇹🇭', 'contacts': 7, 'downloaded': false},
      {'name': 'Japan', 'flag': '🇯🇵', 'contacts': 6, 'downloaded': false},
      {'name': 'Australia', 'flag': '🇦🇺', 'contacts': 5, 'downloaded': false},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), itemCount: countries.length, itemBuilder: (ctx, i) {
        final c = countries[i]; final dl = c['downloaded'] as bool;
        return FadeInUp(delay: Duration(milliseconds: 60 * i), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(child: Row(children: [
            Text(c['flag'] as String, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['name'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text('${c['contacts']} emergency numbers', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
            GestureDetector(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(
              color: (dl ? AppColors.success : AppColors.primary).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(dl ? '✓ Saved' : 'Download', style: TextStyle(color: dl ? AppColors.success : AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)))),
          ]))));
      }),
    );
  }
}

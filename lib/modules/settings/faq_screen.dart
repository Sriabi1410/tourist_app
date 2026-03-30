import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int _expanded = -1;
  final _faqs = const [
    ('How does offline SOS work?', 'When you have no internet connection, SafeRoam sends emergency alerts via SMS to your pre-configured trusted contacts. The SMS includes your last known GPS coordinates, your name and ID.'),
    ('Is my data secure?', 'Yes! All data is encrypted using AES-256 encryption both on your device and in the cloud. Biometric authentication adds an extra layer of security.'),
    ('How accurate is GPS tracking?', 'GPS accuracy depends on your device and environment. In open areas, accuracy is typically 3-5 meters. In urban areas, it may vary between 10-30 meters.'),
    ('Can I use SafeRoam without internet?', 'Yes! SafeRoam is designed with offline-first architecture. SOS via SMS, cached maps, saved emergency contacts, and downloaded safety guides all work without internet.'),
    ('How do I add emergency contacts?', 'Go to Profile → Emergency Contacts → Add Contact. You can add up to 5 emergency contacts who will be notified during SOS alerts.'),
    ('What happens during a missed check-in?', 'If auto check-in is enabled and you miss a scheduled check-in, SafeRoam will alert you first. If you don\'t respond within 5 minutes, your emergency contacts are notified.'),
    ('Does the app work in all countries?', 'SafeRoam works globally. Download country-specific emergency contacts before traveling for offline access to local emergency numbers.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), itemCount: _faqs.length, itemBuilder: (ctx, i) {
        final isExpanded = _expanded == i;
        return FadeInUp(delay: Duration(milliseconds: 60 * i), child: Padding(padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => setState(() => _expanded = isExpanded ? -1 : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isExpanded ? AppColors.primary.withOpacity(0.06) : AppColors.glassFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isExpanded ? AppColors.primary.withOpacity(0.2) : AppColors.glassBorder),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(_faqs[i].$1, style: TextStyle(color: isExpanded ? AppColors.primary : AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
                  AnimatedRotation(turns: isExpanded ? 0.5 : 0, duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: isExpanded ? AppColors.primary : AppColors.textMuted, size: 22)),
                ]),
                if (isExpanded) ...[
                  const SizedBox(height: 10),
                  Text(_faqs[i].$2, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                ],
              ]),
            ),
          )));
      }),
    );
  }
}

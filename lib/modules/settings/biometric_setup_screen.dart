import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});
  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  bool _fingerprint = false;
  bool _faceId = false;
  bool _pinEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Lock'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 20),
        FadeInDown(child: Center(child: Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(22)),
          child: const Icon(Icons.fingerprint, color: AppColors.primary, size: 42)))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Authentication Methods', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: _AuthTile(icon: Icons.fingerprint, title: 'Fingerprint', subtitle: 'Unlock with fingerprint', value: _fingerprint, onChanged: (v) => setState(() => _fingerprint = v))),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 200), child: _AuthTile(icon: Icons.face, title: 'Face ID', subtitle: 'Unlock with face recognition', value: _faceId, onChanged: (v) => setState(() => _faceId = v))),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 250), child: _AuthTile(icon: Icons.pin, title: 'PIN Code', subtitle: '4-digit PIN fallback', value: _pinEnabled, onChanged: (v) => setState(() => _pinEnabled = v))),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _AuthTile extends StatelessWidget {
  final IconData icon; final String title, subtitle; final bool value; final ValueChanged<bool> onChanged;
  const _AuthTile({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return GlassCard(child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 20)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])),
      Switch(value: value, onChanged: onChanged),
    ]));
  }
}

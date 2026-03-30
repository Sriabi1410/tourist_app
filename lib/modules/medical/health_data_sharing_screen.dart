import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class HealthDataSharingScreen extends StatelessWidget {
  const HealthDataSharingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Data Sharing'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
        const SizedBox(height: 20),
        FadeInDown(child: Container(width: 160, height: 160, decoration: BoxDecoration(color: AppColors.glassFill, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.glassBorder)),
          child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.qr_code_2, color: AppColors.primary, size: 80),
            SizedBox(height: 8),
            Text('Medical QR Code', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ])))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Scan this QR code to access your medical profile in case of emergency.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 13))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 150), child: const Text('Sharing Settings', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 200), child: GlassCard(child: Column(children: [
          _ShareRow(label: 'Blood Type', shared: true),
          const Divider(color: AppColors.glassBorder, height: 16),
          _ShareRow(label: 'Allergies', shared: true),
          const Divider(color: AppColors.glassBorder, height: 16),
          _ShareRow(label: 'Medications', shared: true),
          const Divider(color: AppColors.glassBorder, height: 16),
          _ShareRow(label: 'Insurance Info', shared: false),
        ]))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 300), child: GradientButton(text: 'Share Medical Profile', icon: Icons.share, onPressed: () {})),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _ShareRow extends StatefulWidget {
  final String label; final bool shared;
  const _ShareRow({required this.label, required this.shared});
  @override
  State<_ShareRow> createState() => _ShareRowState();
}
class _ShareRowState extends State<_ShareRow> {
  late bool _val;
  @override
  void initState() { super.initState(); _val = widget.shared; }
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(widget.label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
      const Spacer(),
      Switch(value: _val, onChanged: (v) => setState(() => _val = v)),
    ]);
  }
}

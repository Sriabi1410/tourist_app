import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _mode = 0; // 0=walk, 1=drive

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: Column(children: [
        // Map
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder)),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.navigation_rounded, color: AppColors.primary.withOpacity(0.4), size: 56),
              const SizedBox(height: 10),
              const Text('Turn-by-Turn Navigation', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ])),
          ),
        ),
        // Bottom panel
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              FadeInUp(child: Row(children: [
                _ModeBtn(icon: Icons.directions_walk, label: 'Walk', selected: _mode == 0, onTap: () => setState(() => _mode = 0)),
                const SizedBox(width: 12),
                _ModeBtn(icon: Icons.directions_car, label: 'Drive', selected: _mode == 1, onTap: () => setState(() => _mode = 1)),
              ])),
              const SizedBox(height: 16),
              FadeInUp(delay: const Duration(milliseconds: 100), child: GlassCard(child: Column(children: [
                Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.place, color: AppColors.success, size: 18)),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('City Police Station', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('0.8 km away • ~10 min walk', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ])),
                ]),
              ]))),
              const SizedBox(height: 14),
              FadeInUp(delay: const Duration(milliseconds: 200), child: GradientButton(text: 'Start Navigation', icon: Icons.navigation_rounded, onPressed: () {})),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ModeBtn extends StatelessWidget {
  final IconData icon; final String label; final bool selected; final VoidCallback onTap;
  const _ModeBtn({required this.icon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(onTap: onTap, child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withOpacity(0.12) : AppColors.glassFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.primary : AppColors.glassBorder),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: selected ? AppColors.primary : AppColors.textMuted, size: 20),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: selected ? AppColors.primary : AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    )));
  }
}

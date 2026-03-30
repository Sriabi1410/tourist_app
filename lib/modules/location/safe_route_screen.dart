import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class SafeRouteScreen extends StatelessWidget {
  const SafeRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safe Route'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        FadeInDown(child: Container(height: 220, width: double.infinity, decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder)),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.route, color: AppColors.secondary.withOpacity(0.4), size: 50),
            const SizedBox(height: 8),
            const Text('Safe Route Comparison', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])))),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 100), child: const Text('Route Options', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 150), child: _RouteOption(title: 'Safest Route', distance: '1.4 km', time: '18 min', safetyScore: 95, color: AppColors.success, recommended: true)),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 200), child: _RouteOption(title: 'Fastest Route', distance: '0.9 km', time: '11 min', safetyScore: 72, color: AppColors.accentWarm, recommended: false)),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 250), child: _RouteOption(title: 'Alternate Route', distance: '1.8 km', time: '22 min', safetyScore: 88, color: AppColors.info, recommended: false)),
        const SizedBox(height: 20),
        FadeInUp(delay: const Duration(milliseconds: 300), child: const Text('Safety Factors', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(height: 12),
        FadeInUp(delay: const Duration(milliseconds: 350), child: Wrap(spacing: 8, runSpacing: 8, children: [
          _SafetyTag(label: '🔦 Well Lit', color: AppColors.success),
          _SafetyTag(label: '📹 CCTV Coverage', color: AppColors.info),
          _SafetyTag(label: '👮 Police Patrol', color: AppColors.primary),
          _SafetyTag(label: '🏪 Busy Area', color: AppColors.accentWarm),
        ])),
        const SizedBox(height: 30),
      ])),
    );
  }
}

class _RouteOption extends StatelessWidget {
  final String title, distance, time; final int safetyScore; final Color color; final bool recommended;
  const _RouteOption({required this.title, required this.distance, required this.time, required this.safetyScore, required this.color, required this.recommended});
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: recommended ? color.withOpacity(0.4) : null,
      child: Column(children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              if (recommended) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text('Recommended', style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)))],
            ]),
            const SizedBox(height: 4),
            Text('$distance • $time', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
            child: Center(child: Text('$safetyScore', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800))),
          ),
        ]),
      ]),
    );
  }
}

class _SafetyTag extends StatelessWidget {
  final String label; final Color color;
  const _SafetyTag({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.15))),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

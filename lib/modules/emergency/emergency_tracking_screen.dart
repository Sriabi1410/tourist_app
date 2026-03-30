import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/glass_card.dart';

class EmergencyTrackingScreen extends StatefulWidget {
  const EmergencyTrackingScreen({super.key});
  @override
  State<EmergencyTrackingScreen> createState() => _EmergencyTrackingScreenState();
}

class _EmergencyTrackingScreenState extends State<EmergencyTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }
  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Tracking'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            FadeInDown(child: _buildStatusHeader()),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 100), child: _buildResponderCard()),
            const SizedBox(height: 20),
            FadeInUp(delay: const Duration(milliseconds: 200), child: const Text('Timeline', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
            const SizedBox(height: 14),
            ..._buildTimeline(),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Row(
                children: [
                  Expanded(child: _ActionBtn(icon: Icons.call, label: 'Call', color: AppColors.success, onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _ActionBtn(icon: Icons.chat, label: 'Chat', color: AppColors.info, onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _ActionBtn(icon: Icons.cancel, label: 'Cancel', color: AppColors.sosRed, onTap: () => Navigator.pop(context))),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.sosRed.withOpacity(0.1), AppColors.sosRed.withOpacity(0.03)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.sosRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(animation: _pulse, builder: (_, __) => Container(
            width: 50, height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.sosRed.withOpacity(0.15 + _pulse.value * 0.1)),
            child: const Icon(Icons.sos_rounded, color: AppColors.sosRed, size: 24),
          )),
          const SizedBox(width: 14),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Emergency Active', style: TextStyle(color: AppColors.sosRed, fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Help is on the way', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.accentWarm.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: const Text('ETA: 5 min', style: TextStyle(color: AppColors.accentWarm, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildResponderCard() {
    return GlassCard(child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.info.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.local_police, color: AppColors.info, size: 24)),
      const SizedBox(width: 14),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Officer Sharma', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        Text('Delhi Police • Badge #4521', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])),
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.call, color: AppColors.success, size: 20)),
    ]));
  }

  List<Widget> _buildTimeline() {
    final events = [
      ('SOS Alert Sent', '2:30 PM', AppColors.sosRed, true),
      ('Police Notified', '2:30 PM', AppColors.info, true),
      ('Officer Assigned', '2:31 PM', AppColors.success, true),
      ('En Route to Location', '2:32 PM', AppColors.accentWarm, true),
      ('Arrived', 'Pending', AppColors.textMuted, false),
    ];
    return events.asMap().entries.map((e) {
      final i = e.key; final ev = e.value;
      return FadeInLeft(
        delay: Duration(milliseconds: 250 + i * 80),
        child: Padding(padding: const EdgeInsets.only(bottom: 0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: ev.$4 ? ev.$3 : AppColors.glassFill, border: Border.all(color: ev.$3, width: 2))),
            if (i < events.length - 1) Container(width: 2, height: 40, color: ev.$4 ? ev.$3.withOpacity(0.3) : AppColors.glassBorder),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(children: [
            Expanded(child: Text(ev.$1, style: TextStyle(color: ev.$4 ? AppColors.textPrimary : AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600))),
            Text(ev.$2, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ]))),
        ])),
      );
    }).toList();
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  const AnimatedBuilder({super.key, required Animation<double> animation, required this.builder, this.child}) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 4), Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600))]),
    ));
  }
}

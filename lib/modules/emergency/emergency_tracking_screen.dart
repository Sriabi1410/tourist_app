import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/emergency_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyProvider>().fetchActiveEmergency();
    });
  }
  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final emergencyProvider = context.watch<EmergencyProvider>();
    final emergency = emergencyProvider.currentEmergency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Tracking'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: emergency == null
            ? _buildNoActiveEmergency(context)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  FadeInDown(child: _buildStatusHeader(emergency)),
                  const SizedBox(height: 20),
                  FadeInUp(delay: const Duration(milliseconds: 100), child: _buildResponderCard(emergency)),
                  const SizedBox(height: 20),
                  FadeInUp(delay: const Duration(milliseconds: 200), child: const Text('Timeline', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700))),
                  const SizedBox(height: 14),
                  ..._buildTimeline(emergency),
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

  Widget _buildNoActiveEmergency(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.success, size: 72),
            const SizedBox(height: 18),
            const Text('No active emergency', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            const Text('You are currently safe. Trigger SOS if you need immediate assistance.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.sosRed),
              onPressed: () => Navigator.pushNamed(context, '/emergency/sos'),
              child: const Text('Activate SOS', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(EmergencyEvent emergency) {
    final statusColor = emergency.status == EmergencyStatus.resolved ? AppColors.success : AppColors.sosRed;
    final statusLabel = emergency.status == EmergencyStatus.active
        ? 'Emergency Active'
        : emergency.status == EmergencyStatus.responding
            ? 'Responder Assigned'
            : emergency.status == EmergencyStatus.resolved
                ? 'Resolved'
                : 'Alert Sent';
    final subtitle = emergency.status == EmergencyStatus.resolved
        ? 'Help completed successfully'
        : 'Help is on the way';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.03)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(animation: _pulse, builder: (_, __) => Container(
            width: 50, height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor.withOpacity(0.15 + _pulse.value * 0.1)),
            child: Icon(Icons.sos_rounded, color: statusColor, size: 24),
          )),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.accentWarm.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(
              emergency.etaMinutes != null ? 'ETA: ${emergency.etaMinutes} min' : 'Estimating arrival',
              style: const TextStyle(color: AppColors.accentWarm, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponderCard(EmergencyEvent emergency) {
    final responderName = emergency.responderName ?? 'Responder en route';
    final responderMeta = emergency.responderPhone != null
        ? '${emergency.responderPhone} • ETA ${emergency.etaMinutes ?? 0} min'
        : 'Assigned to nearest unit';

    return GlassCard(child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.info.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.local_police, color: AppColors.info, size: 24)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(responderName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        Text(responderMeta, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])),
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.call, color: AppColors.success, size: 20)),
    ]));
  }

  List<Widget> _buildTimeline(EmergencyEvent emergency) {
    final events = [
      ['SOS Alert Sent', emergency.timestamp.toLocal().toString().substring(11, 16), AppColors.sosRed, true],
      ['Police Notified', emergency.timestamp.add(const Duration(minutes: 1)).toLocal().toString().substring(11, 16), AppColors.info, true],
      ['Responder Assigned', emergency.timestamp.add(const Duration(minutes: 2)).toLocal().toString().substring(11, 16), AppColors.success, emergency.status != EmergencyStatus.pending],
      ['En Route to Location', emergency.timestamp.add(const Duration(minutes: 3)).toLocal().toString().substring(11, 16), AppColors.accentWarm, emergency.status == EmergencyStatus.responding || emergency.status == EmergencyStatus.resolved],
      ['Arrived', emergency.status == EmergencyStatus.resolved ? emergency.timestamp.add(const Duration(minutes: 8)).toLocal().toString().substring(11, 16) : 'Pending', AppColors.textMuted, emergency.status == EmergencyStatus.resolved],
    ];
    return events.asMap().entries.map((e) {
      final i = e.key;
      final ev = e.value;
      return FadeInLeft(
        delay: Duration(milliseconds: 250 + i * 80),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: ev[3] as bool ? ev[2] as Color : AppColors.glassFill, border: Border.all(color: ev[2] as Color, width: 2))),
              if (i < events.length - 1)
                Container(width: 2, height: 40, color: ev[3] as bool ? (ev[2] as Color).withOpacity(0.3) : AppColors.glassBorder),
            ]),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(children: [
                  Expanded(child: Text(ev[0] as String, style: TextStyle(color: ev[3] as bool ? AppColors.textPrimary : AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600))),
                  Text(ev[1] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ])),
            ),
          ]),
        ),
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

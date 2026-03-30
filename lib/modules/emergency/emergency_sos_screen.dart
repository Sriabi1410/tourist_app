import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/emergency_provider.dart';
import '../../core/providers/location_provider.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _countdownController;
  int _countdown = 3;
  bool _isActivated = false;
  bool _isCounting = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted) _activateSOS();
  }

  void _activateSOS() {
    setState(() {
      _isActivated = true;
      _isCounting = false;
    });
    HapticFeedback.heavyImpact();
    final emergency = context.read<EmergencyProvider>();
    final location = context.read<LocationProvider>();
    emergency.triggerSos(
      type: EmergencyType.other,
      lat: location.latitude,
      lng: location.longitude,
    );
  }

  void _cancel() {
    context.read<EmergencyProvider>().cancelSos();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isActivated ? const Color(0xFF1A0A0E) : AppColors.bgDark,
      body: SafeArea(
        child: _isCounting ? _buildCountdown() : _buildActivated(),
      ),
    );
  }

  Widget _buildCountdown() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SOS ACTIVATING',
                style: TextStyle(color: AppColors.sosRed, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 3),
              ),
              const SizedBox(height: 40),
              _AnimatedPulse(
                controller: _pulseController,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.sosGradient,
                    boxShadow: [
                      BoxShadow(color: AppColors.sosRed.withOpacity(0.4), blurRadius: 40, spreadRadius: 10),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_countdown',
                      style: const TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Sending emergency alert...',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap Cancel to stop',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 40,
          left: 40,
          right: 40,
          child: GestureDetector(
            onTap: _cancel,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Center(
                child: Text('CANCEL', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivated() {
    final emergency = context.watch<EmergencyProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text('EMERGENCY ACTIVE', style: TextStyle(color: AppColors.sosRed, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2)),
              ),
              GestureDetector(
                onTap: _cancel,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _AnimatedPulse(
            controller: _pulseController,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.sosGradient,
                boxShadow: [
                  BoxShadow(color: AppColors.sosRed.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                ],
              ),
              child: const Icon(Icons.sos_rounded, color: Colors.white, size: 48),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Alert Sent Successfully', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Emergency services have been notified.\nHelp is on the way.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
          const SizedBox(height: 30),
          _StatusCard(icon: Icons.local_police, title: 'Police Notified', subtitle: 'ETA: ~5 minutes', color: AppColors.info),
          const SizedBox(height: 10),
          _StatusCard(icon: Icons.local_hospital, title: 'Ambulance Dispatched', subtitle: 'ETA: ~8 minutes', color: AppColors.secondary),
          const SizedBox(height: 10),
          _StatusCard(icon: Icons.people, title: 'Contacts Alerted', subtitle: '3 emergency contacts notified', color: AppColors.accentWarm),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.emergencyTrack),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(child: Text('Track Response', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.liveLocation),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(child: Text('Share Location', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _AnimatedPulse extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  const _AnimatedPulse({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, _) => Transform.scale(
        scale: 1.0 + controller.value * 0.05,
        child: child,
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  const AnimatedBuilder({super.key, required Animation<double> animation, required this.builder, this.child}) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _StatusCard({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }
}

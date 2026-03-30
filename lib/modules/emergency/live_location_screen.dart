import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/location_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  int _selectedDuration = 1;
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Map placeholder
            FadeInDown(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map_rounded, color: AppColors.primary.withOpacity(0.3), size: 60),
                          const SizedBox(height: 10),
                          const Text('OpenStreetMap', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          Text('${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    // User marker
                    Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on, color: AppColors.info, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Location', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(loc.currentAddress, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const Text('Share Duration', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              child: Row(
                children: [
                  _DurationChip(label: '15 min', value: 0, selected: _selectedDuration == 0, onTap: () => setState(() => _selectedDuration = 0)),
                  const SizedBox(width: 10),
                  _DurationChip(label: '1 hour', value: 1, selected: _selectedDuration == 1, onTap: () => setState(() => _selectedDuration = 1)),
                  const SizedBox(width: 10),
                  _DurationChip(label: '4 hours', value: 2, selected: _selectedDuration == 2, onTap: () => setState(() => _selectedDuration = 2)),
                  const SizedBox(width: 10),
                  _DurationChip(label: 'Until stop', value: 3, selected: _selectedDuration == 3, onTap: () => setState(() => _selectedDuration = 3)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const Text('Share Via', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              child: Row(
                children: [
                  _ShareOption(icon: Icons.sms, label: 'SMS', color: AppColors.success),
                  const SizedBox(width: 12),
                  _ShareOption(icon: Icons.link, label: 'Link', color: AppColors.info),
                  const SizedBox(width: 12),
                  _ShareOption(icon: Icons.share, label: 'Share', color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: GradientButton(
                text: _isSharing ? 'Stop Sharing' : 'Start Sharing Location',
                gradient: _isSharing ? AppColors.sosGradient : AppColors.primaryGradient,
                icon: _isSharing ? Icons.stop_rounded : Icons.share_location_rounded,
                onPressed: () => setState(() => _isSharing = !_isSharing),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  final int value;
  final bool selected;
  final VoidCallback onTap;
  const _DurationChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withOpacity(0.12) : AppColors.glassFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? AppColors.primary : AppColors.glassBorder),
          ),
          child: Center(
            child: Text(label, style: TextStyle(color: selected ? AppColors.primary : AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ShareOption({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

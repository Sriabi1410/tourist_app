import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';

class EmergencyTypeScreen extends StatelessWidget {
  const EmergencyTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final types = [
      _EType(Icons.local_hospital, 'Medical', 'Health emergency', const Color(0xFFFF3B5C)),
      _EType(Icons.local_police, 'Police', 'Crime / threat', const Color(0xFF3B82F6)),
      _EType(Icons.local_fire_department, 'Fire', 'Fire emergency', const Color(0xFFFF8C00)),
      _EType(Icons.storm, 'Natural\nDisaster', 'Earthquake, flood', const Color(0xFF8B5CF6)),
      _EType(Icons.report, 'Theft', 'Robbery / pickpocket', const Color(0xFFEC4899)),
      _EType(Icons.warning_amber, 'Harassment', 'Harassment report', const Color(0xFFF59E0B)),
      _EType(Icons.car_crash, 'Accident', 'Road accident', const Color(0xFFEF4444)),
      _EType(Icons.sos, 'Other', 'General emergency', const Color(0xFF6B7280)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Type'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            FadeInDown(
              child: const Text(
                'What type of\nemergency?',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800, height: 1.2),
              ),
            ),
            const SizedBox(height: 6),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: const Text(
                'Select the type to alert the right services',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemCount: types.length,
                itemBuilder: (context, i) {
                  final t = types[i];
                  return FadeInUp(
                    delay: Duration(milliseconds: 80 * i),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.emergencyConfirm),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: t.color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: t.color.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: t.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(t.icon, color: t.color, size: 24),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.title, style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(t.subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EType {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _EType(this.icon, this.title, this.subtitle, this.color);
}

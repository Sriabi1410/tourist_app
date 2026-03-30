import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/location_provider.dart';
import '../../core/providers/emergency_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/common_widgets.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with TickerProviderStateMixin {
  int _navIndex = 0;
  late AnimationController _sosController;

  @override
  void initState() {
    super.initState();
    _sosController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final auth = context.watch<AuthProvider>();
    final loc = context.watch<LocationProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConnectivityBanner(isOnline: app.isOnline),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    FadeInDown(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${auth.userName.isNotEmpty ? auth.userName : "Tourist"} 👋',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: AppColors.primary, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      loc.currentAddress,
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Safety Status
                    FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      child: GlassCard(
                        gradient: const LinearGradient(
                          colors: [Color(0x1510B981), Color(0x0510B981)],
                        ),
                        borderColor: AppColors.success.withOpacity(0.2),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('You are Safe', style: TextStyle(color: AppColors.success, fontSize: 15, fontWeight: FontWeight.w700)),
                                  Text('No active alerts in your area', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                ],
                              ),
                            ),
                            StatusBadge.safe(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SOS Button
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.emergencyType),
                          onLongPress: () => Navigator.pushNamed(context, AppRoutes.emergencySos),
                          child: AnimatedBuilder2(
                            animation: _sosController,
                            builder: (ctx, _) => Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.sosGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.sosRed.withOpacity(0.25 + _sosController.value * 0.2),
                                    blurRadius: 25 + _sosController.value * 15,
                                    spreadRadius: _sosController.value * 8,
                                  ),
                                ],
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.sos_rounded, color: Colors.white, size: 36),
                                  SizedBox(height: 4),
                                  Text('SOS', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)),
                                  Text('Hold for quick', style: TextStyle(color: Colors.white70, fontSize: 9)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: const SectionHeader(title: 'Quick Actions', icon: Icons.flash_on_rounded),
                    ),
                    const SizedBox(height: 14),
                    FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      child: Row(
                        children: [
                          Expanded(child: _QuickAction(
                            icon: Icons.share_location_rounded,
                            label: 'Share\nLocation',
                            color: AppColors.info,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.liveLocation),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _QuickAction(
                            icon: Icons.local_hospital_rounded,
                            label: 'Nearby\nHelp',
                            color: AppColors.secondary,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.nearbyHelp),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _QuickAction(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'Safety\nCheck-In',
                            color: AppColors.success,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.safetyCheckin),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _QuickAction(
                            icon: Icons.contacts_rounded,
                            label: 'Emergency\nContacts',
                            color: AppColors.accentWarm,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.emergencyMedContact),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Features Grid
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: const SectionHeader(title: 'Safety Features', icon: Icons.security_rounded),
                    ),
                    const SizedBox(height: 14),
                    FadeInUp(
                      delay: const Duration(milliseconds: 450),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _FeatureCard(
                            icon: Icons.notifications_active_rounded,
                            title: 'Safety Alerts',
                            subtitle: '3 active alerts',
                            color: AppColors.accent,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.safetyAlerts),
                          ),
                          _FeatureCard(
                            icon: Icons.medical_information_rounded,
                            title: 'Medical ID',
                            subtitle: 'View profile',
                            color: AppColors.secondary,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.medicalProfile),
                          ),
                          _FeatureCard(
                            icon: Icons.folder_special_rounded,
                            title: 'Documents',
                            subtitle: 'Secure vault',
                            color: AppColors.primary,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.documentVault),
                          ),
                          _FeatureCard(
                            icon: Icons.cloud_off_rounded,
                            title: 'Offline Mode',
                            subtitle: 'Data & maps',
                            color: AppColors.info,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.offlineData),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Activity
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: const SectionHeader(title: 'Recent Activity', icon: Icons.history_rounded),
                    ),
                    const SizedBox(height: 14),
                    FadeInUp(
                      delay: const Duration(milliseconds: 550),
                      child: Column(
                        children: [
                          _ActivityItem(
                            icon: Icons.check_circle,
                            color: AppColors.success,
                            title: 'Safety Check-In',
                            subtitle: 'You checked in as safe',
                            time: '5 min ago',
                          ),
                          const SizedBox(height: 10),
                          _ActivityItem(
                            icon: Icons.location_on,
                            color: AppColors.info,
                            title: 'Location Updated',
                            subtitle: loc.currentAddress,
                            time: '12 min ago',
                          ),
                          const SizedBox(height: 10),
                          _ActivityItem(
                            icon: Icons.download_rounded,
                            color: AppColors.primary,
                            title: 'Maps Downloaded',
                            subtitle: 'Offline map for New Delhi',
                            time: '1 hour ago',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(icon: Icons.home_rounded, label: 'Home', isActive: _navIndex == 0, onTap: () => setState(() => _navIndex = 0)),
              _BottomNavItem(icon: Icons.map_rounded, label: 'Map', isActive: _navIndex == 1, onTap: () {
                setState(() => _navIndex = 1);
                Navigator.pushNamed(context, AppRoutes.nearbyHelp);
              }),
              // SOS Center
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.emergencySos),
                child: AnimatedBuilder2(
                  animation: _sosController,
                  builder: (ctx, _) => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.sosGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sosRed.withOpacity(0.3 + _sosController.value * 0.15),
                          blurRadius: 12,
                          spreadRadius: _sosController.value * 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.sos_rounded, color: Colors.white, size: 26),
                  ),
                ),
              ),
              _BottomNavItem(icon: Icons.notifications_rounded, label: 'Alerts', isActive: _navIndex == 3, onTap: () {
                setState(() => _navIndex = 3);
                Navigator.pushNamed(context, AppRoutes.safetyAlerts);
              }),
              _BottomNavItem(icon: Icons.person_rounded, label: 'Profile', isActive: _navIndex == 4, onTap: () {
                setState(() => _navIndex = 4);
                Navigator.pushNamed(context, AppRoutes.profile);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  const AnimatedBuilder2({super.key, required Animation<double> animation, required this.builder, this.child}) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600, height: 1.3)),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _FeatureCard({required this.icon, required this.title, required this.subtitle, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({required this.icon, required this.color, required this.title, required this.subtitle, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.primary : AppColors.textMuted, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: isActive ? AppColors.primary : AppColors.textMuted, fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

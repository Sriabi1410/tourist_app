import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar section
            FadeInDown(
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bgDark, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Text(
                auth.userName.isNotEmpty ? auth.userName : 'Tourist User',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            FadeInUp(
              delay: const Duration(milliseconds: 150),
              child: Text(
                'ID: ${auth.userId.isNotEmpty ? auth.userId : "USR-XXXX"}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Info cards
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: GlassCard(
                child: Column(
                  children: [
                    _ProfileRow(icon: Icons.email_outlined, label: 'Email', value: auth.userEmail.isNotEmpty ? auth.userEmail : 'user@email.com'),
                    const Divider(color: AppColors.glassBorder, height: 24),
                    _ProfileRow(icon: Icons.phone_outlined, label: 'Phone', value: auth.userPhone.isNotEmpty ? auth.userPhone : '+91 XXXXX XXXXX'),
                    const Divider(color: AppColors.glassBorder, height: 24),
                    _ProfileRow(icon: Icons.flag_outlined, label: 'Nationality', value: auth.nationality.isNotEmpty ? auth.nationality : 'India'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const SectionHeader(
                title: 'Emergency Contacts',
                icon: Icons.contacts_rounded,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              child: GlassCard(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: AppColors.primary, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'Add Emergency Contact',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick links
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  InfoTile(
                    icon: Icons.medical_information_outlined,
                    title: 'Medical Profile',
                    subtitle: 'Blood type, allergies, medications',
                    iconColor: AppColors.accent,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.medicalProfile),
                  ),
                  const SizedBox(height: 10),
                  InfoTile(
                    icon: Icons.folder_outlined,
                    title: 'Document Vault',
                    subtitle: 'Passport, visa, insurance',
                    iconColor: AppColors.accentWarm,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.documentVault),
                  ),
                  const SizedBox(height: 10),
                  InfoTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'Privacy, security, notifications',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.privacySecurity),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            FadeInUp(
              delay: const Duration(milliseconds: 450),
              child: GradientButton(
                text: 'Logout',
                gradient: AppColors.sosGradient,
                icon: Icons.logout_rounded,
                onPressed: () {
                  auth.logout();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

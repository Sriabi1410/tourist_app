import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
        const SizedBox(height: 20),
        FadeInUp(child: const CustomTextField(label: 'Current Password', hint: 'Enter current password', prefixIcon: Icons.lock_outline, obscure: true)),
        const SizedBox(height: 16),
        FadeInUp(delay: const Duration(milliseconds: 80), child: const CustomTextField(label: 'New Password', hint: 'Min 6 characters', prefixIcon: Icons.lock, obscure: true)),
        const SizedBox(height: 16),
        FadeInUp(delay: const Duration(milliseconds: 160), child: const CustomTextField(label: 'Confirm New Password', hint: 'Re-enter new password', prefixIcon: Icons.lock, obscure: true)),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 240), child: GradientButton(text: 'Update Password', icon: Icons.check, onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated'))); })),
        const SizedBox(height: 30),
      ])),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../core/providers/app_provider.dart';
import '../../widgets/gradient_button.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selected = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'flag': '🇺🇸', 'native': 'English'},
    {'name': 'Hindi', 'flag': '🇮🇳', 'native': 'हिन्दी'},
    {'name': 'Spanish', 'flag': '🇪🇸', 'native': 'Español'},
    {'name': 'French', 'flag': '🇫🇷', 'native': 'Français'},
    {'name': 'German', 'flag': '🇩🇪', 'native': 'Deutsch'},
    {'name': 'Japanese', 'flag': '🇯🇵', 'native': '日本語'},
    {'name': 'Arabic', 'flag': '🇸🇦', 'native': 'العربية'},
    {'name': 'Chinese', 'flag': '🇨🇳', 'native': '中文'},
    {'name': 'Portuguese', 'flag': '🇧🇷', 'native': 'Português'},
    {'name': 'Russian', 'flag': '🇷🇺', 'native': 'Русский'},
    {'name': 'Korean', 'flag': '🇰🇷', 'native': '한국어'},
    {'name': 'Italian', 'flag': '🇮🇹', 'native': 'Italiano'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              FadeInDown(
                child: const Text(
                  '🌍',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 16),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: const Text(
                  'Choose Your\nLanguage',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Select your preferred language for the app',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = _selected == lang['name'];
                    return FadeInUp(
                      delay: Duration(milliseconds: 50 * index),
                      duration: const Duration(milliseconds: 400),
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = lang['name']!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.12)
                                : AppColors.glassFill,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.glassBorder,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang['name']!,
                                      style: TextStyle(
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      lang['native']!,
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: GradientButton(
                  text: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    context.read<AppProvider>().setLanguage(_selected);
                    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

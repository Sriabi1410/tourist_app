import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../app/colors.dart';
import '../../core/providers/medical_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class EditMedicalScreen extends StatefulWidget {
  const EditMedicalScreen({super.key});
  @override
  State<EditMedicalScreen> createState() => _EditMedicalScreenState();
}

class _EditMedicalScreenState extends State<EditMedicalScreen> {
  final _blood = TextEditingController();
  final _allergies = TextEditingController();
  final _medications = TextEditingController();
  final _conditions = TextEditingController();
  final _insurance = TextEditingController();
  final _policyNum = TextEditingController();

  @override
  void initState() {
    super.initState();
    final med = context.read<MedicalProvider>();
    _blood.text = med.bloodType; _allergies.text = med.allergies;
    _medications.text = med.medications; _conditions.text = med.conditions;
    _insurance.text = med.insuranceProvider; _policyNum.text = med.insuranceNumber;
  }

  @override
  void dispose() { _blood.dispose(); _allergies.dispose(); _medications.dispose(); _conditions.dispose(); _insurance.dispose(); _policyNum.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Medical Info'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [
        const SizedBox(height: 12),
        FadeInUp(child: CustomTextField(label: 'Blood Type', hint: 'e.g. O+, A-, B+', prefixIcon: Icons.bloodtype, controller: _blood)),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 80), child: CustomTextField(label: 'Allergies', hint: 'e.g. Penicillin, Peanuts', prefixIcon: Icons.warning_amber, controller: _allergies, maxLines: 2)),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 120), child: CustomTextField(label: 'Current Medications', hint: 'e.g. Insulin, Metformin', prefixIcon: Icons.medication, controller: _medications, maxLines: 2)),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 160), child: CustomTextField(label: 'Medical Conditions', hint: 'e.g. Diabetes, Asthma', prefixIcon: Icons.healing, controller: _conditions, maxLines: 2)),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 200), child: CustomTextField(label: 'Insurance Provider', hint: 'Insurance company name', prefixIcon: Icons.health_and_safety, controller: _insurance)),
        const SizedBox(height: 14),
        FadeInUp(delay: const Duration(milliseconds: 240), child: CustomTextField(label: 'Policy Number', hint: 'Policy/Member ID', prefixIcon: Icons.numbers, controller: _policyNum)),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 280), child: GradientButton(text: 'Save Changes', icon: Icons.save_rounded, onPressed: () {
          context.read<MedicalProvider>().updateMedicalProfile(
            bloodType: _blood.text, allergies: _allergies.text, medications: _medications.text,
            conditions: _conditions.text, insuranceProvider: _insurance.text, insuranceNumber: _policyNum.text,
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medical profile updated')));
        })),
        const SizedBox(height: 30),
      ])),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/colors.dart';
import '../../app/routes.dart';
import '../../widgets/glass_card.dart';

class SafetyAlertsScreen extends StatelessWidget {
  const SafetyAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {'title': 'Pickpocket Warning', 'area': 'Connaught Place', 'type': 'crime', 'severity': 'High', 'time': '30 min ago', 'color': AppColors.sosRed},
      {'title': 'Heavy Rain Alert', 'area': 'Central Delhi', 'type': 'weather', 'severity': 'Medium', 'time': '1 hr ago', 'color': AppColors.accentWarm},
      {'title': 'Road Closure', 'area': 'Rajpath', 'type': 'traffic', 'severity': 'Low', 'time': '2 hrs ago', 'color': AppColors.info},
      {'title': 'Tourist Scam Report', 'area': 'Red Fort Area', 'type': 'crime', 'severity': 'Medium', 'time': '3 hrs ago', 'color': AppColors.accent},
      {'title': 'Travel Advisory Update', 'area': 'Delhi NCR', 'type': 'advisory', 'severity': 'Info', 'time': '5 hrs ago', 'color': AppColors.primary},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Safety Alerts'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.settings_outlined, size: 22), onPressed: () => Navigator.pushNamed(context, AppRoutes.notificationSettings))]),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        itemCount: alerts.length,
        itemBuilder: (ctx, i) {
          final a = alerts[i];
          final color = a['color'] as Color;
          return FadeInUp(delay: Duration(milliseconds: 80 * i), child: Padding(padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              borderColor: color.withOpacity(0.2),
              onTap: () {
                if (a['type'] == 'crime') Navigator.pushNamed(context, AppRoutes.crimeWarning);
                else if (a['type'] == 'weather') Navigator.pushNamed(context, AppRoutes.weatherAlert);
                else Navigator.pushNamed(context, AppRoutes.travelAdvisory);
              },
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(_getIcon(a['type'] as String), color: color, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a['title'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(a['area'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                    child: Text(a['severity'] as String, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700))),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.access_time, color: AppColors.textMuted, size: 12),
                  const SizedBox(width: 4),
                  Text(a['time'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ]),
              ]),
            )));
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'crime': return Icons.report;
      case 'weather': return Icons.cloud;
      case 'traffic': return Icons.traffic;
      case 'advisory': return Icons.info_outline;
      default: return Icons.warning;
    }
  }
}

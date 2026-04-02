import 'package:flutter/material.dart';

class LocationTrackingPage extends StatefulWidget {
  const LocationTrackingPage({super.key});

  @override
  State<LocationTrackingPage> createState() => _LocationTrackingPageState();
}

class _LocationTrackingPageState extends State<LocationTrackingPage> {
  bool _shareLive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Tracking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live tracking status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(Icons.map_outlined, size: 72, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Share Live Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Switch(
                  value: _shareLive,
                  onChanged: (value) {
                    setState(() {
                      _shareLive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 8)),
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Speed', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 6),
                  Text('6.4 km/h', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  SizedBox(height: 16),
                  Text('Last known path', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  Text('Offline mode stores points locally and shows last known route.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('Route history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            ...['Start', 'Checkpoint 1', 'Checkpoint 2', 'Current'].map((point) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE63946))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(point, style: const TextStyle(fontSize: 15))),
                    const Text('2 km', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

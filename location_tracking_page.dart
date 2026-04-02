import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationTrackingPage extends StatefulWidget {
  const LocationTrackingPage({super.key});

  @override
  State<LocationTrackingPage> createState() => _LocationTrackingPageState();
}

class _LocationTrackingPageState extends State<LocationTrackingPage> {
  final _locationService = LocationService();
  bool _isTracking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('LIVE TRACKING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.7, -0.6),
                  radius: 1.2,
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
              ),
            ),
          ),
          
          StreamBuilder<Position>(
            stream: _isTracking ? _locationService.getPositionStream() : const Stream.empty(),
            builder: (context, snapshot) {
              final pos = snapshot.data;
              final speed = pos != null ? (pos.speed * 3.6).toStringAsFixed(1) : '0.0';
              final coords = pos != null ? '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}' : 'Locating...';

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildMapPreview(coords),
                      const SizedBox(height: 24),
                      _buildStatsRow(speed),
                      const SizedBox(height: 24),
                      _buildInfoCard(coords),
                      const SizedBox(height: 24),
                      _buildRouteHistory(),
                      const Spacer(),
                      _buildTrackingToggle(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(String coords) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Radar Effect
          TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 3),
            builder: (context, double value, child) {
              return Container(
                width: 150 * value,
                height: 150 * value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3B82F6).withOpacity(1 - value), width: 2),
                ),
              );
            },
            onEnd: () {},
          ),
          const Icon(Icons.my_location, color: Color(0xFF3B82F6), size: 40),
          Positioned(
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(coords, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(String speed) {
    return Row(
      children: [
        Expanded(child: _statItem('SPEED', speed, 'km/h', Icons.speed, const Color(0xFF3B82F6))),
        const SizedBox(width: 16),
        Expanded(child: _statItem('ALTITUDE', '42', 'm', Icons.terrain_outlined, const Color(0xFFA855F7))),
      ],
    );
  }

  Widget _statItem(String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              Text(unit, style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String coords) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.share_location, color: Color(0xFF10B981), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ENCRYPTED SHARING', style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text('Real-time location is being shared with emergency contacts.', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('RECENT PATH', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1)),
            Text('SEE ALL', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 16),
        _historyItem('Departure: Hotel Ritz', '10:14 AM', true),
        _historyItem('Checkpoint: Eiffel Tower', '10:45 AM', false),
        _historyItem('Current Position', 'Live', false, isLast: true),
      ],
    );
  }

  Widget _historyItem(String title, String time, bool isFirst, {bool isLast = false}) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLast ? const Color(0xFFEE4E4E) : const Color(0xFF3B82F6),
                  boxShadow: [
                    if (isLast) BoxShadow(color: const Color(0xFFEE4E4E).withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
                  ],
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 1, color: Colors.white.withOpacity(0.1))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: isLast ? FontWeight.w800 : FontWeight.w600)),
                Text(time, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingToggle() {
    return GestureDetector(
      onTap: () => setState(() => _isTracking = !_isTracking),
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _isTracking ? const Color(0xFFEE4E4E) : const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (_isTracking ? const Color(0xFFEE4E4E) : const Color(0xFF3B82F6)).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isTracking ? 'STOP LIVE TRACKING' : 'START LIVE TRACKING',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}

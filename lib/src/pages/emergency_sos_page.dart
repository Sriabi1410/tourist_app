import 'dart:async';

import 'package:flutter/material.dart';

class EmergencySosPage extends StatefulWidget {
  const EmergencySosPage({super.key});

  @override
  State<EmergencySosPage> createState() => _EmergencySosPageState();
}

class _EmergencySosPageState extends State<EmergencySosPage> {
  final List<String> _types = ['Medical', 'Crime', 'Accident'];
  int _selectedType = 0;
  int _secondsLeft = 10;
  Timer? _countdown;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdown?.cancel();
    _secondsLeft = 10;
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 1) {
        timer.cancel();
      }
      setState(() {
        _secondsLeft = _secondsLeft - 1;
      });
    });
  }

  void _confirmAlert() {
    setState(() {
      _sending = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _sending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${_types[_selectedType]} alert sent to authorities.'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency SOS')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select emergency type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 18),
            ..._types.asMap().entries.map((entry) {
              final index = entry.key;
              final type = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == index,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = index;
                    });
                  },
                  selectedColor: Colors.red.shade100,
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text('Preview message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'I need immediate ${_types[_selectedType]} assistance at my current location. Please send help now.',
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Countdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('$_secondsLeft sec', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: _secondsLeft / 10,
              color: Colors.redAccent,
              backgroundColor: Colors.red.shade100,
              minHeight: 8,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _countdown?.cancel();
                      setState(() {
                        _secondsLeft = 10;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sending ? null : _confirmAlert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE63946),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _sending
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Confirm Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Offline: send SMS to saved contacts and emergency numbers.\n'
              'Online: send alert to server and authorities with live tracking.',
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
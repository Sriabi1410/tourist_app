import 'package:flutter/material.dart';

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  final List<Map<String, String>> _contacts = const [
    {'name': 'Emma Wells', 'role': 'Family', 'phone': '+44 7700 900123'},
    {'name': 'Police', 'role': 'Emergency', 'phone': '+33 112'},
    {'name': 'Hospital', 'role': 'Priority', 'phone': '+33 150'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.black87)),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _contacts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 10))],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE63946).withOpacity(0.14),
                  child: Text(contact['name']![0], style: const TextStyle(color: Color(0xFFE63946), fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(contact['role']!, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(contact['phone']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Color(0xFF10B981))),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.message, color: Color(0xFF3B82F6))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

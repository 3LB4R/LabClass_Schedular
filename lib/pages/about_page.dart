import 'package:flutter/material.dart';

// Import dari file yang sudah kita pecah

// Lanjut paste class DashboardPage di sini
// ...
/* ================= ABOUT ================= */

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            label: "Logo Monitoring Heart",
            child: const Icon(
              Icons.monitor_heart,
              size: 80,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: const Text(
              "LabClass Scheduler\nSmart Monitoring System",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          // const Text(
          //   "v9.0 - No Search & Tactile Animations",
          //   style: TextStyle(color: Colors.grey),
          // ),
          // const SizedBox(height: 40),
          // const Text(
          //   "Developed by Thoriq Albar Romanov",
          //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          // ),
        ],
      ),
    );
  }
}

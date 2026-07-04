import 'package:flutter/material.dart';

// Pindahkan class AnimatedPressCard ke sini persis seperti kodingan aslimu
// ...
/* ================= WIDGET ANIMASI (MICRO-INTERACTION) ================= */
// Widget ini bertugas memberikan efek mengecil & glow saat kartu ditekan
class AnimatedPressCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedPressCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AnimatedPressCard> createState() => _AnimatedPressCardState();
}

class _AnimatedPressCardState extends State<AnimatedPressCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95), // Mengecil saat ditekan
      onTapUp: (_) {
        setState(() => _scale = 1.0); // Kembali normal
        widget.onTap(); // Jalankan aksi klik
      },
      onTapCancel: () =>
          setState(() => _scale = 1.0), // Batal tekan kembali normal
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

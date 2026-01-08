import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDark;
  final Function(bool) onToggle;

  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Colors.grey[600] : Colors.grey[200],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            top: 4,
            left: isDark ? 36 : 4,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 5,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isDark ? 0.5 : 1.0,
              child: const Icon(
                Icons.wb_sunny,
                color: Color(0xFFFFD700), // Muted gold
                size: 24,
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isDark ? 1.0 : 0.5,
              child: const Icon(
                Icons.nightlight_round,
                color: Color(0xFF87CEEB), // Sky blue
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
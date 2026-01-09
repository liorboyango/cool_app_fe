import 'package:flutter/material.dart';

import 'theme/app_colors.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onToggle(!isDark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
                child: Icon(
                  Icons.wb_sunny,
                  color: colorScheme.secondary,
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
                child: Icon(
                  Icons.nightlight_round,
                  color: colorScheme.secondary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
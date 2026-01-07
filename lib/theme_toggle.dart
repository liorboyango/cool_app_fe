import 'package:flutter/material.dart';

class ThemeToggle extends StatefulWidget {
  final bool isDark;
  final Function(bool) onToggle;

  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  @override
  void didUpdateWidget(covariant ThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isDark = widget.isDark;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _isDark ? Colors.grey[800] : Colors.yellow[100],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            top: 4,
            left: _isDark ? 36 : 4,
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
              opacity: _isDark ? 0.5 : 1.0,
              child: const Icon(
                Icons.wb_sunny,
                color: Colors.orange,
                size: 24,
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isDark ? 1.0 : 0.5,
              child: const Icon(
                Icons.nightlight_round,
                color: Colors.blueGrey,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
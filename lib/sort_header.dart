import 'package:flutter/material.dart';

class SortHeader extends StatelessWidget {
  final bool isAsc;
  final VoidCallback onTap;

  const SortHeader({super.key, required this.isAsc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Icon(isAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
        ],
      ),
    );
  }
}

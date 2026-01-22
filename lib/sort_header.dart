import 'package:flutter/material.dart';

import 'user_notifier.dart';

class SortHeader extends StatelessWidget {
  final SortOption selected;
  final ValueChanged<SortOption> onChanged;

  const SortHeader({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: SortOption.nameAsc,
          child: Row(
            children: [
              Text('Name A-Z'),
              if (selected == SortOption.nameAsc) const Icon(Icons.check, size: 16),
            ],
          ),
        ),
        PopupMenuItem(
          value: SortOption.nameDesc,
          child: Row(
            children: [
              Text('Name Z-A'),
              if (selected == SortOption.nameDesc) const Icon(Icons.check, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
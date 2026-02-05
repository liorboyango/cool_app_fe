import 'package:flutter/material.dart';

class GenderFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const GenderFilter({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['all', 'male', 'female'].map((g) {
        final label = g == 'all' ? 'All' : g[0].toUpperCase() + g.substring(1);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: selected == g,
            onSelected: (_) => onChanged(g),
            selectedColor: g == 'male' ? const Color(0xFFDBEAFE) : g == 'female' ? const Color(0xFFFCE7F3) : theme.colorScheme.primaryContainer,
            backgroundColor: theme.colorScheme.surface,
          ),
        );
      }).toList(),
    );
  }
}

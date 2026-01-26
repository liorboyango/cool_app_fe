import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_provider.dart';

class FilterControls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search by name, email, or role',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: filter.query.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: () => notifier.setQuery(''))
              : null,
          ),
          onChanged: notifier.setQuery,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: filter.gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  const DropdownMenuItem(value: 'male', child: Text('Male')),
                  const DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: notifier.setGender,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<SortField>(
                value: filter.sortBy,
                decoration: const InputDecoration(labelText: 'Sort by'),
                items: SortField.values.map((f) =>
                  DropdownMenuItem(value: f, child: Text(f.name))
                ).toList(),
                onChanged: (v) => v != null ? notifier.setSort(v) : null,
              ),
            ),
            IconButton(
              icon: Icon(filter.sortDir == SortDir.asc ? Icons.arrow_upward : Icons.arrow_downward),
              onPressed: notifier.toggleDir,
            ),
          ],
        ),
      ],
    );
  }
}
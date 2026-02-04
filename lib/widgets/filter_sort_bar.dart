import 'package:flutter/material.dart';

import '../mixins/filter_sort_mixin.dart';

class FilterSortBar extends StatelessWidget {
  final String searchQuery;
  final SortOption sortOption;
  final Set<String> activeFilters;
  final List<String> filterOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<SortOption> onSortChanged;
  final ValueChanged<Set<String>> onFiltersChanged;

  const FilterSortBar({
    super.key,
    required this.searchQuery,
    required this.sortOption,
    required this.activeFilters,
    required this.filterOptions,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search
        TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () => onSearchChanged(''),
                  )
                : null,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 12),
        // Sort + Filter row
        Row(
          children: [
            // Sort dropdown
            DropdownButton<SortOption>(
              value: sortOption,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: SortOption.firstAsc, child: Text('First Name A-Z')),
                DropdownMenuItem(value: SortOption.firstDesc, child: Text('First Name Z-A')),
                DropdownMenuItem(value: SortOption.lastAsc, child: Text('Last Name A-Z')),
                DropdownMenuItem(value: SortOption.lastDesc, child: Text('Last Name Z-A')),
                DropdownMenuItem(value: SortOption.fullAsc, child: Text('Full Name A-Z')),
                DropdownMenuItem(value: SortOption.fullDesc, child: Text('Full Name Z-A')),
                DropdownMenuItem(value: SortOption.emailAsc, child: Text('Email A-Z')),
                DropdownMenuItem(value: SortOption.emailDesc, child: Text('Email Z-A')),
              ],
              onChanged: (v) => v != null ? onSortChanged(v) : null,
            ),
            const SizedBox(width: 16),
            // Filter chips
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterOptions.map((f) {
                    final selected = activeFilters.contains(f);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f),
                        selected: selected,
                        onSelected: (sel) {
                          final updated = Set<String>.from(activeFilters);
                          sel ? updated.add(f) : updated.remove(f);
                          onFiltersChanged(updated);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
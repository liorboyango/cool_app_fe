import 'package:flutter/material.dart';

class FilterSortBar extends StatelessWidget {
  final String searchQuery;
  final String? selectedSort;
  final String? selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSortChanged;
  final ValueChanged<String?> onFilterChanged;
  final VoidCallback onClear;

  const FilterSortBar({
    super.key,
    required this.searchQuery,
    this.selectedSort,
    this.selectedFilter,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onFilterChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: searchQuery),
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedSort,
                hint: const Text('Sort by'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'name_asc', child: Text('Name A-Z')),
                  DropdownMenuItem(value: 'name_desc', child: Text('Name Z-A')),
                ],
                onChanged: onSortChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedFilter,
                hint: const Text('Filter'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: onFilterChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear filters',
            ),
          ],
        ),
      ],
    );
  }
}
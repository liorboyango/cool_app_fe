import 'package:flutter/material.dart';

class FilterSortBar extends StatelessWidget {
  final TextEditingController searchController;
  final String sortBy;
  final bool isSortAsc;
  final String filterBy;
  final Function(String) onSearch;
  final Function(String) onSort;
  final VoidCallback onToggleSort;
  final Function(String) onFilter;

  const FilterSortBar({
    super.key,
    required this.searchController,
    required this.sortBy,
    required this.isSortAsc,
    required this.filterBy,
    required this.onSearch,
    required this.onSort,
    required this.onToggleSort,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: onSearch,
            ),
          ),
          const SizedBox(width: 8),
          _buildDropdown('Sort', sortBy, ['Name', 'Email', 'Role'], onSort),
          IconButton(
            icon: Icon(isSortAsc ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: onToggleSort,
          ),
          const SizedBox(width: 8),
          _buildDropdown('Filter', filterBy, ['All', 'Male', 'Female'], onFilter),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return DropdownButton<String>(
      value: value,
      hint: Text(label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => v != null ? onChanged(v) : null,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
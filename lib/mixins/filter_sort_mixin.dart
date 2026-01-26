mixin FilterSortMixin<T> {
  List<T> applyFilters({
    required List<T> items,
    required String searchQuery,
    String? sortBy,
    String? filterBy,
    required String Function(T) getName,
    required bool Function(T, String) matchesFilter,
  }) {
    var result = List<T>.from(items);

    // Search
    if (searchQuery.isNotEmpty) {
      result = result.where((item) => 
        getName(item).toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Filter
    if (filterBy != null && filterBy != 'all') {
      result = result.where((item) => matchesFilter(item, filterBy)).toList();
    }

    // Sort
    if (sortBy != null) {
      switch (sortBy) {
        case 'name_asc':
          result.sort((a, b) => getName(a).compareTo(getName(b)));
        case 'name_desc':
          result.sort((a, b) => getName(b).compareTo(getName(a)));
      }
    }

    return result;
  }
}
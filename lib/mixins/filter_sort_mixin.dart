import 'package:flutter/material.dart';

enum SortOption {
  firstAsc,
  firstDesc,
  lastAsc,
  lastDesc,
  fullAsc,
  fullDesc,
  emailAsc,
  emailDesc
}

mixin FilterSortMixin<T> {
  List<T> applyFilterSort({
    required List<T> items,
    required String query,
    required Set<String> filters,
    required SortOption sort,
    required String Function(T) getFirstName,
    required String Function(T) getLastName,
    required String Function(T) getFullName,
    required String Function(T) getEmail,
    required Set<String> Function(T) getCategories,
  }) {
    var result = items.where((item) {
      final matchesQuery = query.isEmpty ||
          getFirstName(item).toLowerCase().contains(query.toLowerCase()) ||
          getLastName(item).toLowerCase().contains(query.toLowerCase()) ||
          getFullName(item).toLowerCase().contains(query.toLowerCase()) ||
          getEmail(item).toLowerCase().contains(query.toLowerCase());
      final matchesFilter =
          filters.isEmpty || filters.any((f) => getCategories(item).contains(f));
      return matchesQuery && matchesFilter;
    }).toList();

    result.sort((a, b) {
      switch (sort) {
        case SortOption.firstAsc:
          return getFirstName(a).compareTo(getFirstName(b));
        case SortOption.firstDesc:
          return getFirstName(b).compareTo(getFirstName(a));
        case SortOption.lastAsc:
          return getLastName(a).compareTo(getLastName(b));
        case SortOption.lastDesc:
          return getLastName(b).compareTo(getLastName(a));
        case SortOption.fullAsc:
          return getFullName(a).compareTo(getFullName(b));
        case SortOption.fullDesc:
          return getFullName(b).compareTo(getFullName(a));
        case SortOption.emailAsc:
          return getEmail(a).compareTo(getEmail(b));
        case SortOption.emailDesc:
          return getEmail(b).compareTo(getEmail(a));
      }
    });
    return result;
  }
}

import 'package:flutter/material.dart';

enum SortOption { nameAsc, nameDesc, emailAsc, emailDesc }

mixin FilterSortMixin<T> {
  List<T> applyFilterSort({
    required List<T> items,
    required String query,
    required Set<String> filters,
    required SortOption sort,
    required String Function(T) getName,
    required String Function(T) getEmail,
    required Set<String> Function(T) getCategories,
  }) {
    var result = items.where((item) {
      final matchesQuery = query.isEmpty ||
          getName(item).toLowerCase().contains(query.toLowerCase()) ||
          getEmail(item).toLowerCase().contains(query.toLowerCase());
      final matchesFilter =
          filters.isEmpty || filters.any((f) => getCategories(item).contains(f));
      return matchesQuery && matchesFilter;
    }).toList();

    result.sort((a, b) {
      switch (sort) {
        case SortOption.nameAsc:
          return getName(a).compareTo(getName(b));
        case SortOption.nameDesc:
          return getName(b).compareTo(getName(a));
        case SortOption.emailAsc:
          return getEmail(a).compareTo(getEmail(b));
        case SortOption.emailDesc:
          return getEmail(b).compareTo(getEmail(a));
      }
    });
    return result;
  }
}
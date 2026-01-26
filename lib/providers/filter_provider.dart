import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortField { name, role, gender }
enum SortDir { asc, desc }

class FilterState {
  final String query;
  final String? gender;
  final SortField sortBy;
  final SortDir sortDir;

  const FilterState({
    this.query = '',
    this.gender,
    this.sortBy = SortField.name,
    this.sortDir = SortDir.asc,
  });

  FilterState copyWith({
    String? query,
    String? gender,
    SortField? sortBy,
    SortDir? sortDir,
  }) => FilterState(
    query: query ?? this.query,
    gender: gender ?? this.gender,
    sortBy: sortBy ?? this.sortBy,
    sortDir: sortDir ?? this.sortDir,
  );
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void setQuery(String q) => state = state.copyWith(query: q);
  void setGender(String? g) => state = state.copyWith(gender: g);
  void setSort(SortField f) => state = state.copyWith(sortBy: f);
  void toggleDir() => state = state.copyWith(
    sortDir: state.sortDir == SortDir.asc ? SortDir.desc : SortDir.asc,
  );
  void clear() => state = const FilterState();
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(),
);
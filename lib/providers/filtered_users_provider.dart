import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'filter_provider.dart';
import 'users_provider.dart';
import '../models/user.dart';

final filteredUsersProvider = Provider<List<User>>((ref) {
  final usersAsync = ref.watch(usersNotifierProvider);
  final filter = ref.watch(filterProvider);

  final users = usersAsync.maybeWhen(
    data: (data) => data,
    orElse: () => <User>[],
  );

  var result = users.where((user) {
    final matchQuery = user.name.toLowerCase().contains(filter.query.toLowerCase()) ||
                       user.email.toLowerCase().contains(filter.query.toLowerCase()) ||
                       user.role.toLowerCase().contains(filter.query.toLowerCase());
    final matchGender = filter.gender == null || user.gender == filter.gender;
    return matchQuery && matchGender;
  }).toList();

  result.sort((a, b) {
    int cmp;
    switch (filter.sortBy) {
      case SortField.name:
        cmp = a.name.compareTo(b.name);
        break;
      case SortField.role:
        cmp = a.role.compareTo(b.role);
        break;
      case SortField.gender:
        cmp = a.gender.compareTo(b.gender);
        break;
    }
    return filter.sortDir == SortDir.asc ? cmp : -cmp;
  });

  return result;
});
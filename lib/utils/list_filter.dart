class ListFilter<T> {
  final List<T> items;

  ListFilter(this.items);

  List<T> filter(bool Function(T) predicate) => items.where(predicate).toList();

  List<T> sort(Comparable Function(T) key, {bool desc = false}) {
    final sorted = [...items]..sort((a, b) => key(a).compareTo(key(b)));
    return desc ? sorted.reversed.toList() : sorted;
  }

  List<T> search(String query, String Function(T) getText) {
    if (query.isEmpty) return items;
    return items.where((item) => getText(item).toLowerCase().contains(query.toLowerCase())).toList();
  }
}
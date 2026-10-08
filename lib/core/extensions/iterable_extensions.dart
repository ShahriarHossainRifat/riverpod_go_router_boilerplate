/// Iterable extension methods for common operations.
extension IterableExtensions<T> on Iterable<T> {
  // ─────────────────────────────────────────────────────────────────────────────
  // SAFE ACCESS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Returns the first element or null if empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns element at index or null if out of bounds.
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return elementAt(index);
  }

  /// Returns first element matching predicate or null.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns last element matching predicate or null.
  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (final element in this) {
      if (test(element)) result = element;
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TRANSFORMATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Maps elements with their index.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) {
    var index = 0;
    return map((element) => convert(index++, element));
  }

  /// Filters elements with their index.
  Iterable<T> whereIndexed(bool Function(int index, T element) test) {
    var index = 0;
    return where((element) => test(index++, element));
  }

  /// Groups elements by a key.
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final result = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      (result[key] ??= []).add(element);
    }
    return result;
  }

  /// Removes duplicate elements by key.
  Iterable<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((element) => seen.add(keySelector(element)));
  }

  /// Splits iterable into chunks of specified size.
  Iterable<List<T>> chunked(int size) sync* {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final chunk = <T>[iterator.current];
      for (var i = 1; i < size && iterator.moveNext(); i++) {
        chunk.add(iterator.current);
      }
      yield chunk;
    }
  }

  /// Separates elements with a separator element.
  Iterable<T> separatedBy(T separator) sync* {
    var first = true;
    for (final element in this) {
      if (!first) yield separator;
      yield element;
      first = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // AGGREGATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Returns sum of elements using selector.
  num sumBy(num Function(T) selector) {
    var sum = 0.0;
    for (final element in this) {
      sum += selector(element);
    }
    return sum;
  }

  /// Returns average of elements using selector.
  double averageBy(num Function(T) selector) {
    if (isEmpty) return 0;
    return sumBy(selector) / length;
  }

  /// Returns max element by comparable selector.
  T? maxBy<R extends Comparable<R>>(R Function(T) selector) {
    if (isEmpty) return null;
    T? maxElement;
    R? maxValue;
    for (final element in this) {
      final value = selector(element);
      if (maxValue == null || value.compareTo(maxValue) > 0) {
        maxElement = element;
        maxValue = value;
      }
    }
    return maxElement;
  }

  /// Returns min element by comparable selector.
  T? minBy<R extends Comparable<R>>(R Function(T) selector) {
    if (isEmpty) return null;
    T? minElement;
    R? minValue;
    for (final element in this) {
      final value = selector(element);
      if (minValue == null || value.compareTo(minValue) < 0) {
        minElement = element;
        minValue = value;
      }
    }
    return minElement;
  }

  /// Counts elements matching predicate.
  int count(bool Function(T) test) {
    var count = 0;
    for (final element in this) {
      if (test(element)) count++;
    }
    return count;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PREDICATES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Returns true if none of the elements match the predicate.
  bool none(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return false;
    }
    return true;
  }

  /// Returns true if all elements are equal.
  bool get allEqual {
    if (isEmpty) return true;
    final firstElement = first;
    return every((element) => element == firstElement);
  }

  /// Returns true if the iterable contains all elements.
  bool containsAll(Iterable<T> elements) {
    for (final element in elements) {
      if (!contains(element)) return false;
    }
    return true;
  }
}

/// List-specific extensions.
extension ListExtensions<T> on List<T> {
  /// Swaps elements at two indices.
  void swap(int i, int j) {
    final temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }

  /// Moves element from one index to another.
  void move(int from, int to) {
    final element = removeAt(from);
    insert(to, element);
  }

  /// Returns a copy with element inserted at index.
  List<T> insertedAt(int index, T element) {
    return [...sublist(0, index), element, ...sublist(index)];
  }

  /// Returns a copy with element at index removed.
  List<T> removedAt(int index) {
    return [...sublist(0, index), ...sublist(index + 1)];
  }

  /// Returns a copy with element replaced at index.
  List<T> replacedAt(int index, T element) {
    return [...sublist(0, index), element, ...sublist(index + 1)];
  }

  /// Returns a sorted copy of the list.
  List<T> sortedBy<R extends Comparable<R>>(R Function(T) selector) {
    final copy = [...this];
    copy.sort((a, b) => selector(a).compareTo(selector(b)));
    return copy;
  }

  /// Returns a reverse-sorted copy of the list.
  List<T> sortedByDescending<R extends Comparable<R>>(R Function(T) selector) {
    final copy = [...this];
    copy.sort((a, b) => selector(b).compareTo(selector(a)));
    return copy;
  }

  /// Returns a shuffled copy of the list.
  List<T> get shuffled {
    final copy = [...this];
    copy.shuffle();
    return copy;
  }
}

/// Map-specific extensions.
extension MapExtensions<K, V> on Map<K, V> {
  /// Gets value or default if key doesn't exist.
  V getOrDefault(K key, V defaultValue) {
    return this[key] ?? defaultValue;
  }

  /// Gets value or computes and stores it if key doesn't exist.
  V getOrPut(K key, V Function() ifAbsent) {
    return this[key] ??= ifAbsent();
  }

  /// Maps values to new type.
  Map<K, R> mapValues<R>(R Function(V) transform) {
    return map((key, value) => MapEntry(key, transform(value)));
  }

  /// Maps keys to new type.
  Map<R, V> mapKeys<R>(R Function(K) transform) {
    return map((key, value) => MapEntry(transform(key), value));
  }

  /// Filters map by key-value predicate.
  Map<K, V> whereMap(bool Function(K key, V value) test) {
    return Map.fromEntries(entries.where((e) => test(e.key, e.value)));
  }

  /// Returns true if map contains all specified keys.
  bool containsKeys(Iterable<K> keys) {
    return keys.every(containsKey);
  }
}

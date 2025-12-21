extension IterableExtension<E> on Iterable<E> {
  /// Get Last Index
  /// ```dart
  /// final lastIndex = list.lastIndex;
  /// ```
  int get lastIndex => length - 1;

  /// Check If Index Is Last Index
  /// [index] : Index To Check
  /// ```dart
  /// final isLastIndex = list.isLastIndex(0);
  /// ```
  bool isLastIndex(int index) => index == lastIndex;

  /// Map Indexed
  /// Map The List With Index And Value as the callback
  /// [mapper] : Mapper To Map
  /// ```dart
  /// final mapped = list.mapIndexed((index, item) => item * index);
  /// ```
  Iterable<T> mapIndexed<T>(T Function(int index, E item) mapper) {
    return Iterable.generate(
      length,
      (index) => mapper(index, elementAt(index)),
    );
  }

  /// Get At Or Null
  /// Get The Element At The Index
  /// [index] : Index To Get
  /// ```dart
  /// final element = list.getAtOrNull(0);
  /// ```
  ///
  /// Return Null If Index Is Out Of Range
  E? getAtOrNull(int index) {
    if (index < length && index >= 0) return elementAt(index);
    return null;
  }

  /// Where Map
  /// Map The List With Condition
  /// [mapper] : Mapper To Map
  /// [condition] : Condition To Map
  /// ```dart
  /// final mapped = list.whereMap((item) => item * 2, (item) => item > 10);
  /// ```
  Iterable<T> whereMap<T>(
    T Function(E item) mapper,
    bool Function(E item) condition,
  ) {
    final List<T> result = [];
    for (var element in this) {
      if (condition(element)) {
        result.add(mapper(element));
      }
    }
    return result;
  }

  /// Where Map Indexed
  /// Map The List With Condition And Index
  /// [mapper] : Mapper To Map
  /// [condition] : Condition To Map
  /// ```dart
  /// final mapped = list.whereMapIndexed((newIndex, oldIndex, item) => item * 2, (index, item) => item > 10);
  /// ```
  Iterable<T> whereMapIndexed<T>(
    T Function(int newIndex, int oldIndex, E item) mapper,
    bool Function(int index, E item) condition,
  ) {
    final List<T> result = [];
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (condition(i, element)) {
        result.add(mapper(result.length, i, element));
      }
    }
    return result;
  }

  /// First Where Or Null
  /// Get The First Element That Satisfies The Condition
  /// [condition] : Condition To Satisfy
  /// ```dart
  /// final element = list.firstWhereOrNull((index, item) => item > 10);
  /// ```
  E? firstWhereOrNull<T>(bool Function(int index, E item) condition) {
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (condition(i, element)) return element;
    }
    return null;
  }

  /// Index Where Or Null
  /// Get The Index Of The First Element That Satisfies The Condition
  /// [condition] : Condition To Satisfy
  /// ```dart
  /// final index = list.indexWhereOrNull((index, item) => item > 10);
  /// ```
  ///
  /// Return Null If No Element Satisfies The Condition
  int? indexWhereOrNull<T>(bool Function(int index, E item) condition) {
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (condition(i, element)) return i;
    }
    return null;
  }

  /// To Map
  /// Convert The List To A Map
  /// [mapper] : Mapper To Convert
  /// ```dart
  /// final map = list.toMap((item) => item.key, (item) => item.value);
  /// ```
  Map<Key, Value> toMap<Key, Value>(
    MapEntry<Key, Value> Function(E item) mapper,
  ) {
    final Map<Key, Value> result = {};
    for (var element in this) {
      final mapped = mapper(element);
      result[mapped.key] = mapped.value;
    }
    return result;
  }

  /// Equal To
  /// Check If The List Is Equal To Another List
  /// [other] : Other List To Compare
  /// [compareFunc] : Function To Compare The Elements
  /// ```dart
  /// final isEqual = list.equalTo(otherList);
  /// ```
  bool equalTo(Iterable<E> other, {bool Function(E a, E b)? compareFunc}) {
    final a = this;
    final b = other;
    final bool Function(E a, E b) compare = compareFunc ?? (a, b) => a == b;
    if (a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      final compareResult = compare(a.elementAt(index), b.elementAt(index));
      if (!compareResult) return false;
    }
    return true;
  }
}

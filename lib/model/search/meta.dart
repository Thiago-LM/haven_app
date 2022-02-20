import 'dart:convert';

import 'package:collection/collection.dart';

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  dynamic query;
  dynamic seed;

  Meta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.query,
    this.seed,
  });

  @override
  String toString() {
    return 'Meta(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, query: $query, seed: $seed)';
  }

  factory Meta.fromMap(Map<String, dynamic> data) => Meta(
        currentPage: data['current_page'] as int?,
        lastPage: data['last_page'] as int?,
        perPage: data['per_page'] as int?,
        total: data['total'] as int?,
        query: data['query'] as dynamic,
        seed: data['seed'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
        'query': query,
        'seed': seed,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Meta].
  factory Meta.fromJson(String data) {
    return Meta.fromMap(jsonDecode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Meta] to a JSON string.
  String toJson() => jsonEncode(toMap());

  Meta copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    dynamic query,
    dynamic seed,
  }) {
    return Meta(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      query: query ?? this.query,
      seed: seed ?? this.seed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Meta) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      currentPage.hashCode ^
      lastPage.hashCode ^
      perPage.hashCode ^
      total.hashCode ^
      query.hashCode ^
      seed.hashCode;
}

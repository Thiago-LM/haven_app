import 'dart:convert';

import 'package:collection/collection.dart';

import 'datum.dart';
import 'meta.dart';

class Search {
  List<Datum>? data;
  Meta? meta;

  Search({this.data, this.meta});

  @override
  String toString() => 'Search(data: $data, meta: $meta)';

  factory Search.fromMap(Map<String, dynamic> data) => Search(
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
            .toList(),
        meta: data['meta'] == null
            ? null
            : Meta.fromMap(data['meta'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
        'meta': meta?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Search].
  factory Search.fromJson(String data) {
    return Search.fromMap(jsonDecode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Search] to a JSON string.
  String toJson() => jsonEncode(toMap());

  Search copyWith({
    List<Datum>? data,
    Meta? meta,
  }) {
    return Search(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Search) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => data.hashCode ^ meta.hashCode;
}

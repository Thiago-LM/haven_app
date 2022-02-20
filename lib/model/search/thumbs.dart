import 'dart:convert';

import 'package:collection/collection.dart';

class Thumbs {
  String? large;
  String? original;
  String? small;

  Thumbs({this.large, this.original, this.small});

  @override
  String toString() {
    return 'Thumbs(large: $large, original: $original, small: $small)';
  }

  factory Thumbs.fromMap(Map<String, dynamic> data) => Thumbs(
        large: data['large'] as String?,
        original: data['original'] as String?,
        small: data['small'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'large': large,
        'original': original,
        'small': small,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Thumbs].
  factory Thumbs.fromJson(String data) {
    return Thumbs.fromMap(jsonDecode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Thumbs] to a JSON string.
  String toJson() => jsonEncode(toMap());

  Thumbs copyWith({
    String? large,
    String? original,
    String? small,
  }) {
    return Thumbs(
      large: large ?? this.large,
      original: original ?? this.original,
      small: small ?? this.small,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Thumbs) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => large.hashCode ^ original.hashCode ^ small.hashCode;
}

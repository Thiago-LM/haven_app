import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thumbs.g.dart';

@JsonSerializable()
class Thumbs extends Equatable {
  final String? large;
  final String? original;
  final String? small;

  const Thumbs({this.large, this.original, this.small});

  factory Thumbs.fromJson(Map<String, dynamic> json) {
    return _$ThumbsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ThumbsToJson(this);

  @override
  List<Object?> get props => [large, original, small];
}

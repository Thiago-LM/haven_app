import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta extends Equatable {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  @JsonKey(name: 'per_page')
  final int? perPage;
  final int? total;
  final dynamic query;
  final dynamic seed;

  const Meta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.query,
    this.seed,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);

  @override
  List<Object?> get props {
    return [
      currentPage,
      lastPage,
      perPage,
      total,
      query,
      seed,
    ];
  }
}

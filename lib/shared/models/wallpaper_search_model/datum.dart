import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'thumbs.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum extends Equatable {
  final String? id;
  final String? url;
  @JsonKey(name: 'short_url')
  final String? shortUrl;
  final int? views;
  final int? favorites;
  final String? source;
  final String? purity;
  final String? category;
  @JsonKey(name: 'dimension_x')
  final int? dimensionX;
  @JsonKey(name: 'dimension_y')
  final int? dimensionY;
  final String? resolution;
  final String? ratio;
  @JsonKey(name: 'file_size')
  final int? fileSize;
  @JsonKey(name: 'file_type')
  final String? fileType;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final List<String>? colors;
  final String? path;
  final Thumbs? thumbs;

  const Datum({
    this.id,
    this.url,
    this.shortUrl,
    this.views,
    this.favorites,
    this.source,
    this.purity,
    this.category,
    this.dimensionX,
    this.dimensionY,
    this.resolution,
    this.ratio,
    this.fileSize,
    this.fileType,
    this.createdAt,
    this.colors,
    this.path,
    this.thumbs,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      url,
      shortUrl,
      views,
      favorites,
      source,
      purity,
      category,
      dimensionX,
      dimensionY,
      resolution,
      ratio,
      fileSize,
      fileType,
      createdAt,
      colors,
      path,
      thumbs,
    ];
  }
}

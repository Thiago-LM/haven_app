import 'package:equatable/equatable.dart';

enum WallpaperSorting {
  latest,
  relevance,
  random,
  views,
  favorites,
  toplist,
  hot
}

enum WallpaperOrder { asc, desc }

enum WallpaperTopRange {
  day,
  threeDays,
  week,
  month,
  threeMonths,
  sixMonths,
  year;

  String get value {
    switch (this) {
      case day:
        return '1d';
      case threeDays:
        return '3d';
      case week:
        return '1w';
      case month:
        return '1M';
      case threeMonths:
        return '3M';
      case sixMonths:
        return '6M';
      case year:
        return '1y';
    }
  }
}

class WallpaperQuery extends Equatable {
  const WallpaperQuery({
    this.query,
    this.category = const [true, true, false],
    this.purity = const [true, false, null],
    this.sorting = WallpaperSorting.latest,
    this.order = WallpaperOrder.desc,
    this.topRange = WallpaperTopRange.month,
  });

  factory WallpaperQuery.fromJson(Map<String, dynamic> json) => WallpaperQuery(
        query: json['q'] as String?,
        category: List<bool>.from(
          (json['categories'] as String).split('').map((e) => e == '1'),
        ),
        purity: List<bool?>.from(
          (json['purity'] as String).split('').map((e) => e == '1'),
        ),
        sorting: WallpaperSorting.values
            .firstWhere((e) => e.name == json['sorting']),
        order: WallpaperOrder.values.firstWhere((e) => e.name == json['order']),
        topRange: WallpaperTopRange.values
            .firstWhere((e) => e.value == json['topRange']),
      );

  final String? query;
  final List<bool> category;
  final List<bool?> purity;
  final WallpaperSorting sorting;
  final WallpaperOrder order;
  final WallpaperTopRange topRange;

  WallpaperQuery copyWith({
    String? query,
    List<bool>? category,
    List<bool?>? purity,
    WallpaperSorting? sorting,
    WallpaperOrder? order,
    WallpaperTopRange? topRange,
  }) =>
      WallpaperQuery(
        query: query ?? this.query,
        category: category ?? this.category,
        purity: purity ?? this.purity,
        sorting: sorting ?? this.sorting,
        order: order ?? this.order,
        topRange: topRange ?? this.topRange,
      );

  Map<String, dynamic> toJson() => {
        if (query != null) 'q': query,
        'categories': category.map((e) => e ? '1' : '0').join(),
        'purity': purity.map((e) => e != null && e ? '1' : '0').join(),
        'sorting': sorting.name,
        'order': order.name,
        if (sorting == WallpaperSorting.toplist) 'topRange': topRange.value,
      };

  @override
  List<Object?> get props => [
        query,
        category,
        purity,
        sorting,
        order,
        topRange,
      ];
}

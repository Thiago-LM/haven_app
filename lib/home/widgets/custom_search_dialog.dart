import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/home/cubit/home_cubit.dart';
import 'package:haven_app/shared/models/models.dart';

class CustomSearchDialog extends StatelessWidget {
  const CustomSearchDialog({required this.ctx, super.key});

  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final cubit = ctx.read<HomeCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              multipleChoiceLine(
                name: 'categories',
                options: ['general', 'anime', 'people'],
                queryOptions: state.wallQuery.category,
                onSelected: (value, index) {
                  final temp = state.wallQuery.category.toList();
                  temp[index] = value;
                  cubit.updateWallpaperQuery(
                    cubit.state.wallQuery.copyWith(category: temp),
                  );
                },
              ),
              multipleChoiceLine(
                name: 'purity',
                options: ['sfw', 'sketchy', 'nsfw'],
                queryOptions: state.wallQuery.purity,
                onSelected: (value, index) {
                  final temp = state.wallQuery.purity.toList();
                  temp[index] = temp[index] == null ? null : value;
                  cubit.updateWallpaperQuery(
                    cubit.state.wallQuery.copyWith(purity: temp),
                  );
                },
              ),
              dropdownLine<WallpaperSorting>(
                name: 'sorting',
                firstValue: state.wallQuery.sorting,
                options: WallpaperSorting.values,
                onChanged: (value) => cubit.updateWallpaperQuery(
                  cubit.state.wallQuery.copyWith(sorting: value),
                ),
                hasSorting: true,
                sort: state.wallQuery.order == WallpaperOrder.desc,
                onSortPressed: () => cubit.updateWallpaperQuery(
                  state.wallQuery.copyWith(
                    order: state.wallQuery.order == WallpaperOrder.desc
                        ? WallpaperOrder.asc
                        : WallpaperOrder.desc,
                  ),
                ),
              ),
              if (state.wallQuery.sorting == WallpaperSorting.toplist)
                dropdownLine<WallpaperTopRange>(
                  name: 'topRange',
                  firstValue: state.wallQuery.topRange,
                  options: WallpaperTopRange.values,
                  onChanged: (value) => cubit.updateWallpaperQuery(
                    cubit.state.wallQuery.copyWith(topRange: value),
                  ),
                ),
              SizedBox(
                height: 50,
                width: mediaSize.width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget multipleChoiceLine({
    required String name,
    required List<String> options,
    required List<bool?> queryOptions,
    required void Function(bool, int) onSelected,
  }) {
    return Row(
      children: [
        Expanded(child: Text('$name:')),
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 50,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 10,
                children: options.map((opt) {
                  return ChoiceChip(
                    label: Text(opt),
                    selected: queryOptions[options.indexOf(opt)] ?? false,
                    onSelected: queryOptions[options.indexOf(opt)] == null
                        ? null
                        : (bool selected) =>
                            onSelected(selected, options.indexOf(opt)),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropdownLine<T>({
    required String name,
    required T firstValue,
    required List<T> options,
    required ValueChanged<T?>? onChanged,
    bool hasSorting = false,
    bool? sort,
    VoidCallback? onSortPressed,
  }) {
    return Row(
      children: [
        Text('$name:'),
        const SizedBox(width: 20),
        DropdownButton<T>(
          value: firstValue,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: Colors.black),
          onChanged: onChanged,
          items: options
              .map<DropdownMenuItem<T>>(
                (T value) => DropdownMenuItem<T>(
                  value: value,
                  child: Text(value is Enum ? value.name : value.toString()),
                ),
              )
              .toList(),
        ),
        if (hasSorting)
          IconButton(
            onPressed: onSortPressed,
            icon: Icon(sort! ? Icons.arrow_downward : Icons.arrow_upward),
          ),
      ],
    );
  }
}

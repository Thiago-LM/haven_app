import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/home/home.dart';
import 'package:haven_app/shared/utils/utils.dart';

class HomeColorsToneList extends StatelessWidget {
  const HomeColorsToneList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The color tone',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.initial:
              case HomeStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case HomeStatus.success:
                return SizedBox(
                  height: 50,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: state.colorsData.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Clipboard.setData(
                            ClipboardData(
                              text: state.colorsData.keys.elementAt(index),
                            ),
                          ),
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.only(right: 16),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: Container(
                                color: HexColor.fromHex(
                                  state.colorsData.keys.elementAt(index),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              case HomeStatus.failure:
                return const Center(
                  child: Text('Failed to load colors'),
                );
            }
          },
        ),
      ],
    );
  }
}

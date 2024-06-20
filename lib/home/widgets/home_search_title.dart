import 'package:flutter/material.dart';

import 'package:haven_app/home/models/models.dart';

class HomeSearchTitle extends StatelessWidget {
  const HomeSearchTitle({required this.model, super.key});

  final HomeSearchTitleModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          model.icon,
          color: model.iconColor,
        ),
        const SizedBox(width: 10),
        Text(
          model.searchTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

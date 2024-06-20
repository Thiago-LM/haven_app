import 'package:flutter/material.dart';

class HomeCategoryListButtons extends StatelessWidget {
  const HomeCategoryListButtons({
    this.toplistOnPressed,
    this.latestOnPressed,
    this.hotOnPressed,
    this.randomOnPressed,
    super.key,
  });

  final VoidCallback? toplistOnPressed;
  final VoidCallback? latestOnPressed;
  final VoidCallback? hotOnPressed;
  final VoidCallback? randomOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            customButton(
              onPressed: toplistOnPressed,
              foregroundColor: Colors.purple,
              icon: Icons.diamond_outlined,
              label: 'Toplist',
            ),
            const SizedBox(height: 16),
            customButton(
              onPressed: latestOnPressed,
              foregroundColor: Colors.green,
              icon: Icons.schedule_outlined,
              label: 'Latest',
            ),
          ],
        ),
        Column(
          children: [
            customButton(
              onPressed: hotOnPressed,
              foregroundColor: Colors.red,
              icon: Icons.local_fire_department_outlined,
              label: 'Hot',
            ),
            const SizedBox(height: 16),
            customButton(
              onPressed: randomOnPressed,
              foregroundColor: Colors.orange,
              icon: Icons.shuffle_outlined,
              label: 'Random',
            ),
          ],
        ),
      ],
    );
  }

  Widget customButton({
    required VoidCallback? onPressed,
    required MaterialColor foregroundColor,
    required IconData icon,
    required String label,
  }) =>
      TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: foregroundColor[50],
        ),
        icon: Icon(icon, size: 36),
        label: Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
      );
}

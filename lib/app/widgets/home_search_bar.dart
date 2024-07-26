import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    required this.textController,
    required this.onFilterPressed,
    required this.onSearchPressed,
    super.key,
  });

  final TextEditingController textController;
  final VoidCallback onFilterPressed;
  final VoidCallback onSearchPressed;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  bool showClearButton = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.transparent),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.textController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: widget.textController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            widget.textController.clear();
                            setState(() => showClearButton = false);
                          },
                        ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (text) =>
                    setState(() => showClearButton = text.isNotEmpty),
              ),
            ),
            const VerticalDivider(),
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              color: Colors.grey,
              onPressed: widget.onFilterPressed,
            ),
            const VerticalDivider(),
            IconButton(
              icon: const Icon(CupertinoIcons.search),
              color: Colors.grey,
              onPressed: widget.onSearchPressed,
            ),
          ],
        ),
      ),
    );
  }
}

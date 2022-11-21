import 'package:flutter/material.dart';

class CustomSearchDialog extends StatefulWidget {
  const CustomSearchDialog({super.key, required this.mediaSize});

  final Size mediaSize;

  @override
  State<CustomSearchDialog> createState() => _CustomSearchDialogState();
}

class _CustomSearchDialogState extends State<CustomSearchDialog> {
  bool isDesc = true;
  final dropdownValue = <String>['date_added', '1M'];
  final _selectedCategory = <int>[0, 1, 2];
  final _selectedPurity = <int>[0];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: const Text(
        'Custom Search',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            multipleChoiceLine(
              name: 'categories',
              options: ['general', 'anime', 'people'],
              indexList: _selectedCategory,
            ),
            multipleChoiceLine(
              name: 'purity',
              options: ['sfw', 'sketchy', 'nsfw'],
              indexList: _selectedPurity,
            ),
            dropdownLine(
              name: 'sorting',
              firstValue: dropdownValue[0],
              options: [
                'date_added',
                'relevance',
                'random',
                'views',
                'favorites',
                'toplist'
              ],
              hasSorting: true,
            ),
            dropdownLine(
              name: 'topRange',
              firstValue: dropdownValue[1],
              options: ['1d', '3d', '1w', '1M', '3M', '6M', '1y'],
              hasSorting: false,
            ),
            Row(
              children: [
                const Text('atleast:'),
                const SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 50,
                  width: 75,
                  child: TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      hintText: 'width',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                const Text('X'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 50,
                  width: 75,
                  child: TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      hintText: 'height',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Back'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget multipleChoiceLine({
    required String name,
    required List<String> options,
    required List<int> indexList,
  }) {
    return Row(
      children: [
        Text('$name:'),
        const SizedBox(width: 20),
        SizedBox(
          height: 50,
          width: widget.mediaSize.width - 200,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 10,
              children: List<Widget>.generate(
                3,
                (int index) => ChoiceChip(
                  avatar: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    child: Icon(Icons.done),
                  ),
                  backgroundColor: Colors.grey,
                  selectedColor: Colors.blue,
                  label: Text(
                    index == 0
                        ? options[0]
                        : index == 1
                            ? options[1]
                            : index == 2
                                ? options[2]
                                : '',
                  ),
                  selected: indexList.contains(index),
                  onSelected: (bool selected) => setState(
                    () => indexList.contains(index)
                        ? indexList.remove(index)
                        : indexList.add(index),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropdownLine({
    required String name,
    required String firstValue,
    required List<String> options,
    required bool hasSorting,
  }) {
    return Row(
      children: [
        Text('$name:'),
        const SizedBox(width: 20),
        DropdownButton<String>(
          value: firstValue,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: Colors.black),
          onChanged: (String? newValue) => setState(
            () => dropdownValue[dropdownValue.indexOf(firstValue)] = newValue!,
          ),
          items: options
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
        ),
        if (hasSorting)
          IconButton(
            onPressed: () => setState(() => isDesc = !isDesc),
            icon: Icon(isDesc ? Icons.arrow_downward : Icons.arrow_upward),
          )
      ],
    );
  }
}

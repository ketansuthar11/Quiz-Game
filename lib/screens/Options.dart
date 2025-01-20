import 'package:flutter/material.dart';
class Options extends StatelessWidget {
  final bool isChecked;
  final int index;
  final String option;
  final ValueChanged<bool> onChanged;
  const Options({
    Key? key,
    required this.option,
    required this.isChecked,
    required this.index,
    required this.onChanged,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Card(
      elevation: 4,
      color: isChecked ? Colors.blue[50] : Colors.white,
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            onChanged(value!);
          },
        ),
        title: Text(option),
      ),
    ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key, required this.text});
  final String text;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.text,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Transform.scale(
          scale: .6,
          child: Checkbox(
            activeColor: primary,
            visualDensity: VisualDensity.compact,
            value: value, // Set the initial value of the checkbox
            onChanged: (bool? value) {
              setState(() {
                this.value = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

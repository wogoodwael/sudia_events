import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({super.key, required this.text, required this.value});
  final String text;
  late bool value;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: .6,
          child: Checkbox(
            activeColor: primary,
            visualDensity: VisualDensity.compact,
            value: widget.value, // Set the initial value of the checkbox
            onChanged: (bool? value) {
              setState(() {
                widget.value = !value!;
              });
            },
          ),
        ),
        Text(
          widget.text,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final bool edit;

  const CustomButton({super.key, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        border: !edit
            ? Border.all(color: primary)
            : Border.all(color: Colors.white),
        color: edit ? primary : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          "تعديل حجوزاتي",
          style: TextStyle(
            color: edit ? Colors.white : primary,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/custom_date.dart';
import 'package:sudia_events/core/utils/strings.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: mediawidth(context),
          height: 20,
          child: const Divider(
            endIndent: 70,
          ),
        ),
        Positioned(
            right: 10,
            child: Container(
              width: 170,
              height: 20,
              decoration: BoxDecoration(
                  color: const Color(0xff544c84),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    reversedDate,
                    style: const TextStyle(fontFamily: 'JF',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    "الجمعة",
                    style: TextStyle(fontFamily: 'JF',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                   title,
                    style: const TextStyle(fontFamily: 'JF',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

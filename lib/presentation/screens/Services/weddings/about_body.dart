import 'package:flutter/material.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key, required this.des});
  final String des;

  @override
  State<AboutBody> createState() => _AboutBodyState();
}

class _AboutBodyState extends State<AboutBody> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 50,
            child: Text(
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
            widget.des,
            ),
          ),
        ),
      ],
    );
  }
}

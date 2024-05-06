import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PositionedLogo extends StatelessWidget {
  const PositionedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 40,
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: 150,
            color: Colors.white,
          ),
        ));
  }
}

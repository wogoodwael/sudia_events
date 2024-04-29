import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class HeaderOfServices extends StatelessWidget {
  const HeaderOfServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Stack(children: [
        Container(
          height: 190,
          width: 400,
          decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
        ),
        Positioned(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Image.asset(
              "assets/images/logo.png",
              width: 200,
              color: Colors.white,
            ),
          ),
        )),
        Positioned(
            child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 160),
            width: 90,
            height: 110,
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: primary, width: 2))),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: primary,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "حجوزاتي",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        )),
      ]),
    );
  }
}

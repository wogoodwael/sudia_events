import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class Header extends StatelessWidget {
  const Header(
      {super.key,
      required this.text,
      required this.paddingButtom,
      required this.paddingTop});
  final String text;
  final double paddingButtom;
  final double paddingTop;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
          padding: EdgeInsets.only(bottom: paddingButtom, top: paddingTop),
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
          margin: const EdgeInsets.only(top: 160),
          width: 90,
          height: 110,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: primary, width: 2))),
          child: Column(
            children: [
              const CircleAvatar(
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
                padding: const EdgeInsets.only(top: 8.0),
                child: FittedBox(
                  child: Text(
                    text,
                    style: const TextStyle(fontFamily: 'JF',fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    ]);
  }
}

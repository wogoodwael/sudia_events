import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/positioned_logo.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  bool chooseday = false;
  bool addService = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    height: 150,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: primary,
                    ),
                  ),
                ),
                PositionedLogo(),
                Positioned(
                    bottom: 0,
                    left: 20,
                    top: 100,
                    child: Container(
                      width: .9 * mediawidth(context),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                addService = true;
                                chooseday = false;
                              });
                            },
                            child: Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                color: addService ? primary : Colors.white,
                                border: !addService
                                    ? Border.all(color: primary)
                                    : Border.all(color: Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "اضافة خدمات ",
                                  style: TextStyle(
                                    color: addService ? Colors.white : primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                addService = false;
                                chooseday = true;
                              });
                            },
                            child: Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                border: !chooseday
                                    ? Border.all(color: primary)
                                    : Border.all(color: Colors.white),
                                color: chooseday ? primary : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "اختيار اليوم ",
                                  style: TextStyle(
                                    color: chooseday ? Colors.white : primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          Expanded(flex: 6, child: Container())
        ],
      ),
    );
  }
}

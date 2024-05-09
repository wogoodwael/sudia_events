import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/about_body.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/apoinion_body.dart';

class WeddingsHotels extends StatefulWidget {
  const WeddingsHotels({super.key});

  @override
  State<WeddingsHotels> createState() => _WeddingsHotelsState();
}

class _WeddingsHotelsState extends State<WeddingsHotels> {
  bool ontapped = false;
  bool ontappednap = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: mediawidth(context),
                  height: mediaheight(context),
                  child: Image.asset(
                    "assets/images/w1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  bottom: 0 * mediaheight(context),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Positioned(
                  top: .05 * mediaheight(context),
                  left: .03 * mediawidth(context),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                  ),
                ),
                Positioned(
                  top: .07 * mediaheight(context),
                  right: .03 * mediawidth(context),
                  child: Transform.scale(
                    scale: 1.5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0 * mediaheight(context),
                  child: Container(
                    width: mediawidth(context),
                    height: .4 * mediaheight(context),
                    color: Colors.black.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            child: Text(
                              "قاعة غيم",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "جدة - حي الشاطئ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                          // Add TabBar and TabBarView
                          TabBar(
                            indicatorPadding:
                                EdgeInsets.only(bottom: 5, left: 20),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 5,
                            unselectedLabelColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            dividerColor: Colors.transparent,
                            tabs: [
                              Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ontapped
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: 5))),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Text("اراء وتقيميات")],
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ontappednap
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: 5))),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Text("نبذة")],
                                  ),
                                ),
                              ),
                            ],
                            labelColor: Colors.white,
                            onTap: (index) {
                              setState(() {
                                ontapped = index == 0 ? true : false;
                                ontappednap = index == 1 ? true : false;
                              });
                            },
                            indicatorColor: primary,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                OpinionBody(),

                                AboutBody() // Add body for Tab 2
                              ],
                            ),
                          ),

                          Center(
                            child: MaterialButton(
                              minWidth: .7 * mediawidth(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: primary,
                              onPressed: () {},
                              child: Text(
                                "المزيد",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

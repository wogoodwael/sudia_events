import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class HotelContainer extends StatefulWidget {
  const HotelContainer({super.key});

  @override
  State<HotelContainer> createState() => _HotelContainerState();
}

class _HotelContainerState extends State<HotelContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: .97 * mediawidth(context),
      height: 300,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            width: .97 * mediawidth(context),
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: primary)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 5),
                            width: 70,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: primary),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "SR",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  "8000",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text("قصر المجد للافراح "),
                          Row(
                            children: [
                              Text(
                                "جدة- حي الشاطئ",
                                style: TextStyle(color: primary, fontSize: 10),
                              ),
                              Icon(
                                Icons.location_on,
                                size: 10,
                                color: primary,
                              ),
                            ],
                          )
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: primary,
                        radius: 20,
                        child: Center(
                          child: Image.asset(
                            "assets/images/just_logo.png",
                            color: Colors.white,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up_outlined,
                        color: Colors.grey,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          " نبذه عن القصر ومواصفاته ونبذه ع نبذه عن القصر ومواصفاته ونبذه عن نبذه عن القصر  نبذه عن القصر ومواصفاته ونبذه  ومواصفاته ونبذه عن",
                          softWrap: true,
                          style: TextStyle(fontSize: 7),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

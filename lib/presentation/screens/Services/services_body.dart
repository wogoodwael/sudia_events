import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/helper/custom_date.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Services/discount_slider.dart';
import 'package:sudia_events/presentation/screens/Services/hotel_container.dart';
import 'package:sudia_events/presentation/screens/Services/services_slider.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  List<bool> onTapped = [false, false, false, false, false];
  List<String> data = [
    " سيارات",
    "افراح",
    "استراحات",
    "سيارات",
    "قاعات افراح",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ServiceSlider(),
        DiscountSlider(),
        Divider(
          endIndent: 10,
          indent: 10,
        ),
        SizedBox(
          height: 40,
        ),
        Stack(
          children: [
            Container(
              width: mediawidth(context),
              height: 20,
              child: Divider(
                endIndent: 70,
              ),
            ),
            Positioned(
                right: 10,
                child: Container(
                  width: 170,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Color(0xff544c84),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        reversedDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "الجمعة",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "قاعات افراح ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ))
          ],
        ),
        HotelContainer()
      ]),
    );
  }
}

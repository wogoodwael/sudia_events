import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/custom_date.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: .95 * mediawidth(context),
        height: 65,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "الاحد",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  reversedDate,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    "زواج محمد احمد الشمري ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        " جدة قاعة الشروق ",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: primary,
              radius: 25,
              child: FittedBox(
                child: Image.asset(
                  "assets/images/just_logo.png",
                  color: Colors.white,
                  width: 40,
                  height: 60,
                ),
              ),
            ),
          ],
        ));
  }
}

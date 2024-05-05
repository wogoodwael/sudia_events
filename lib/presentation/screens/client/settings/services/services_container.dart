import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class ServicesContainer extends StatelessWidget {
  const ServicesContainer({super.key, required this.selected});
  final bool selected;
  @override
  Widget build(BuildContext context) {
    String reverseDate(String date) {
      // Split the date string by '/'
      List<String> parts = date.split('/');

      // Parse the parts into integers
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      // Create a DateTime object
      DateTime dateTime = DateTime(year, month, day);

      // Format the DateTime object as a string in the desired format
      String reversedDate =
          '${dateTime.year}/${dateTime.month}/${dateTime.day}';

      return reversedDate;
    }

    String originalDate = '11/8/2020';
    String reversedDate = reverseDate(originalDate);
    return Container(
        width: .95 * mediawidth(context),
        height: 70,
        decoration: BoxDecoration(
            color: selected ? secondary : Color(0xfff3f3f3),
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "الاتنين",
                  style: TextStyle(
                      color: selected ? Colors.white : Colors.grey,
                      fontSize: 15),
                ),
                Text(
                  reversedDate,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            VerticalDivider(
              indent: 5,
              endIndent: 5,
              color: selected
                  ? Colors.white
                  : Colors.grey, // Optional: specify the color of the divider
              thickness: 1, // Optional: specify the thickness of the divider
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    "زواج علي سعيد محمد ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: selected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
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
                            color: selected ? Colors.white : Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.location_on,
                        color: selected ? Colors.white : Colors.grey[700],
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Image.asset(
                "assets/images/just_logo.png",
                color: primary,
                width: 100,
              ),
            ),
          ],
        ));
  }
}

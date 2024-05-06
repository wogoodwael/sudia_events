import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class DataBody extends StatelessWidget {
  const DataBody({super.key, required this.borderColor, required this.containerColor, required this.dayText, required this.dayColor, required this.dateText, required this.dateColor, required this.event, required this.eventColor, required this.locationColor, required this.iconLocationColor, required this.iconSaveColor});
  final Color borderColor;
  final Color containerColor;
  final Color dayColor;
  final Color dateColor;
  final Color eventColor;
  final Color iconLocationColor;
  final Color locationColor;
  final Color iconSaveColor;
  final String dayText;
  final String dateText;
  final String event;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: .9 * mediawidth(context),
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      borderColor),
              color: containerColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${dayText}",
                      style: TextStyle(
                          color:dayColor,
                          fontSize: 15),
                    ),
                    Text(
                      "${dateText}",
                      style: TextStyle(
                        color: dateColor,
                        fontSize: 15,
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
                        "${event}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: eventColor,
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
                                color: locationColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.location_on,
                            color:iconLocationColor,
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
                  child: Center(
                    child: Image.asset(
                      "assets/images/just_logo.png",
                      color: Colors.white,
                      width: 40,
                    ),
                  ),
                ),
              ],
            )),
        Positioned(
            top: -1,
            left: 20,
            child: Icon(
              Icons.bookmark,
              size: 20,
              color:iconSaveColor,
            ))
      ],
    );
  }
}

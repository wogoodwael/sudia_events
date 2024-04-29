import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class EditBody extends StatelessWidget {
  const EditBody({super.key});

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
    return Expanded(
      flex: 4,
      child: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8),
                height: 70,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    title: Text(
                      "زواج علي سعيد محمد ",
                      textDirection: TextDirection.rtl,
                    ),
                    subtitleTextStyle: TextStyle(color: Colors.grey),
                    titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          " جدة قاعة الشروق ",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 17,
                        ),
                      ],
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Image.asset(
                        "assets/images/just_logo.png",
                        color: primary,
                        width: 100,
                      ),
                    ),
                    leading: Column(
                      children: [
                        Text(
                          "الاتنين",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          reversedDate,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.ltr,
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }
}

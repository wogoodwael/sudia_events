import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class PrevoiusBody extends StatelessWidget {
  const PrevoiusBody({super.key});

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
          margin: EdgeInsets.only(top: 10, left: 2, right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 90, right: 20, top: 50),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            width: .74 * mediawidth(context),
                            height: 50,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textDirection: TextDirection.ltr,
                                    )
                                  ],
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ),
                                    FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            " جدة قاعة الشروق ",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Image.asset(
                                    "assets/images/just_logo.png",
                                    color: primary,
                                    width: 100,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: .74 * mediawidth(context),
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: primary),
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.grey,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "حذف المناسبة",
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: primary),
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_sharp,
                                      color: Colors.grey,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "تغير الموعد",
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: primary),
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_circle,
                                      color: Colors.grey,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "حذف خدمات",
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: primary),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: primary,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "اضافة خدمات ",
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                  thickness: 3,
                  endIndent: 5,
                  indent: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 40, right: 20, top: 30),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            width: .74 * mediawidth(context),
                            height: 50,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textDirection: TextDirection.ltr,
                                    )
                                  ],
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ),
                                    FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            " جدة قاعة الشروق ",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Image.asset(
                                    "assets/images/just_logo.png",
                                    color: primary,
                                    width: 100,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                  thickness: 3,
                  endIndent: 5,
                  indent: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 90, right: 20, top: 50),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            width: .74 * mediawidth(context),
                            height: 50,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textDirection: TextDirection.ltr,
                                    )
                                  ],
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ),
                                    FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            " جدة قاعة الشروق ",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Image.asset(
                                    "assets/images/just_logo.png",
                                    color: primary,
                                    width: 100,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: .74 * mediawidth(context),
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: primary),
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.grey,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "حذف المناسبة",
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: primary),
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_sharp,
                                      color: Colors.grey,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "تغير الموعد",
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: primary),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_circle,
                                      color: Colors.grey,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "حذف خدمات",
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                // decoration: BoxDecoration(
                                //     border:
                                //         Border.all(color: primary),
                                //     borderRadius:
                                //         BorderRadius.circular(5),
                                //     color: Colors.grey[200]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: primary,
                                    ),
                                    FittedBox(
                                        child: Text(
                                      "اضافة خدمات ",
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

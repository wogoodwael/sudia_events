import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  int _selectedIndex = 0;

  AccountListModel? accountListModel;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    previous = true;
  }

  bool previous = false;
  bool edit = false;
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
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _selectedIndex == 0 ? primary : Colors.grey,
                            width: 3))),
                child: Image.asset(
                  "assets/images/person.png",
                  width: 60,
                )),
            label: 'حسابي ',
          ),
          BottomNavigationBarItem(
            icon: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _selectedIndex == 1 ? primary : Colors.grey,
                            width: 3))),
                child: Image.asset(
                  "assets/images/services.png",
                  width: 60,
                )),
            label: 'الخدمات',
          ),
          BottomNavigationBarItem(
            icon: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _selectedIndex == 2 ? primary : Colors.grey,
                            width: 3))),
                child: Image.asset(
                  "assets/images/booking.png",
                  width: 60,
                )),
            label: 'الحجوزات',
          ),
          BottomNavigationBarItem(
            icon: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _selectedIndex == 3 ? primary : Colors.grey,
                            width: 3))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    "assets/images/appointments.png",
                    width: 60,
                  ),
                )),
            label: 'المواعيد',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(children: [
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
                  padding: const EdgeInsets.only(bottom: 80.0),
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
                  margin: EdgeInsets.only(top: 160),
                  width: 90,
                  height: 110,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: primary, width: 2))),
                  child: const Column(
                    children: [
                      CircleAvatar(
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
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "حجوزاتي",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      previous = false;
                      edit = true;
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      border: !edit
                          ? Border.all(color: primary)
                          : Border.all(color: Colors.white),
                      color: edit ? primary : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "تعديل حجوزاتي",
                        style: TextStyle(
                          color: edit ? Colors.white : primary,
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
                      previous = true;
                      edit = false;
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: previous ? primary : Colors.white,
                      border: !previous
                          ? Border.all(color: primary)
                          : Border.all(color: Colors.white),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "حجوزاتي السابقه",
                        style: TextStyle(
                          color: previous ? Colors.white : primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      height: 70,
                      color: primary,
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
          )
        ],
      ),
    );
  }
}

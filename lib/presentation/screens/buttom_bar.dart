import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/Reservation/reservation.dart';
import 'package:sudia_events/presentation/screens/Services/services_screen.dart';
import 'package:sudia_events/presentation/screens/client/account/profile_screen.dart';
import 'package:sudia_events/presentation/screens/home/home.dart';
import 'package:sudia_events/presentation/screens/notification/notification.dart';

class BottomBarScreen extends StatefulWidget {
  BottomBarScreen(
      {Key? key, required this.id, this.public, this.uniquId, this.date})
      : super(key: key);
  final String id;
  bool? public;
  String? uniquId;
  DateTime? date;

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(
        id: widget.id,
        public: widget.public ?? false,
      ),
      // MyAccountScreen(),
      AddServices(
        date: DateTime.now(),
        inside: false,
        id: widget.id,
        uniquId: widget.uniquId ?? "",
      ),
      ReservationScreen(
        id: widget.id,
      ),
      // AppointmentScreen(),
      NotificationScreen(),
      ProfileScreen(),
      // UserFormScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double _calculatePosition(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 5.2;
    return index * itemWidth + itemWidth / 2 - 30; // Adjust the position
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Consumer<LanguageProvider>(
        builder: (BuildContext context, LanguageProvider value, Widget? child) {
          bool isEnglish =
              EasyLocalization.of(context)!.currentLocale!.languageCode == 'en';
          return Container(
            margin: EdgeInsets.only(bottom: 30, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              // Dark background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 0 ? Text("") : Icon(Icons.home),
                      label: _selectedIndex == 0 ? 'الرئيسية' : "",
                    ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 1
                          ? Text("")
                          : Icon(Icons.assignment),
                      label: _selectedIndex == 1 ? 'الخدمات' : "",
                    ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 2
                          ? Text("")
                          : Icon(Icons.shopping_bag),
                      label: _selectedIndex == 2 ? 'الحجوزات' : "",
                    ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 3
                          ? Text("")
                          : Icon(Icons.notifications),
                      label: _selectedIndex == 3 ? 'الاشعارات' : "",
                    ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 4 ? Text("") : Icon(Icons.person),
                      label: _selectedIndex == 4 ? 'الحساب' : "",
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: primary,
                  unselectedItemColor: Colors.grey,
                  onTap: _onItemTapped,
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                isEnglish
                    ? Positioned(
                        bottom:
                            30, // Adjust this value to fit the circle in the middle
                        left: _calculatePosition(_selectedIndex),
                        child: GestureDetector(
                          onTap: () => _onItemTapped(_selectedIndex),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: primary,
                            child: Icon(
                              _selectedIndex == 0
                                  ? Icons.home
                                  : _selectedIndex == 1
                                      ? Icons.assignment
                                      : _selectedIndex == 2
                                          ? Icons.shopping_bag
                                          : _selectedIndex == 3
                                              ? Icons.notifications
                                              : Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        bottom:
                            30, // Adjust this value to fit the circle in the middle
                        right: _calculatePosition(_selectedIndex),
                        child: GestureDetector(
                          onTap: () => _onItemTapped(_selectedIndex),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: primary,
                            child: Icon(
                              _selectedIndex == 0
                                  ? Icons.home
                                  : _selectedIndex == 1
                                      ? Icons.assignment
                                      : _selectedIndex == 2
                                          ? Icons.shopping_bag
                                          : _selectedIndex == 3
                                              ? Icons.notifications
                                              : Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

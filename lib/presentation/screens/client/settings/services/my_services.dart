import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/Reservation/reservation.dart';
import 'package:sudia_events/presentation/screens/appointments/appointments.dart';
import 'package:sudia_events/presentation/screens/client/settings/services/prevoius_body.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/header_services.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  static TextStyle optionStyle =
      const TextStyle(fontFamily: 'JF',fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const Column(
        children: [
          Header(
            text: 'حجوزاتي',
            paddingButtom: 80.0,
            paddingTop: 60,
          ),
          SizedBox(
            height: 20,
          ),
          PrevoiusBody()
        ],
      ),
      // AddServices(),
      const ReservationScreen(),
      const AppointmentScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 3,
                  ),
                ),
              ),
              child: Image.asset(
                "assets/images/person.png",
                width: 60,
              ),
            ),
            label: 'حسابي ',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == 1 ? primary : Colors.grey,
                    width: 3,
                  ),
                ),
              ),
              child: Image.asset(
                "assets/images/services.png",
                width: 60,
              ),
            ),
            label: 'الخدمات',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == 2 ? primary : Colors.grey,
                    width: 3,
                  ),
                ),
              ),
              child: Image.asset(
                "assets/images/booking.png",
                width: 60,
              ),
            ),
            label: 'الحجوزات',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == 3 ? primary : Colors.grey,
                    width: 3,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Image.asset(
                  "assets/images/appointments.png",
                  width: 60,
                ),
              ),
            ),
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
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
    );
  }
}

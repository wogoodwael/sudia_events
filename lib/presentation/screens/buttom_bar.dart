import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/Reservation/reservation.dart';
import 'package:sudia_events/presentation/screens/appointments/appointments.dart';
import 'package:sudia_events/presentation/screens/client/account/my_account.dart';

class ButtomBarScreen extends StatefulWidget {
  ButtomBarScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<ButtomBarScreen> createState() => _ButtomBarScreenState();
}

class _ButtomBarScreenState extends State<ButtomBarScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Widget>? _widgetOptions;

  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      MyAccountScreen(),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      ReservationScreen(
        id: widget.id,
      ),
      AppointmentScreen()
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
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
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
    );
  }
}

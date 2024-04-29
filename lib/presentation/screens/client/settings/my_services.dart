import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/buttons_services.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/edit_body.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/header_services.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/prevoius_body.dart';

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
          const HeaderOfServices(),
          const SizedBox(
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
                    child: CustomButton(edit: edit)),
                const SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        previous = true;
                        edit = false;
                      });
                    },
                    child: CustomButton(
                      edit: previous,
                    )),
              ],
            ),
          ),
          !edit ? EditBody() : PrevoiusBody()
        ],
      ),
    );
  }
}

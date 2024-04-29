import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';
import 'package:sudia_events/data/model/settings_model.dart';
import 'package:sudia_events/presentation/screens/client/account/account_list.dart';
import 'package:sudia_events/presentation/screens/client/settings/settings_list.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 0;
  AccountListModel? accountListModel;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List color = [Colors.grey, Colors.grey, Colors.red];
    List<SettingsModel> accounts = [
      SettingsModel(
          title: 'حجوزاتي',
          subTitle: '+965326326',
          ontap: () {
            Navigator.pushNamed(context, myServices);
          },
          trailing: Icons.person_remove_alt_1_outlined,
          leading: Icons.arrow_back_ios),
      SettingsModel(
          title: 'حذف الحساب ',
          subTitle: '',
          ontap: () {},
          trailing: Icons.person_remove_alt_1_outlined,
          leading: Icons.arrow_back_ios),
      SettingsModel(
          title: 'تسجيل الخروج',
          subTitle: '',
          ontap: () {},
          trailing: Icons.logout,
          leading: Icons.arrow_back_ios),
    ];

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
            flex: 2,
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
                          "الاعدادات",
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
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: accounts[index].ontap,
                        child: SettingsList(
                          settingsModel: accounts[index],
                          color: color[index],
                        ));
                  }),
            ),
          )
        ],
      ),
    );
  }
}

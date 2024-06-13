import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

import '../Services/services_screen.dart';

class BookingScreen extends StatefulWidget {
  final DateTime bookingDate;

  const BookingScreen({super.key, required this.bookingDate});
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSwitched = false;
  bool _isAgreed = false;
  TextEditingController name = TextEditingController();
  TextEditingController family = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController tribe = TextEditingController();
  Future<void> _showPopup(BuildContext context) async {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text('تفاصيل',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'الاسم',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.withOpacity(.5))),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: 'محمد علي الزهراني',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'على ابنة',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.withOpacity(.5))),
                    child: TextField(
                      controller: family,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: 'احمد علي الزهراني',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'القبيلة',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.withOpacity(.5))),
                    child: TextField(
                      controller: tribe,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: 'الزهراني',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${DateFormat('yyyy/MM/dd').format(widget.bookingDate)}',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      Text(
                        '${_selectedTime.format(context)}',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: .8 * mediawidth(context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey.withOpacity(.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Image.asset(
                                "assets/images/phone.png",
                                width: 50,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: Image.asset(
                                "assets/images/locationb.png",
                                color: Colors.grey,
                                width: 50,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: Image.asset(
                                "assets/images/message.png",
                                color: Colors.grey,
                                width: 50,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _saveDataToFirestore();
                          },
                          child: Image.asset(
                            "assets/images/send.png",
                            width: 50,
                          ),
                        ),
                        Text("ارسال بطاقة الدعوة"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveDataToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference reservation =
        firebaseFirestore.collection('reservation');

    // Create a map representing the event data
    Map<String, dynamic> eventData = {
      'userID': sharedpref.getString('token'),
      'name': name.text,
      'phone': phone.text,
      'date': widget.bookingDate.toIso8601String(),
      'family': family.text,
      'tribe': tribe.text
    };

    // Add the event data to Firestore
    reservation.add(eventData).then((value) {
      print('Event added successfully!');
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تم بنجاح'),
            content: Text('لقد تم حجز مناسبتك ينجاح هل تريد اضافة خدمات؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddServices(
                              date: widget.bookingDate,
                            )),
                  );
                },
                child: Text('نعم'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BottomBarScreen(
                              id: sharedpref.getString('token')!,
                            )),
                  );
                },
                child: Text('لا'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print('Failed to add event: $error');
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add event: $error'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEE dd/MM/yyyy').format(widget.bookingDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text(
          'الحجوزات',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('تهانينا .. !', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Image.asset(
                "assets/images/heart.png",
                width: 120,
              ),
              SizedBox(height: 10),
              Text('تستطيع اختيار الحجز', style: TextStyle(fontSize: 15)),
              SizedBox(height: 15),
              Text(formattedDate,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حالة الحجز',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: .1 * mediawidth(context),
                  ),
                  Text('مكرر', style: TextStyle(fontSize: 15)),
                ],
              ),
              Divider(
                height: 0,
                indent: .2 * mediawidth(context),
                endIndent: .2 * mediawidth(context),
              ),
              SizedBox(height: .05 * mediaheight(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الوقت:',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: .8 * mediawidth(context),
                      height: 40,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: .7,
                            child: Switch(
                              activeColor: primary,
                              value: _isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  _isSwitched = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: .37 * mediawidth(context)),
                          Text(
                            _selectedTime.format(context),
                            style: TextStyle(fontSize: 15),
                          ),
                          GestureDetector(
                              onTap: () async {
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime,
                                );
                                if (pickedTime != null &&
                                    pickedTime != _selectedTime) {
                                  setState(() {
                                    _selectedTime = pickedTime;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.timer_sharp,
                                  size: 20,
                                  color: Colors.green,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('ليصلك اخبارك وأصدقائك',
                  style: TextStyle(color: Colors.grey)),
              Container(
                width: .9 * mediawidth(context),
                height: .35 * mediaheight(context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(.5))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Image.asset(
                              "assets/images/phone.png",
                              width: 50,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Image.asset(
                              "assets/images/message.png",
                              color: Colors.grey,
                              width: 50,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Image.asset(
                              "assets/images/locationb.png",
                              color: Colors.grey,
                              width: 50,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: primary,
                          value: _isAgreed,
                          onChanged: (value) {
                            setState(() {
                              _isAgreed = value!;
                            });
                          },
                        ),
                        Text('أنا أوافق على شروط الخدمة و سياسة الخصوصية'),
                      ],
                    ),
                    SizedBox(height: 16),
                    MaterialButton(
                      onPressed: () {
                        _showPopup(context);
                      },
                      minWidth: .8 * mediawidth(context),
                      height: 45,
                      color: _isAgreed ? primary : secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('التالي',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 16),
                    MaterialButton(
                      onPressed: () {},
                      minWidth: .8 * mediawidth(context),
                      height: 45,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('مشاهدة الحجوزات',
                          style: TextStyle(
                              fontSize: 20,
                              color: primary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

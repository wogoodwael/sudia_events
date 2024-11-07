// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart' as data;
import 'package:sudia_events/core/helper/calender.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/All/invitation.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../Services/All/services_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
  });
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSwitched = false;
  final bool _isAgreed = false;
  List<bool> onTapped = [false, false, false, false];
  TextEditingController name = TextEditingController();
  TextEditingController family = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController tribe = TextEditingController();
  List services = ['زواج', 'حفل تخرج', 'عيد ميلاد', "خطوبة"];
  String selectedService = 'زواج';
   String uniqueID = const Uuid().v4();
  void _onServiceSelected(int index) {
    setState(() {
      for (int i = 0; i < onTapped.length; i++) {
        onTapped[i] = i == index;
      }
      selectedService = services[index];
      isFav = false; // Reset favorites when a specific service is selected
    });
  }

  Future<void> _saveDataToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference reservation =
        firebaseFirestore.collection('reservation');

    // Split the name into parts

   
    sharedpref.setString('uniquId', uniqueID);
    // Create a map representing the event data
    Map<String, dynamic> eventData = {
      'userID': sharedpref.getString('token'),
      'name': sharedpref.getString('user'),
      'phone': phone.text,
      'date': _selectedDay!.toIso8601String(),
      'type': selectedService,
      'time': _selectedTime.format(context),
      'uniquID': uniqueID, 
      'cardId':sharedpref.getString('cardId')??""
    };

    // Add the event data to Firestore
    reservation.add(eventData).then((value) {
      print('Event added successfully!');
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BottomBarScreen(
                                id: sharedpref.getString('token')!,
                                public: false,
                                uniquId: uniqueID,
                                date: _selectedDay,
                              )));
                },
                child: const Align(
                    alignment: Alignment.topLeft, child: Icon(Icons.close))),
            title: Center(
              child: Text(
                'تهانينا',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600, fontSize: 30),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/heart.png"),
                Text(
                  " حجزك رقم SP 0023905# . ☺️",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  "    في يوم  ${DateFormat('yyyy/MM/dd', 'ar').format(_selectedDay!)}         ${_selectedTime.format(context)}",
                  style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w400),
                )
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                minWidth: .9 * mediawidth(context),
                color: primary,
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddServices(
                              date: _selectedDay!,
                              inside: true,
                              id: sharedpref.getString('token')!,
                              uniquId: uniqueID,
                            )),
                    // This predicate removes all previous routes
                  );
                },
                child: Text(
                  'اضافة خدمات',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white),
                ),
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
            title: const Text('Error'),
            content: Text('Failed to add event: $error'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  Api api = Api();
  late final ValueNotifier<List<Event>> _selectedEvents;
  TextEditingController searchController = TextEditingController();
  List<Event> filteredEvents = [];
  bool isFav = false;
  bool addService = false;
  bool tappedFamily = false;
  bool tappedTribe = false;
  bool onTappedIcon = false;
  @override
  void initState() {
    super.initState();

    tappedFamily = false;
    tappedTribe = false;
    onTappedIcon = false;
    _selectedDay = _focusedDay;
    data.initializeDateFormatting('ar');
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    api.fetchEventsFromFirestore().then((fetchedEvents) {
      setState(() {
        events = fetchedEvents;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
        filteredEvents = _getAllEvents();
      });
    });

    // Listen for changes in the search controller and filter events
    searchController.addListener(_filterEvents);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    searchController.removeListener(_filterEvents);
    searchController.dispose();
    super.dispose();
  }

  void _filterEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = _getAllEvents().where((event) {
        return event.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  List<Event> _getAllEvents() {
    return events.values.expand((eventList) => eventList).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  bool isEventSelectedDay(DateTime eventDate) {
    return isSameDay(eventDate, _selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEE dd/MM/yyyy').format(_selectedDay!);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'booked'.tr(),
          style: const TextStyle(fontFamily: 'JF',color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(services.length, (index) {
                  return ChoiceChip(
                    checkmarkColor: Colors.white,
                    selectedColor: primary,
                    label: Text(
                      services[index],
                      style: TextStyle(fontFamily: 'JF',
                          color: onTapped[index] ? Colors.white : Colors.black),
                    ),
                    selected: onTapped[index],
                    onSelected: (_) => _onServiceSelected(index),
                  );
                }),
              ),
              CustomCalendar(
                selectedDay: _selectedDay!,
                focusedDay: _focusedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay, focusedDay);
                },
                getEventsForDay: _getEventsForDay,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: .8 * mediawidth(context),
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.timer_sharp,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _selectedTime.format(context),
                              style: const TextStyle(fontFamily: 'JF',fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(formattedDate,
                  style: const TextStyle(fontFamily: 'JF',
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حالة الحجز',
                      style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w400)),
                  SizedBox(
                    width: .1 * mediawidth(context),
                  ),
                  Text(
                      _getEventsForDay(_selectedDay ?? DateTime.now())
                              .isNotEmpty
                          ? 'مكرر'
                          : 'جديد',
                      style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w400)),
                  SizedBox(
                    width: .1 * mediawidth(context),
                  ),
                  Text(selectedService,
                      style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w400)),
                ],
              ),
              Divider(
                height: 0,
                indent: .2 * mediawidth(context),
                endIndent: .2 * mediawidth(context),
              ),
              SizedBox(height: .05 * mediaheight(context)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InvitationCardScreen(
                              id: const Uuid().v4(), date: _selectedDay!, eventId: uniqueID,)));
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.black87,
                      radius: 10,
                      child: Icon(
                        Icons.add,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "بطاقة الدعوة",
                      style:
                          TextStyle(fontFamily: 'JF',fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: true,
                      onChanged: (val) {},
                      activeColor: primary,
                    ),
                    Image.asset(
                      "assets/images/locationb.png",
                      width: 50,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              MaterialButton(
                onPressed: () {
                  _saveDataToFirestore();
                },
                minWidth: .8 * mediawidth(context),
                height: 45,
                color: primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('التالي',
                    style: TextStyle(fontFamily: 'JF',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              MaterialButton(
                onPressed: () {},
                minWidth: .8 * mediawidth(context),
                height: 45,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('مشاهدة الحجوزات',
                    style: TextStyle(fontFamily: 'JF',
                        fontSize: 20,
                        color: primary,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

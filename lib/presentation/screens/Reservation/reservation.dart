import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudia_events/business_logic/cubit/family/family_filter_cubit.dart';

import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/events_conatiner.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/search_container.dart';
import 'package:sudia_events/presentation/screens/Services/services_screen.dart';
import 'package:sudia_events/presentation/screens/positioned_logo.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart'
    as data; // Import for date formatting initialization

// ignore: must_be_immutable
class ReservationScreen extends StatefulWidget {
  ReservationScreen({super.key,  this.id});
   String? id;
  String? gender;
  String? type;
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  bool chooseday = false;
  bool addService = false;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController family = TextEditingController();
  TextEditingController tribe = TextEditingController();
  List familyFilter = [];
  late final ValueNotifier<List<Event>> _selectedEvents;
  Api api = Api();

  @override
  void initState() {
    super.initState();
    chooseday = true;
    _selectedDay = _focusedDay;
    data.initializeDateFormatting('ar');
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    api.fetchEventsFromFirestore().then((fetchedEvents) {
      setState(() {
        events = fetchedEvents;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value =
            _getEventsForDay(_selectedDay!); // Update selected events here
        // update `_focusedDay` here as well
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  height: 190,
                  width: 400,
                  decoration: const BoxDecoration(
                    color: primary,
                  ),
                ),
              ),
              PositionedLogo(),
              Positioned(
                  bottom: -2, left: 20, top: 100, child: SearchContainer())
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      headerStyle: HeaderStyle(
                          formatButtonVisible: false, titleCentered: true),
                      eventLoader: _getEventsForDay,
                      locale: 'ar',
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2010, 3, 14),
                      lastDay: DateTime.utc(2030, 3, 14),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: _onDaySelected,
                      calendarStyle: const CalendarStyle(
                          outsideDaysVisible: true,
                          markersMaxCount: 5,
                          markerDecoration: BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: Color(0xffff8923), shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(
                              color: primary, shape: BoxShape.circle)),
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      calendarFormat: _calendarFormat,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                    Divider(
                      endIndent: 20,
                      indent: 20,
                      color: primary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              addService = true;
                              chooseday = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddServices()));
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              color: addService ? primary : Colors.white,
                              border: !addService
                                  ? Border.all(color: primary)
                                  : Border.all(color: Colors.white),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "اضافة خدمات ",
                                style: TextStyle(
                                  color: addService ? Colors.white : primary,
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
                              addService = false;
                              chooseday = true;
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              border: !chooseday
                                  ? Border.all(color: primary)
                                  : Border.all(color: Colors.white),
                              color: chooseday ? primary : Colors.white,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "اختيار اليوم ",
                                style: TextStyle(
                                  color: chooseday ? Colors.white : primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _selectedEvents.value.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: .9 * mediawidth(context),
                            height: 80,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${_selectedDay != null ? intl.DateFormat('EEEE', 'ar').format(_selectedDay!) : 'No date selected'}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${_selectedDay != null ? intl.DateFormat('yyyy/MM/dd', 'ar').format(_selectedDay!) : 'No day selected'}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'لا يوجد مناسبات في هذا التاريخ  ',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    endIndent: 10,
                                    indent: 10,
                                    color: Colors.grey[200],
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: Image.asset(
                                        "assets/images/just_logo.png",
                                        color: primary,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: .9 * mediawidth(context),
                            height: 120,
                            child: ValueListenableBuilder(
                              valueListenable: _selectedEvents,
                              builder: (context, value, child) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // Disable scrolling

                                  shrinkWrap: true,
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      width: .9 * mediawidth(context),
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${_selectedDay != null ? intl.DateFormat('EEEE', 'ar').format(_selectedDay!) : 'No date selected'}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${_selectedDay != null ? intl.DateFormat('yyyy/MM/dd', 'ar').format(_selectedDay!) : 'No day selected'}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              FittedBox(
                                                  child: Text(
                                                '${value[index].name}',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ))
                                            ],
                                          ),
                                          VerticalDivider(
                                            endIndent: 20,
                                            indent: 10,
                                            color: Colors.grey[200],
                                          ),
                                          Center(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 25,
                                              child: Image.asset(
                                                "assets/images/just_logo.png",
                                                color: primary,
                                                width: 40,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    EventsContainer(
                      name: name,
                      family: family,
                      tribe: tribe,
                      phone: phone,
                      onPressed: () {
                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        CollectionReference reservation =
                            firebaseFirestore.collection('reservation');

                        // Create a map representing the event data
                        Map<String, dynamic> eventData = {
                          'userID': widget.id,
                          'name': name.text,
                          'phone': phone.text,
                          'gender': widget.gender,
                          'type': widget.type,
                          'date': _selectedDay!.toIso8601String(),
                          'family': family.text,
                          'tribe': tribe.text
                        };

                        // Add the event data to Firestore
                        reservation.add(eventData).then((value) {
                          print('Event added successfully!');
                        }).catchError((error) {
                          print('Failed to add event: $error');
                        });

                        // Check if events already exist for the selected day
                        if (events.containsKey(_selectedDay)) {
                          // Append the new event to the existing list of events
                          events[_selectedDay]!.add(
                            Event(
                                date: _selectedDay!,
                                name: name.text,
                                phone: phone.text,
                                gender: widget.gender ?? '',
                                type: widget.type ?? "",
                                family: family.text,
                                tribe: tribe.text),
                          );
                        } else {
                          // Create a new list with the new event
                          events[_selectedDay!] = [
                            Event(
                                date: _selectedDay!,
                                name: name.text,
                                phone: phone.text,
                                gender: widget.gender ?? '',
                                type: widget.type ?? "",
                                family: family.text,
                                tribe: tribe.text),
                          ];
                        }

                        // Update the selected events
                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
                        setState(() {
                          _selectedEvents;
                        });

                        // Clear the text controllers
                        name.clear();
                        phone.clear();
                      },
                      widgetRow: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              setState(() {
                                widget.type = value;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'نوع المناسبة 1',
                                child: Text('نوع المناسبة 1'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'نوع المناسبة 2',
                                child: Text('نوع المناسبة 2'),
                              ),
                              // Add more PopupMenuItem for additional options
                            ],
                            // Custom icon with desired color
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: primary)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey),
                                    Text(
                                      widget.type ?? 'نوع المناسبة',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              setState(() {
                                widget.gender = value;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'ذكر',
                                child: Text('ذكر'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'أنثى',
                                child: Text('أنثى'),
                              ),
                              // Add more PopupMenuItem for additional options
                            ],
                            // Custom icon with desired color
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: primary)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey),
                                    Text(
                                      widget.gender ?? "انثي /ذكر",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

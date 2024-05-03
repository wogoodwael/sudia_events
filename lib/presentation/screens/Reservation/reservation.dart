import 'package:flutter/material.dart';

import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/events_conatiner.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/search_container.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart'
    as data; // Import for date formatting initialization

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

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
  TextEditingController type = TextEditingController();
  TextEditingController gender = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  @override
  void initState() {
    super.initState();
    chooseday = true;
    _selectedDay = _focusedDay;
    data.initializeDateFormatting('ar');
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
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
              Positioned(
                  top: 50,
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 150,
                      color: Colors.white,
                    ),
                  )),
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
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
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
                            width: .9 * mediawidth(context),
                            height: 80,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    FittedBox(
                                        child: Text(
                                      'لا يوجد مناسبات في هذا التاريخ حسب التصنيف يمكنك الحجز',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
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
                                      width: 100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: .9 * mediawidth(context),
                            height: 100,
                            child: ValueListenableBuilder(
                              valueListenable: _selectedEvents,
                              builder: (context, value, child) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics:
                                      NeverScrollableScrollPhysics(), // Disable scrolling

                                  shrinkWrap: true,
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    return Container(
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
                                                '${value[index].title}',
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
                                                width: 100,
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
                      height: 10,
                    ),
                    EventsContainer(
                      name: name,
                      gender: gender,
                      type: type,
                      phone: phone,
                      onPressed: () {
                        events.addAll({
                          _selectedDay!: [
                            Event(name.text, phone.text, gender.text, type.text)
                          ]
                        });
                        print(events);
                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
                        setState(() {
                          _selectedEvents;
                        });
                        name.clear();
                        phone.clear();
                        gender.clear();
                        type.clear();
                      },
                    )
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

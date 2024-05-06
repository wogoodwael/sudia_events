import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/data/services/filter.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart' as data;

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Api api = Api();
  Map<DateTime, List<Event>> events = {};
  List<Event>? eventData;
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool tapped = false;
  List<Map<String, dynamic>>? familyFilter;
  TextEditingController controllerfamily = TextEditingController();
  TextEditingController controllertribe = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool tappedFamily = false;
  bool tappedTribe = false;
  bool onTappedIcon = false;
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
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
        tapped = true; // Set tapped to true when a day is selected
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
    List<String> parts = searchController.text.split(" ");
    String first =
        parts.isNotEmpty ? parts[0] : ""; // Check if parts is not empty
    String secondPart = parts.length > 1
        ? parts.sublist(1).join("")
        : ""; // Join the remaining parts if available
    first = first.replaceAll(" ", "");

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  top: 40,
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 150,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                bottom: -1,
                left: 20,
                top: 90,
                child: Center(
                  child: Container(
                    width: .9 * mediawidth(context),
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: .8 * mediawidth(context),
                            decoration: BoxDecoration(
                                border: Border.all(color: primary),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: 30,
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: primary,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 70,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: primary)),
                                child: Center(
                                  child: FittedBox(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text("نوع المناسبه "),
                                  )),
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: primary)),
                                child: Center(
                                  child: FittedBox(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text("المدينة"),
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tappedFamily = !tappedFamily;
                                  });
                                  print(
                                      "@@${filterEventsByFamily(controllerfamily.text)}");
                                },
                                child: Container(
                                  width: 70,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: tappedFamily || onTappedIcon
                                          ? primary
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: primary)),
                                  child: Center(
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        "العائلة",
                                        style: TextStyle(
                                            color: tappedFamily || onTappedIcon
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tappedTribe = !tappedTribe;
                                  });
                                },
                                child: Container(
                                  width: 70,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: tappedTribe || onTappedIcon
                                          ? primary
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: primary)),
                                  child: Center(
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        "القبيلة",
                                        style: TextStyle(
                                            color: tappedTribe || onTappedIcon
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      onTappedIcon = !onTappedIcon;
                                    });
                                    print(
                                        "@***@${filterEventsByFamilyAndTribe(first, secondPart)}");
                                    print(
                                        "firsssssssst$first, secooond $secondPart");
                                  },
                                  child: Icon(Icons.filter_list))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 5,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      rowHeight: 40,
                      headerVisible: true,
                      headerStyle: HeaderStyle(
                          headerPadding: EdgeInsets.symmetric(vertical: 5),
                          formatButtonVisible: false,
                          titleCentered: true),
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
                              color: secondary, shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(
                              color: primary, shape: BoxShape.circle)),
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      endIndent: 20,
                      indent: 20,
                      color: primary,
                    ),
                    Container(
                      width: .9 * mediawidth(context),
                      height: 200,
                      child: FutureBuilder<List<Event>>(
                        future: tappedFamily
                            ? filterEventsByFamily(first)
                            : tappedTribe
                                ? filterEventsByTribe(first)
                                : onTappedIcon
                                    ? filterEventsByFamilyAndTribe(
                                        first, secondPart)
                                    : api.fetchReservationData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Event>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: primary,
                              ),
                            ); // Show a loading indicator while fetching data
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                            ); // Show an error message if data fetching fails
                          } else {
                            // Filter events with family name containing "محمد"

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              // Use the length of the filtered events
                              itemBuilder: (context, index) {
                                Event event = snapshot.data![index];

                                /// Get the event at the current index
                                return Stack(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: .9 * mediawidth(context),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  isEventSelectedDay(event.date)
                                                      ? Colors.white
                                                      : primary),
                                          color: isEventSelectedDay(event.date)
                                              ? secondary
                                              : const Color.fromARGB(
                                                  255, 239, 238, 238),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${_selectedDay != null ? intl.DateFormat('EEEE', 'ar').format(snapshot.data![index].date) : 'No date selected'}",
                                                  style: TextStyle(
                                                      color: isEventSelectedDay(
                                                              event.date)
                                                          ? Colors.white
                                                          : Colors.grey,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "${_selectedDay != null ? intl.DateFormat('yyyy/MM/dd', 'ar').format(snapshot.data![index].date) : 'No day selected'}",
                                                  style: TextStyle(
                                                    color: isEventSelectedDay(
                                                            event.date)
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    "${snapshot.data![index].name} ${snapshot.data![index].family} ${snapshot.data![index].tribe}",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: TextStyle(
                                                        color:
                                                            isEventSelectedDay(
                                                                    event.date)
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[600],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        " جدة قاعة الشروق ",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: isEventSelectedDay(
                                                                    event.date)
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[500],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(
                                                        Icons.location_on,
                                                        color:
                                                            isEventSelectedDay(
                                                                    event.date)
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[700],
                                                        size: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            CircleAvatar(
                                              backgroundColor: primary,
                                              radius: 25,
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/images/just_logo.png",
                                                  color: Colors.white,
                                                  width: 40,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                        top: -1,
                                        left: 20,
                                        child: Icon(
                                          Icons.bookmark,
                                          size: 20,
                                          color: isEventSelectedDay(event.date)
                                              ? Colors.white
                                              : primary,
                                        ))
                                  ],
                                );
                              },
                            );
                          }
                        },
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

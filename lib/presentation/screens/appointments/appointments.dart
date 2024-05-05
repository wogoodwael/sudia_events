import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/search_container.dart';
import 'package:sudia_events/presentation/screens/client/notification/offers_container.dart';
import 'package:sudia_events/presentation/screens/client/settings/services/services_container.dart';
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

  void initState() {
    super.initState();

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
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
            flex: 3,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      headerVisible: true,
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
                              color: secondary, shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(
                              color: primary, shape: BoxShape.circle)),
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            endIndent: 20,
            indent: 20,
            color: primary,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: .9 * mediawidth(context),
              height: 200,
              child: FutureBuilder<List<Event>>(
                future: api.fetchReservationData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching data
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Show an error message if data fetching fails
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: snapshot
                          .data!.length, // Use the length of the fetched data
                      itemBuilder: (context, index) {
                        Event event = snapshot
                            .data![index]; // Get the event at the current index
                        return Stack(children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: .9 * mediawidth(context),
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isEventSelectedDay(event.date)
                                        ? Colors.white
                                        : primary),
                                color: isEventSelectedDay(event.date)
                                    ? secondary
                                    : const Color.fromARGB(255, 239, 238, 238),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${_selectedDay != null ? intl.DateFormat('EEEE', 'ar').format(snapshot.data![index].date!) : 'No date selected'}",
                                        style: TextStyle(
                                            color:
                                                isEventSelectedDay(event.date!)
                                                    ? Colors.white
                                                    : Colors.grey,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "${_selectedDay != null ? intl.DateFormat('yyyy/MM/dd', 'ar').format(snapshot.data![index].date) : 'No day selected'}",
                                        style: TextStyle(
                                          color: isEventSelectedDay(event.date!)
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          "${snapshot.data![index].name}",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              color: isEventSelectedDay(
                                                      event.date!)
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.bold,
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
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: isEventSelectedDay(
                                                          event.date!)
                                                      ? Colors.white
                                                      : Colors.grey[500],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.location_on,
                                              color: isEventSelectedDay(
                                                      event.date!)
                                                  ? Colors.white
                                                  : Colors.grey[700],
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
                                    child: Image.asset(
                                      "assets/images/just_logo.png",
                                      color: Colors.white,
                                      width: 100,
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
                                color: isEventSelectedDay(event.date!)
                                    ? Colors.white
                                    : primary,
                              ))
                        ]);
                      },
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

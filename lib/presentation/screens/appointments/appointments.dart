import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' as data;
import 'package:intl/intl.dart' as intl;
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/appointments/data_body.dart';
import 'package:sudia_events/presentation/screens/positioned_logo.dart';
import 'package:table_calendar/table_calendar.dart';

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
              const PositionedLogo(),
              Positioned(
                bottom: -1,
                left: 20,
                top: 90,
                child: Center(
                  child: Container(
                    width: .9 * mediawidth(context),
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: .8 * mediawidth(context),
                            decoration: BoxDecoration(
                                border: Border.all(color: primary),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            height: 30,
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              controller: searchController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: primary,
                                  )),
                            ),
                          ),
                          const SizedBox(
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
                                child: const Center(
                                  child: FittedBox(
                                      child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text("نوع المناسبه ", style: TextStyle(fontFamily: 'JF')),
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
                                child: const Center(
                                  child: FittedBox(
                                      child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text("المدينة", style: TextStyle(fontFamily: 'JF')),
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tappedFamily = !tappedFamily;
                                  });
                                  // print(
                                  //     "@@${filterEventsByFamily(controllerfamily.text)}");
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
                                        style: TextStyle(fontFamily: 'JF',
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
                                        style: TextStyle(fontFamily: 'JF',
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
                                    // print(
                                    //     "@***@${filterEventsByFamilyAndTribe(first, secondPart)}");
                                    // print(
                                    //     "firsssssssst$first, secooond $secondPart");
                                  },
                                  child: const Icon(Icons.filter_list))
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 5,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Calender(
                    //     getEventsForDay: _getEventsForDay,
                    //     focusedDay: _focusedDay,
                    //     selectedDay: _selectedDay!,
                    //     onDaySelected: _onDaySelected),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      endIndent: 20,
                      indent: 20,
                      color: primary,
                    ),
                    SizedBox(
                      width: .9 * mediawidth(context),
                      height: 200,
                      child: FutureBuilder<List<Event>>(
                        future: api.fetchReservationData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Event>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: primary,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                            );
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              // Use the length of the filtered events
                              itemBuilder: (context, index) {
                                Event event = snapshot.data![index];

                                /// Get the event at the current index
                                return DataBody(
                                  borderColor: isEventSelectedDay(event.date)
                                      ? Colors.white
                                      : primary,
                                  containerColor: isEventSelectedDay(event.date)
                                      ? secondary
                                      : const Color.fromARGB(
                                          255, 239, 238, 238),
                                  dayText: _selectedDay != null
                                      ? intl.DateFormat('EEEE', 'ar')
                                          .format(snapshot.data![index].date)
                                      : 'No date selected',
                                  dayColor: isEventSelectedDay(event.date)
                                      ? Colors.white
                                      : Colors.grey,
                                  dateText: _selectedDay != null
                                      ? intl.DateFormat('yyyy/MM/dd', 'ar')
                                          .format(snapshot.data![index].date)
                                      : 'No day selected',
                                  dateColor: isEventSelectedDay(event.date)
                                      ? Colors.white
                                      : Colors.grey,
                                  event: ''
                                  // '${snapshot.data![index].name} ${snapshot.data![index].family} ${snapshot.data![index].tribe}',
                                  ,
                                  eventColor: isEventSelectedDay(event.date)
                                      ? Colors.white
                                      : Colors.grey[600]!,
                                  locationColor: isEventSelectedDay(event.date)
                                      ? Colors.white
                                      : Colors.grey[500]!,
                                  iconLocationColor:
                                      isEventSelectedDay(event.date)
                                          ? Colors.white
                                          : Colors.grey[700]!,
                                  iconSaveColor: isEventSelectedDay(event.date)
                                      ? Colors.white
                                      : primary,
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

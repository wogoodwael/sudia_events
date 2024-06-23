import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/events_conatiner.dart';
import 'package:sudia_events/presentation/screens/positioned_logo.dart';

class AddEventScreen extends StatefulWidget {
  AddEventScreen(
      {super.key,
      required this.id,
      required this.selectedDay,
      required this.selectedEvents});

  final String id;

  final DateTime selectedDay;
  late ValueNotifier<List<Event>> selectedEvents;
  late Map<DateTime, List<Event>> events = {};

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController family = TextEditingController();
  TextEditingController tribe = TextEditingController();
  TextEditingController phone = TextEditingController();
  String? gender;

  String? type;

  List<Event> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }

  Api api = Api();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.selectedEvents =
        ValueNotifier(_getEventsForDay(widget.selectedDay!));
    api.fetchEventsFromFirestore().then((fetchedEvents) {
      setState(() {
        widget.events = fetchedEvents;
        widget.selectedEvents.value = _getEventsForDay(widget.selectedDay!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    height: 100,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: primary,
                    ),
                  ),
                ),
                PositionedLogo(),
              ])),
          Expanded(
            flex: 12,
            child: EventsContainer(
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
                  'gender': gender,
                  'type': type,
                  'date': widget.selectedDay.toIso8601String(),
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
                if (widget.events.containsKey(widget.selectedDay)) {
                  // Append the new event to the existing list of events
                  // widget.events[widget.selectedDay]!.add(
                  //   // Event(
                  //   //     date: widget.selectedDay,
                  //   //     name: name.text,
                  //   //     phone: phone.text,
                  //   //     // gender: gender ?? "",
                  //   //     // type: type ?? "",
                  //   //     family: family.text,
                  //   //     tribe: tribe.text),
                  // );
                } else {
                  // Create a new list with the new event
                  widget.events[widget.selectedDay] = [
                    // Event(
                    //     date: widget.selectedDay!,
                    //     name: name.text,
                    //     phone: phone.text,
                    //     // gender: gender ?? '',
                    //     // type: type ?? "",
                    //     family: family.text,
                    //     tribe: tribe.text),
                  ];
                }

                // Update the selected events
                widget.selectedEvents.value =
                    _getEventsForDay(widget.selectedDay);
                setState(() {
                  widget.selectedEvents;
                });

                // Clear the text controllers
                name.clear();
                phone.clear();
              },
              widgetRow: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20.0, top: 10, bottom: 10),
                    child: Text(
                      "نوع المناسبة",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        type = value;
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
                    child: Center(
                      child: Container(
                        width: .8 * mediawidth(context),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: primary)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                              Text(
                                type ?? 'نوع المناسبة',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20.0, top: 10, bottom: 10),
                    child: Text(
                      "الجنس",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        gender = value;
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
                    child: Center(
                      child: Container(
                        width: .8 * mediawidth(context),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: primary)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                              Text(
                                gender ?? "انثي /ذكر",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

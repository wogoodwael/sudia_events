import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' as data;
import 'package:sudia_events/core/helper/appBar.dart';
import 'package:sudia_events/core/helper/calender.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class SechdualScreen extends StatefulWidget {
  final String date;
  final String day;
  final String itemName; // Add itemName to widget

  const SechdualScreen(
      {super.key,
      required this.date,
      required this.day,
      required this.itemName});

  @override
  _SechdualScreenState createState() => _SechdualScreenState();
}

class _SechdualScreenState extends State<SechdualScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay _selectedTime2 = TimeOfDay.now();

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

  Future<void> _updateReservation() async {
    // Create a DateTime object from the selected date and time
    final newDateTime = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      _selectedTime.hour - 1,
      _selectedTime.minute,
    );

    final Timestamp newTimestamp = Timestamp.fromDate(newDateTime);

    try {
      await FirebaseFirestore.instance
          .collection('booked_services')
          .where('item_name', isEqualTo: widget.itemName)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference
              .update({'timestamp': newTimestamp, 'status': "pending"});
        }
      });
      CustomSnackBar(
          context, 'sechdual'.tr(), Colors.green, mediaheight(context) - 120);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/heart.png"),
                    const Text("نقدر وقتك ",
                        style: TextStyle(fontFamily: 'JF')),
                    const Text(
                        "لقد تم ارسال الطلب الي مقدم الخدمة وسنعلمك بحالة الطلب ",
                        style: TextStyle(fontFamily: 'JF'))
                  ]),
              actions: [
                MaterialButton(
                  minWidth: .9 * mediawidth(context),
                  color: primary,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BottomBarScreen(
                                id: sharedpref.getString("token")!)));
                  },
                  child: const Text("حسنا",
                      style: TextStyle(fontFamily: 'JF', color: Colors.white)),
                )
              ],
            );
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update reservation: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar('جدولة الحجز', context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomCalendar(
                selectedDay: _selectedDay!,
                focusedDay: _focusedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay, focusedDay);
                },
                getEventsForDay: _getEventsForDay,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 30,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _selectedTime2.format(context),
                          style:
                              const TextStyle(fontFamily: 'JF', fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime2,
                            );
                            if (pickedTime != null &&
                                pickedTime != _selectedTime2) {
                              setState(() {
                                _selectedTime2 = pickedTime;
                              });
                            }
                          },
                          child: const Icon(
                            Icons.timer,
                            size: 15,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "الي ",
                    style: TextStyle(
                        fontFamily: 'JF',
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _selectedTime.format(context),
                          style:
                              const TextStyle(fontFamily: 'JF', fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
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
                          child: const Icon(
                            Icons.timer,
                            size: 15,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "من ",
                    style: TextStyle(
                        fontFamily: 'JF',
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green[100],
                ),
                child: ListTile(
                  trailing: const Text("الحجز الجديد",
                      style: TextStyle(fontFamily: 'JF')),
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(_selectedTime.format(context)),
                  subtitle:
                      Text(DateFormat('yyyy/MM/dd').format(_selectedDay!)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[100],
                ),
                child: ListTile(
                  trailing: const Text("الحجز القديم",
                      style: TextStyle(fontFamily: 'JF')),
                  leading: const Icon(Icons.cancel, color: Colors.red),
                  title: Text(widget.date),
                  subtitle: Text('${widget.day}  '),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                minWidth: .7 * mediawidth(context),
                onPressed: _updateReservation,
                color: primary,
                child: const Text(
                  'التالي',
                  style: TextStyle(fontFamily: 'JF', color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

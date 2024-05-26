import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';

import 'package:sudia_events/presentation/screens/home/category_selector.dart';
import 'package:sudia_events/presentation/screens/home/slider_body.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart' as data;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  bool chooseday = false;
  bool addService = false;

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Text('موقعك'),
            SizedBox(width: 10),
            Icon(Icons.location_on_rounded),
            SizedBox(width: 10),
          ],
          leading: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: IconButton(
              icon: Icon(Icons.shopping_bag_rounded),
              onPressed: () {
                // Add your basket action here
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(flex: 3, child: SliderBodeyHomePage()),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    CategorySelector(),
                    Container(
                      width: .9 * mediawidth(context),
                      height: 45,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'البحث بالاسم . القبيلة.الموقع',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            suffixIcon: Icon(
                              Icons.tune,
                              color: Colors.grey[400],
                            )),
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 6,
              child: TableCalendar(
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
                        color: Colors.green, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Color(0xffff8923), shape: BoxShape.circle),
                    todayDecoration:
                        BoxDecoration(color: primary, shape: BoxShape.circle)),
                startingDayOfWeek: StartingDayOfWeek.saturday,
                calendarFormat: _calendarFormat,
                rowHeight: 40, // Adjust row height to decrease vertical spacing

                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ],
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/helper/calender.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/favorite/fav.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sudia_events/presentation/screens/home/booking.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart' as data;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  bool chooseday = false;
  bool addService = false;
  bool tappedFamily = false;
  bool tappedTribe = false;
  bool onTappedIcon = false;

  List<bool> onTapped = [false, false, false, false, false];

  List services = ['الكل', 'زواج', 'مناسبة عامة', 'ملكة', 'مناسبة'];
  List familyFilter = [];
  late final ValueNotifier<List<Event>> _selectedEvents;
  Api api = Api();
  String selectedService = 'زواج';

  bool isFavoriteChecked = false;
  bool isLocationChecked = false;

  TextEditingController searchController = TextEditingController();
  List<Event> filteredEvents = [];

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
        return event.name.toLowerCase().contains(query) ||
            event.family.toLowerCase().contains(query) ||
            event.tribe.toLowerCase().contains(query);
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

  void _showCalendarBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCalendar(
                selectedDay: _selectedDay!,
                focusedDay: _focusedDay,
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay, focusedDay);
                },
                getEventsForDay: _getEventsForDay,
              ),
              SizedBox(height: 16),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minWidth: 300,
                color: primary,
                child: Text(
                  'التالي',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BookingScreen(
                                bookingDate: _selectedDay!,
                              )));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEventBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the bottom sheet is scrollable
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(selectedService),
                  ),
                  SizedBox(height: 20),
                  _buildFilterOptions(setState),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        minWidth: 150,
                        color: primary,
                        child: Text(
                          'تطبيق',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _showCalendarBottomSheet();
                        },
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        minWidth: 150,
                        color: Colors.white,
                        child: Text('الغاء'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Text(
            'موقعك',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.location_on_rounded),
          SizedBox(width: 10),
        ],
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            int favoriteCount = 0;
            if (snapshot.hasData) {
              favoriteCount = snapshot.data!.docs.length;
            }
            return Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FavouriteScreen()));
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$favoriteCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: mediawidth(context),
                    height: 40,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: services.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              onTapped[index] = !onTapped[index];
                              selectedService = services[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color:
                                  onTapped[index] ? primary : Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: onTapped[index]
                                  ? MainAxisAlignment.spaceAround
                                  : MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    services[index],
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: onTapped[index]
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  size: 15,
                                  color: onTapped[index]
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: .9 * mediawidth(context),
                    height: 45,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'البحث',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Row(
              children: [
                Text(
                  "احجز موعد مناسبتك",
                  style: GoogleFonts.inter(
                      color: primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.add_circle_rounded),
                  onPressed: () {
                    _showEventBottomSheet();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: SizedBox(
              width: .9 * mediawidth(context),
              height: 150,
              child: FutureBuilder<List<Event>>(
                future: api.fetchReservationData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("لم تقم بحجز اي مناسبات بعد"),
                    );
                  } else {
                    List<Event> eventsToShow = searchController.text.isEmpty
                        ? snapshot.data!
                        : filteredEvents;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: eventsToShow.length,
                      itemBuilder: (context, index) {
                        Event event = eventsToShow[index];
                        return EventContainer(
                          time: intl.DateFormat('yyyy/MM/dd', 'ar')
                              .format(event.date),
                          name: '${event.name} ${event.family} ${event.tribe}',
                          title: selectedService,
                          location: 'جده - حي البساتين',
                          avatarUrl: 'assets/images/person.png',
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(StateSetter setState) {
    return Column(
      children: [
        _buildCheckboxOption('المفضلة', isFavoriteChecked, (value) {
          setState(() {
            isFavoriteChecked = value!;
          });
        }),
        _buildCheckboxOption('الموقع', isLocationChecked, (value) {
          setState(() {
            isLocationChecked = value!;
          });
        }),
      ],
    );
  }

  Widget _buildCheckboxOption(
      String label, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          activeColor: primary,
          value: isChecked,
          onChanged: onChanged,
        ),
        Text(label),
        Spacer(),
        label == 'المفضلة'
            ? Icon(
                Icons.favorite,
                size: 20,
                color: primary,
              )
            : label == 'الموقع'
                ? Icon(
                    Icons.location_on,
                    size: 20,
                    color: primary,
                  )
                : Text('')
      ],
    );
  }
}

class EventContainer extends StatelessWidget {
  final String time;
  final String title;
  final String name;
  final String location;
  final String avatarUrl;

  EventContainer({
    required this.time,
    required this.title,
    required this.name,
    required this.location,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            time,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: ExactAssetImage(avatarUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          location,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '10:24 AM',
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 190,
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

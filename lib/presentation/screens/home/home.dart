import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/calender.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/data/services/filter.dart';
import 'package:sudia_events/presentation/screens/Reservation/widgets/search_container.dart';
import 'package:sudia_events/presentation/screens/favorite/fav.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sudia_events/presentation/screens/home/booking.dart';
import 'package:sudia_events/presentation/widgets/search.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart' as data;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
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
    _selectedEvents.dispose();
    super.dispose();
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

  TextEditingController searchController = TextEditingController();
  List<String>? parts;
  String? first;
  String? secondPart;
  String? searchText;
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
                  // Close the bottom sheet after selecting a date
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
                  Navigator.push(
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
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(selectedService),
              ),
              SizedBox(height: 20),
              _buildFilterOptions(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [
          Text('موقعك'),
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
                    Icons.shopify_sharp,
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
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                              color: onTapped[index] ? primary : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Text(
                                    services[index],
                                    style: TextStyle(
                                        fontSize: 14,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            setState(() {
                              onTappedIcon = !onTappedIcon;
                              parts = searchController.text.split(" ");
                              first = parts!.isNotEmpty ? parts![0] : "";
                              secondPart = parts!.length > 1
                                  ? parts!.sublist(1).join("")
                                  : "";
                              first = first!.replaceAll(" ", "");
                            });

                            print("First part: $first");
                            print("Second part: $secondPart");
                          },
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
                  style: TextStyle(color: primary),
                ),
                SizedBox(width: 10),
                IconButton(
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
                future: onTappedIcon
                    ? filterEventsByFamilyAndTribe(first!, secondPart!)
                    : api.fetchReservationData(),
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
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Event event = snapshot.data![index];
                        return EventContainer(
                          time: intl.DateFormat('yyyy/MM/dd', 'ar')
                              .format(snapshot.data![index].date),
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

  Widget _buildFilterOptions() {
    return Column(
      children: [
        _buildCheckboxOption('العائلة', true),
        _buildCheckboxOption('القبيلة', false),
        _buildCheckboxOption('المفضلة', true),
        _buildCheckboxOption('الموقع', true),
      ],
    );
  }

  Widget _buildCheckboxOption(String label, bool isChecked) {
    return Row(
      children: [
        Checkbox(
          activeColor: primary,
          value: isChecked,
          onChanged: (bool? value) {
            // Handle checkbox state change
          },
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

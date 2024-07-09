import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/business_logic/cubit/booked_data/booked_data_cubit.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/booked_services.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';

import 'package:sudia_events/presentation/screens/Auth/login.dart';

import 'package:intl/intl.dart' as intl;
import 'package:sudia_events/presentation/screens/home/booking.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';
import 'package:sudia_events/presentation/screens/home/location.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart' as data;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.id, required this.public});
  final String id;
  final bool public;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BookedServicesModel>? bookedServicesModel;
  String filterValue = '';
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  bool chooseday = false;
  bool addService = false;
  bool tappedFamily = false;
  bool tappedTribe = false;
  bool onTappedIcon = false;
  String type = '';
  List<bool> onTapped = [false, false, false, false, false];

  List services = ['الكل', 'زواج', 'حفل تخرج', 'عيد ميلاد', 'خطوبة'];
  List familyFilter = [];
  late final ValueNotifier<List<Event>> _selectedEvents;
  Api api = Api();
  String selectedService = 'زواج';
  List<Color?> colors = [Colors.green[200], Colors.yellow[300]];
  bool marriage = false;
  bool graduation = false;
  bool privateEvent = false;
  bool publicEvent = false;

  TextEditingController searchController = TextEditingController();
  List<Event> filteredEvents = [];
  bool isFav = false;
  Future<List<Event>> _fetchEvents() async {
    List<Event> events;

    if (selectedService == 'الكل' && !isFav) {
      events = await api.fetchReservationData();
    } else if (isFav) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('favoriteEvent')
              .get();

      events = querySnapshot.docs
          .map((doc) => Event(
                name: doc.data()['name'],
                date: DateTime.parse(doc.data()['date']),
                phone: doc.data()['phone'] ?? "",
                family: doc.data()['family'],
                tribe: doc.data()['tribe'],
                type: doc.data()['type'],
                time: doc.data()['time'],
                uniquID: doc.data()[
                    'uniquID'], // Assuming uniquID is present in the doc
              ))
          .toList();
    } else {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('reservation')
              .where('type', isEqualTo: selectedService)
              .get();

      events = querySnapshot.docs
          .map((doc) => Event(
                name: doc.data()['name'],
                date: DateTime.parse(doc.data()['date']),
                phone: doc.data()['phone'] ?? "",
                family: doc.data()['family'],
                tribe: doc.data()['tribe'],
                type: doc.data()['type'],
                time: doc.data()['time'],
                uniquID: doc.data()[
                    'uniquID'], // Assuming uniquID is present in the doc
              ))
          .toList();
    }

    return events;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookedDataCubit>(context).getBookedDataCubitfun();
    selectedService = 'الكل';
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

  void _onServiceSelected(int index) {
    setState(() {
      for (int i = 0; i < onTapped.length; i++) {
        onTapped[i] = i == index;
      }
      selectedService = services[index];
      isFav = false; // Reset favorites when a specific service is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy/MM/dd', 'ar').format(DateTime.now()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              DateFormat('EEEE', 'ar').format(DateTime.now()),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LocationScreen(
                            lat: sharedpref.getDouble('lat')!,
                            long: sharedpref.getDouble('long')!,
                            fromHome: true,
                          )));
            },
            child: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(color: Colors.yellow[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'location'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.location_on_rounded),
                  SizedBox(width: 10),
                ],
              ),
            ),
          )
        ],
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SubServices')
              .doc(widget.id)
              .collection('checkout')
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
                    Icons.shopping_cart_outlined,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutScreenOverView(
                                  id: widget.id,
                                )));
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
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: .9 * mediawidth(context),
                    height: 45,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFav = !isFav;
                              });
                            },
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            )),
                        hintText: 'search'.tr(),
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
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(services.length, (index) {
              return ChoiceChip(
                checkmarkColor: Colors.white,
                selectedColor: primary,
                label: Text(
                  services[index],
                  style: TextStyle(
                      color: onTapped[index] ? Colors.white : Colors.black),
                ),
                selected: onTapped[index],
                onSelected: (_) => _onServiceSelected(index),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Row(
              children: [
                Text(
                  "bookreservation".tr(),
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
                    widget.id == '123'
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(" يجب تسجيل الدخول"),
                                content: Text(
                                    "لكي تقوم بانشاء مناسبه يجب تسجيل الدخول اولا "),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => LoginScreen()));
                                    },
                                    child: Text("حسنا"),
                                  )
                                ],
                              );
                            },
                          )
                        : Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => BookingScreen()));
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
                future: _fetchEvents(),
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("لم تقم بحجز اي مناسبات بعد"),
                    );
                  } else {
                    List<Event> eventsToShow = searchController.text.isEmpty
                        ? snapshot.data!
                        : filteredEvents;

                    return BlocBuilder<BookedDataCubit, BookedDataState>(
                      builder: (context, state) {
                        bookedServicesModel =
                            BlocProvider.of<BookedDataCubit>(context)
                                .bookedServices;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: eventsToShow.length,
                          itemBuilder: (context, index) {
                            Event event = eventsToShow[index];
                            DateTime now = DateTime.now();
                            DateTime eventDate = event.date;

                            // Check if the event date is tomorrow, today, or after a week
                            bool isToday = eventDate.year == now.year &&
                                eventDate.month == now.month &&
                                eventDate.day == now.day;

                            bool isTomorrow = eventDate.year == now.year &&
                                eventDate.month == now.month &&
                                eventDate.day == now.day + 1;

                            bool isAfterWeek =
                                eventDate.isAfter(now.add(Duration(days: 5)));

                            // Determine the message to display
                            String message;
                            if (isToday) {
                              message = 'اليوم';
                            } else if (isTomorrow) {
                              message = 'غدا';
                            } else if (isAfterWeek) {
                              message = 'الاسبوع القادم';
                            } else {
                              int daysDifference =
                                  eventDate.difference(now).inDays;
                              if (daysDifference > 0) {
                                message = 'بعد $daysDifference يوم';
                              } else {
                                message = 'قبل ${-daysDifference} يوم';
                              }
                            }

                            String date = intl.DateFormat('yyyy/MM/dd', 'ar')
                                .format(event.date);
                            String dayName = intl.DateFormat('EEEE', 'ar')
                                .format(event.date);

                            // Check if the event is booked
                            bool isBooked = bookedServicesModel?.any(
                                    (bookedEvent) =>
                                        bookedEvent.uniqueID ==
                                        event.uniquID) ??
                                false;

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      icon: Align(
                                        alignment: Alignment.topLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.close),
                                        ),
                                      ),
                                      surfaceTintColor: Colors.white,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.green,
                                            child: Text(
                                              "M",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "تفاصيل",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text("$dayName  $date"),
                                          SizedBox(height: 10),
                                          Container(
                                            width: .5 * mediawidth(context),
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide()),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("حالة الحجز"),
                                                Text("مكرر "),
                                                Text(event.type),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text("المحتفي به "),
                                          SizedBox(height: 10),
                                          Container(
                                            width: .5 * mediawidth(context),
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(isBooked
                                                  ? "${event.name} ${event.family} ${event.tribe}"
                                                  : "لا يوجد معلومات"),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                "بطاقة الدعوة ",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: Image.asset(
                                              "assets/images/locationb.png",
                                              color: Colors.green,
                                              width: 50,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: EventContainer(
                                time: message,
                                name: isBooked
                                    ? "${event.name} ${event.family} ${event.tribe}"
                                    : "لا يوجد معلومات",
                                title:
                                    isBooked ? '${event.type} ' : "مناسبة خاصة",
                                location: isBooked
                                    ? 'جده - حي البساتين'
                                    : "لا توجد معلومات",
                                avatarUrl: 'assets/images/logo.png',
                                clock: event.time,
                                dateTime: event.date,
                                uniquID: event.uniquID,
                                color: isBooked ? colors[0] : colors[1],
                                date: date,
                              ),
                            );
                          },
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
}

class EventContainer extends StatefulWidget {
  final String time;
  final String title;
  final String name;
  final String location;
  final String avatarUrl;
  final String clock;
  final String uniquID;
  final DateTime dateTime;
  final String date;
  final Color? color;

  EventContainer({
    required this.time,
    required this.title,
    required this.name,
    required this.location,
    required this.avatarUrl,
    required this.clock,
    required this.dateTime,
    required this.uniquID,
    required this.color,
    required this.date,
  });

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  bool isAddedToFav = false;

  Future<void> addToFavorites(BuildContext context) async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User is not logged in
        // You can handle this case according to your app's logic
        return;
      }
      List<String> nameParts = widget.name.split(' ');
      String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      String familyName = nameParts.length > 1 ? nameParts[1] : '';
      String tribeName = nameParts.length > 2 ? nameParts[2] : '';
      // Add item to favorites collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoriteEvent')
          .add({
        'userID': sharedpref.getString('token'),
        'name': firstName,
        'family': familyName,
        'tribe': tribeName,
        'date': widget.dateTime.toIso8601String(),
        'type': widget.title,
        'time': widget.clock,
        'uniquID': widget.uniquID
        // You can add more fields if needed
      });
      setState(() {
        isAddedToFav = !isAddedToFav;
      });
      // Show a snackbar or toast to indicate success
      CustomSnackBar(
        context,
        'add to fav'.tr(),
        Colors.green,
        .75 * mediaheight(context),
      );
    } catch (e) {
      // Handle errors
      print('Error adding to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.time,
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
            border: Border.all(color: Colors.grey),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: widget.color,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.location,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.clock,
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                      ),
                      Text(
                        widget.date,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
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
                  GestureDetector(
                    onTap: () {
                      addToFavorites(context);
                    },
                    child: Icon(
                      isAddedToFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
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

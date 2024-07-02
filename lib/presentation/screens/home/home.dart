import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<bool> onTapped = [false, false, false, false];

  List services = ['الكل', 'زواج', 'حفل تخرج', 'عيد ميلاد'];
  List familyFilter = [];
  late final ValueNotifier<List<Event>> _selectedEvents;
  Api api = Api();
  String selectedService = 'زواج';

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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BookingScreen(
                                        type: filterValue,
                                      )));
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
            child: Text(
              'location'.tr(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.location_on_rounded),
          SizedBox(width: 10),
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
                    Icons.shopify_rounded,
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
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
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
                        : _showEventBottomSheet();
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
                                title: '${event.type} ',
                                location:
                                    publicEvent ? 'جده - حي البساتين' : "",
                                avatarUrl: 'assets/images/person.png',
                                clock: event.time,
                                dateTime: event.date,
                                uniquID: event.uniquID,
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

  Widget _buildFilterOptions(StateSetter setState) {
    return Column(
      children: [
        _buildCheckboxOption('زواج', marriage, (value) {
          setState(() {
            marriage = value!;
            filterValue = 'زواج';
          });
        }),
        _buildCheckboxOption('حفل تخرج', graduation, (value) {
          setState(() {
            graduation = value!;
            filterValue = 'حفل تخرج';
          });
        }),
        _buildCheckboxOption('عيد ميلاد', publicEvent, (value) {
          setState(() {
            publicEvent = value!;
            filterValue = 'عيد ميلاد';
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
        label == 'زواج'
            ? Icon(
                Icons.castle_rounded,
                size: 20,
                color: primary,
              )
            : label == 'عيد ميلاد'
                ? Icon(
                    Icons.event,
                    size: 20,
                    color: primary,
                  )
                : label == 'مناسبة عامة'
                    ? Icon(
                        Icons.event_available,
                        size: 20,
                        color: primary,
                      )
                    : label == 'حفل تخرج'
                        ? Icon(
                            Icons.date_range_rounded,
                            size: 20,
                            color: primary,
                          )
                        : Text("")
      ],
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

  EventContainer({
    required this.time,
    required this.title,
    required this.name,
    required this.location,
    required this.avatarUrl,
    required this.clock,
    required this.dateTime,
    required this.uniquID,
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
                    backgroundImage: ExactAssetImage(widget.avatarUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.red,
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.clock,
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
                    icon: Icon(
                        isAddedToFav ? Icons.favorite : Icons.favorite_border),
                    color: Colors.red,
                    onPressed: () {
                      addToFavorites(context);
                    },
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

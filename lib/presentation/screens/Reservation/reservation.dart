
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/widgets/search.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'
    as data; // Import for date formatting initialization

// ignore: must_be_immutable
class ReservationScreen extends StatefulWidget {
  ReservationScreen({super.key, this.id});
  String? id;
  String? gender;
  String? type;
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
 
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  bool chooseday = false;
  bool addService = false;
  TextEditingController contoller = TextEditingController();
  List familyFilter = [];
  late final ValueNotifier<List<Event>> _selectedEvents;
  Api api = Api();
  List<bool> onTapped = [
    false,
    false,
    false,
    false,
  ];
  String selectedService = 'زواج';
  List services = [
    'الكل',
    'نشط',
    'مكتمل ',
    'ملغي',
  ];
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
      appBar: AppBar(
        title: Text('الحجوزات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: primary,
            ),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: primary,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  SearchContainernew(
                      hintText: 'البحث', controller: contoller, onTap: () {}),
                  Container(
                    width: mediawidth(context),
                    height: 45,
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
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  onTapped[index] ? primary : Colors.grey[200],
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
                ],
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 5,
            child: Container(
                child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '09:56 10/05/2024',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.shopping_bag,
                                  color: Colors.white,
                                )),
                            SizedBox(width: 16.0),
                            Text(
                              'حجز رقم SP 0023900',
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                            SizedBox(width: 16.0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'عدد الخدمات',
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                            Text(
                              '2',
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _OrderItem(
                          title: 'ورود الطايف SP 0023900',
                          price: 'SAR150.00',
                          details: '1 ورد مجفف\n2 ورد صناعي',
                        ),
                        Divider(
                          endIndent: 10,
                          indent: 10,
                        ),
                        _OrderItem(
                          title: 'عصيرات المنجا SP 0023900',
                          price: 'SAR150.00',
                          details: '1 عصير طبيعي\n2 عصير ليمون',
                        ),
                        SizedBox(height: 16.0),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'الاجمالي',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              'SAR300.00',
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'التوصيل إلى',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.red),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الاستلام من -- مطعم الديرة',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'حي السلامة - جدة - المملكة العربية السعودية',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String title;
  final String price;
  final String details;

  _OrderItem({required this.title, required this.price, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Text(
                    price,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  Text(
                    details,
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                  ),
                  Spacer(),
                  Text(
                    price,
                    style: TextStyle(fontSize: 10.0),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Reservation/delete_order.dart';
import 'package:sudia_events/presentation/screens/Reservation/sechdual.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';
import 'package:sudia_events/presentation/widgets/search.dart'; // Firestore package

class ReservationScreen extends StatefulWidget {
  ReservationScreen({Key? key, this.id}) : super(key: key);
  final String? id;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final TextEditingController controller = TextEditingController();
  final List<String> services = [
    'All'.tr(),
    'active'.tr(),
    'complete'.tr(),
    'cancel'.tr()
  ];
  final List<bool> onTapped = [false, false, false, false];
  String selectedService = 'الكل';
  List<dynamic> reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot =
        await firestore.collection('booked_services').get();

    setState(() {
      reservations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('booked'.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Colors.white,
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
                      hintText: 'search'.tr(),
                      controller: controller,
                      onTap: () {}),
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
          SizedBox(height: 10),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                final timestamp = reservation['timestamp'] as Timestamp;
                final date =
                    DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
                final prevoiusDate =
                    DateFormat('dd/MM/yyyy').format(timestamp.toDate());
                final prevoiusTime =
                    DateFormat('jm').format(timestamp.toDate());
                return Card(
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: mediawidth(context),
                            color: secondary,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Icon(Icons.shopping_bag,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 16.0),
                                      Text(
                                        'حجز رقم 888',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'عدد الخدمات',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      reservation['options'].length.toString(),
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.red),
                                    ),
                                    reservation['status'] == "pending"
                                        ? MaterialButton(
                                            elevation: 0,
                                            minWidth: 40,
                                            height: 30,
                                            color: Colors.red,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          CancelOrderScreen(
                                                              item_name:
                                                                  reservation[
                                                                      'item_name'])));
                                            },
                                            child: Text(
                                              "حذف",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                        : reservation['status'] == 'complete'
                                            ? MaterialButton(
                                                minWidth: 40,
                                                height: 30,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                color: Colors.green[100],
                                                onPressed: () {},
                                                child: Text(
                                                  "مكتمل",
                                                  style: TextStyle(
                                                      color: Colors.green[700]),
                                                ),
                                              )
                                            : reservation['status'] == 'Active'
                                                ? MaterialButton(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    color: Colors.yellow[100],
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  SechdualScreen(
                                                                    date:
                                                                        prevoiusTime,
                                                                    day:
                                                                        prevoiusDate,
                                                                    itemName:
                                                                        reservation[
                                                                            'item_name'],
                                                                  )));
                                                    },
                                                    child: Text(
                                                        "اعادة جدولة الحجز"),
                                                  )
                                                : MaterialButton(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    color: Colors.grey[300],
                                                    onPressed: () {},
                                                    child: Text("ملغي"),
                                                  )
                                  ],
                                ),
                              ],
                            )),
                        SizedBox(height: 10),
                        OrderItem(
                          title: reservation['name'],
                          price: 'SAR${reservation['price']}',
                          options: reservation['options'] as List<dynamic>,
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              'الاجمالي',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              'SAR${reservation['total'].toString()}',
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
                                    reservation['delivery_fee'].toString(),
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
                                child: Icon(Icons.arrow_forward_ios, size: 20),
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
            ),
          ),
        ],
      ),
    );
  }
}

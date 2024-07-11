import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Reservation/complete.dart';
import 'package:sudia_events/presentation/screens/Reservation/delete_order.dart';
import 'package:sudia_events/presentation/screens/Reservation/sechdual.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';
import 'package:sudia_events/presentation/widgets/search.dart'; // Firestore package

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, this.id});
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
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: reservations.isEmpty
          ? const Center(
              child: Text(
                '☺ لايوجد طلبات لديك',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        SearchContainernew(
                            hintText: 'search'.tr(),
                            controller: controller,
                            onTap: () {}),
                        SizedBox(
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
                                    color: onTapped[index]
                                        ? primary
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                const SizedBox(height: 10),
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = reservations[index];
                      final timestamp = reservation['timestamp'] as Timestamp;
                      final date = DateFormat('dd/MM/yyyy HH:mm')
                          .format(timestamp.toDate());
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
                          padding: const EdgeInsets.all(10.0),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              date,
                                              style: const TextStyle(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor: Colors.green,
                                              child: Icon(Icons.shopping_bag,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(width: 16.0),
                                            Text(
                                              'حجز رقم ${reservation['uniquID'].split('-').last}',
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            const SizedBox(width: 16.0),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'عدد الخدمات',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            reservation['options']
                                                .length
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.red),
                                          ),
                                          reservation['status'] == "pending"
                                              ? Row(
                                                  children: [
                                                    MaterialButton(
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
                                                      child: const Text(
                                                          "اعادة جدولة الحجز"),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    MaterialButton(
                                                        elevation: 0,
                                                        minWidth: 40,
                                                        height: 30,
                                                        color: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      CancelOrderScreen(
                                                                          uniquID:
                                                                              reservation['uniquID'])));
                                                        },
                                                        child: const Text(
                                                          "حذف",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ],
                                                )
                                              : reservation['status'] ==
                                                      'complete'
                                                  ? MaterialButton(
                                                      minWidth: 40,
                                                      height: 30,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      color: Colors.green[100],
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    BookingSummaryScreen(
                                                                      img: reservation[
                                                                          'img'],
                                                                      name: reservation[
                                                                          'item_name'],
                                                                      price: reservation[
                                                                          'price'],
                                                                      discount:
                                                                          reservation[
                                                                              'discount'],
                                                                      options:
                                                                          reservation[
                                                                              'options'],
                                                                      subtotal:
                                                                          '${reservation['subtotal']}',
                                                                      total:
                                                                          '${reservation['total']}',
                                                                      discountf:
                                                                          '${reservation['discount_amount'].toStringAsFixed(2)}',
                                                                      number:
                                                                          '${reservation['uniquID'].split('-').last}',
                                                                      type:
                                                                          'مكتمل',
                                                                    )));
                                                      },
                                                      child: Text(
                                                        "مكتمل",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .green[700]),
                                                      ),
                                                    )
                                                  : reservation['status'] ==
                                                          'Active'
                                                      ? MaterialButton(
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          color: Colors
                                                              .yellow[100],
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
                                                                              reservation['item_name'],
                                                                        )));
                                                          },
                                                          child: const Text(
                                                              "اعادة جدولة الحجز"),
                                                        )
                                                      : MaterialButton(
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          color:
                                                              Colors.grey[300],
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        BookingSummaryScreen(
                                                                          img: reservation[
                                                                              'img'],
                                                                          name:
                                                                              reservation['item_name'],
                                                                          price:
                                                                              reservation['price'],
                                                                          discount:
                                                                              reservation['discount'],
                                                                          options:
                                                                              reservation['options'],
                                                                          subtotal:
                                                                              '${reservation['subtotal']}',
                                                                          total:
                                                                              '${reservation['total']}',
                                                                          discountf:
                                                                              '${reservation['discount_amount'].toStringAsFixed(2)}',
                                                                          number:
                                                                              '${reservation['uniquID'].split('-').last}',
                                                                          type:
                                                                              'ملغي',
                                                                        )));
                                                          },
                                                          child: const Text(
                                                              "ملغي"),
                                                        )
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 10),
                              OrderItem(
                                title: '${index + 1}   ${reservation['name']}',
                                price: 'SAR${reservation['price']}',
                                options:
                                    reservation['options'] as List<dynamic>,
                                number: reservation['uniquID'].split('-').last,
                              ),
                              const SizedBox(height: 16.0),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'التوصيل إلى ->  المنزل',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'حي السلامة - جدة - المملكة العربية السعودية',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              OrderItem(
                                title: '${index + 2}   ${reservation['name']}',
                                price: 'SAR${reservation['price']}',
                                options:
                                    reservation['options'] as List<dynamic>,
                                number: reservation['uniquID'].split('-').last,
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'الاستلام من ->  مطعم الباشا',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                '512 -حي السلامة - جدة - المملكة العربية السعودية',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  const Text(
                                    'الاجمالي',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 170,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        '  في انتظار الدفع SAR${reservation['total'].toString()} ',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/stepper.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Review/order_rating.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';
import 'package:sudia_events/presentation/screens/home/location.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String id;
  NotificationScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('yyyy/MM/dd', 'ar').format(DateTime.now()),
                style: const TextStyle(fontFamily: 'JF')),
            const SizedBox(
              width: 10,
            ),
            Text(DateFormat('EEEE', 'ar').format(DateTime.now()),
                style: const TextStyle(fontFamily: 'JF')),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_rounded),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          )
        ],
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SubServices')
              .doc(id)
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
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            name: sharedpref.getString('name')!,
                            number: sharedpref.getString('number')!,
                            date: DateTime.parse(sharedpref.getString(
                                'date')!), // Convert String to DateTime
                            uniquID: sharedpref.getString('uniquID')!,
                            img: sharedpref.getString('img')!,
                          ),
                        ));
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$favoriteCount',
                      style: const TextStyle(
                        fontFamily: 'JF',
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
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          SearchContainernew(
            hintText: 'كود',
            controller: controller,
            onTap: () {},
          ),
          NotificationTile(
              date: 'اليوم',
              time: '09:56 10/05/2024',
              orderNumber: '0023900',
              status: 'في التنفيذ',
              statusColor: Colors.red.shade100,
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.3,
                      expand: false,
                      builder: (context, scrollController) {
                        return const OrderDetailBottomSheet(
                          status: 'في التنفيذ',
                        );
                      },
                    ),
                  )),
          NotificationTile(
              date: 'اليوم',
              time: '09:56 10/05/2024',
              orderNumber: '0023900',
              status: 'في الانتظار',
              statusColor: Colors.yellow.shade100,
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.3,
                      expand: false,
                      builder: (context, scrollController) {
                        return const OrderDetailBottomSheet(
                          status: 'في الانتظار',
                        );
                      },
                    ),
                  )),
          NotificationTile(
              date: 'اليوم',
              time: '09:56 10/05/2024',
              orderNumber: '0023900',
              status: 'في التسليم',
              statusColor: Colors.green.shade100,
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.3,
                      expand: false,
                      builder: (context, scrollController) {
                        return const OrderDetailBottomSheet(
                          status: 'في التسليم',
                        );
                      },
                    ),
                  )),
          DiscountNotificationTile(
              date: 'اليوم',
              message: 'احصل على كود خصم %20',
              detail: 'احصل على رموز الخصم من المشاركة مع الأصدقاء.',
              time: '10/05/2024 12:20  ',
              icon: Icons.local_activity,
              iconColor: Colors.yellow,
              backgroundColor: const Color(0xfffff9e6),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.3,
                      expand: false,
                      builder: (context, scrollController) {
                        return const OrderDetailBottomSheet(
                          status: '',
                        );
                      },
                    ),
                  )),
          DiscountNotificationTile(
              date: 'امس',
              message: 'تم الالغاء',
              detail: 'تم الغاء الطلب رقم SP_18559 ',
              time: '10/05/2024 12:20  ',
              icon: Icons.close,
              iconColor: Colors.red,
              backgroundColor: const Color(0xffffefed),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.3,
                      expand: false,
                      builder: (context, scrollController) {
                        return const OrderDetailBottomSheet(
                          status: 'تم الالغاء',
                        );
                      },
                    ),
                  )),
          DiscountNotificationTile(
              date: 'امس',
              message: 'تم اعداد الحساب',
              detail: 'تهانينا تم اعداد حسابك بنجاح',
              time: '10/05/2024 12:20  ',
              icon: Icons.person,
              iconColor: Colors.green,
              backgroundColor: const Color(0xffe7f9f5),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.3,
                      expand: false,
                      builder: (context, scrollController) {
                        return const OrderDetailBottomSheet(
                          status: '',
                        );
                      },
                    ),
                  )),
        ],
      ),
    );
  }
}

class OrderDetailBottomSheet extends StatefulWidget {
  final String status;
  const OrderDetailBottomSheet({super.key, required this.status});

  @override
  _OrderDetailBottomSheetState createState() => _OrderDetailBottomSheetState();
}

class _OrderDetailBottomSheetState extends State<OrderDetailBottomSheet> {
  int active = 0; // Initial value for the stepper

  @override
  void initState() {
    super.initState();
    setActiveStep();
  }

  void setActiveStep() {
    switch (widget.status) {
      case 'في التسليم':
        active = 1; // Assuming step index for 'في التسليم' is 1
        break;
      case 'في التنفيذ':
        active = 2; // Assuming step index for 'في التنفيذ' is 0
        break;
      case 'في الانتظار':
        active = 3; // Assuming step index for 'في الانتظار' is 2
        break;
      default:
        active = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData currentIcon;
    String currentText;

    switch (active) {
      case 0:
        currentIcon = Icons.check_circle;
        currentText = 'الانتهاء';
      case 1:
        currentIcon = Icons.shopify_outlined;
        currentText = 'تسليم الطلب';
      case 2:
        currentIcon = Icons.local_shipping_outlined;
        currentText = 'توصيل الطلب';
        break;
      case 3:
        currentIcon = Icons.list_alt_sharp;
        currentText = 'مراجعة الطلب';
        break;
      default:
        currentIcon = Icons.check_circle;
        currentText = 'تسليم الطلب';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'حالة الطلب',
                  style: TextStyle(
                      fontFamily: 'JF',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.settings),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: .9 * MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.restaurant, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مطعم الجزيرة',
                        style: TextStyle(
                            fontFamily: 'JF',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.red, size: 18),
                          Text('4.9',
                              style: TextStyle(fontFamily: 'JF', fontSize: 16)),
                          Text(' ID DWZ125',
                              style: TextStyle(fontFamily: 'JF', fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.message,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            StepperScreen(
              active: active,
              lineColor: primary,
              stepperColor: primary,
              textColor: Colors.black,
              onStepTapped: (index) {
                setState(() {
                  active = index;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(currentIcon, color: Colors.green),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentText,
                        style: const TextStyle(
                            fontFamily: 'JF',
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const Text('10:10 10/05/2024',
                        style: TextStyle(fontFamily: 'JF', fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            active == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رمز الإنهاء',
                        style: TextStyle(
                            fontFamily: 'JF',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPinBox('1'),
                          _buildPinBox('2'),
                          _buildPinBox('5'),
                          _buildPinBox('6'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: MaterialButton(
                          color: Colors.green[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderRatingScreen(
                                    orders:
                                        sharedpref.getStringList('_checkout') ??
                                            [],
                                    images:
                                        sharedpref.getStringList('images') ??
                                            [],
                                    texts:
                                        sharedpref.getStringList('texts') ?? [],
                                  ),
                                ));
                          },
                          child: const Text('قيمنا'),
                        ),
                      )
                    ],
                  )
                : const Center(),
          ],
        ),
      ),
    );
  }

  Widget _buildPinBox(String digit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        digit,
        style: const TextStyle(
            fontFamily: 'JF', fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String date;
  final String time;
  final String orderNumber;
  final String status;
  final Color statusColor;
  final bool isCancelled;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.date,
    required this.time,
    required this.orderNumber,
    required this.status,
    required this.statusColor,
    this.isCancelled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        EasyLocalization.of(context)!.currentLocale!.languageCode == 'en';
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontFamily: 'JF', color: Colors.red),
                  ),
                ],
              ),
            ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: .01 * mediawidth(context)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xffe7f9f5),
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 15,
                      color: Colors.green[500],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: .07 * mediawidth(context)),
                  child: const Text(
                    'الحجز',
                    style: TextStyle(
                        fontFamily: 'JF', fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  '# $orderNumber  ',
                  style: const TextStyle(
                    fontFamily: 'JF',
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.only(
                  right: isEnglish ? 0 : .08 * mediawidth(context)),
              color: statusColor,
              child: SizedBox(
                width: .77 * mediawidth(context),
                height: .08 * mediaheight(context),
                child: ListTile(
                  title: Text(
                    'مطعم الديرة # $orderNumber  ',
                    style: const TextStyle(fontFamily: 'JF', fontSize: 15),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        status,
                        style: const TextStyle(fontFamily: 'JF', fontSize: 11),
                      ),
                      Text(
                        time,
                        style: const TextStyle(fontFamily: 'JF', fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscountNotificationTile extends StatelessWidget {
  final String date;
  final String message;
  final String detail;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const DiscountNotificationTile({
    super.key,
    required this.date,
    required this.message,
    required this.detail,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontFamily: 'JF', color: Colors.red),
                  ),
                ],
              ),
            ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: backgroundColor,
              radius: 20,
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            title: Text(
              message,
              style: const TextStyle(
                  fontFamily: 'JF', fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail,
                  style: const TextStyle(fontFamily: 'JF', fontSize: 13),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(fontFamily: 'JF', fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

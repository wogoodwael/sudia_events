import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/stepper.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class NotificationScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notification'.tr()),
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
      body: ListView(
        padding: EdgeInsets.all(8.0),
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
                      expand: false,
                      builder: (context, scrollController) {
                        return OrderDetailBottomSheet();
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
                      expand: false,
                      builder: (context, scrollController) {
                        return OrderDetailBottomSheet();
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
                      expand: false,
                      builder: (context, scrollController) {
                        return OrderDetailBottomSheet();
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
              backgroundColor: Color(0xfffff9e6),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      builder: (context, scrollController) {
                        return OrderDetailBottomSheet();
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
              backgroundColor: Color(0xffffefed),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      builder: (context, scrollController) {
                        return OrderDetailBottomSheet();
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
              backgroundColor: Color(0xffe7f9f5),
              onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      builder: (context, scrollController) {
                        return OrderDetailBottomSheet();
                      },
                    ),
                  )),
        ],
      ),
    );
  }
}

class OrderDetailBottomSheet extends StatefulWidget {
  @override
  _OrderDetailBottomSheetState createState() => _OrderDetailBottomSheetState();
}

class _OrderDetailBottomSheetState extends State<OrderDetailBottomSheet> {
  int active = 0; // Initial value for the stepper

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'حالة الطلب',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.settings),
              ],
            ),
            SizedBox(height: 20),
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
                    child: Icon(Icons.restaurant, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مطعم الجزيرة',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.red, size: 18),
                          Text('4.9', style: TextStyle(fontSize: 16)),
                          Text(' ID DWZ125', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
            SizedBox(height: 20),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Row(
              children: [
                Icon(currentIcon, color: Colors.green),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentText,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('10:10 10/05/2024', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            active == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رمز الإنهاء',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPinBox('1'),
                          _buildPinBox('2'),
                          _buildPinBox('5'),
                          _buildPinBox('6'),
                        ],
                      ),
                    ],
                  )
                : Center(),
          ],
        ),
      ),
    );
  }

  Widget _buildPinBox(String digit) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        digit,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  NotificationTile({
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
                    style: TextStyle(color: Colors.red),
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
                  backgroundColor: Color(0xffe7f9f5),
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
                  child: Text(
                    'الحجز',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Text(
                  '# $orderNumber  ',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.only(
                  right: isEnglish ? 0 : .08 * mediawidth(context)),
              color: statusColor,
              child: Container(
                width: .77 * mediawidth(context),
                height: .08 * mediaheight(context),
                child: ListTile(
                  title: Text(
                    'مطعم الديرة # $orderNumber  ',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        status,
                        style: TextStyle(fontSize: 11),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 11),
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

  DiscountNotificationTile({
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
                    style: TextStyle(color: Colors.red),
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail,
                  style: TextStyle(fontSize: 13),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 10),
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

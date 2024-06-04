import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التنبيهات'),
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
          ),
          NotificationTile(
            date: 'اليوم',
            time: '09:56 10/05/2024',
            orderNumber: '0023900',
            status: 'في الانتظار',
            statusColor: Colors.yellow.shade100,
          ),
          NotificationTile(
            date: 'اليوم',
            time: '09:56 10/05/2024',
            orderNumber: '0023900',
            status: 'في التسليم',
            statusColor: Colors.green.shade100,
          ),
          DiscountNotificationTile(
            date: 'اليوم',
            message: 'احصل على كود خصم %20',
            detail: 'احصل على رموز الخصم من المشاركة مع الأصدقاء.',
            time: '10/05/2024 12:20  ',
            icon: Icons.local_activity,
            iconColor: Colors.yellow,
            backgroundColor: Color(0xfffff9e6),
          ),
          DiscountNotificationTile(
            date: 'امس',
            message: 'تم الالغاء',
            detail: 'تم الغاء الطلب رقم SP_18559 ',
            time: '10/05/2024 12:20  ',
            icon: Icons.close,
            iconColor: Colors.red,
            backgroundColor: Color(0xffffefed),
          ),
          DiscountNotificationTile(
            date: 'امس',
            message: 'تم اعداد الحساب',
            detail: 'تهانينا تم اعداد حسابك بنجاح',
            time: '10/05/2024 12:20  ',
            icon: Icons.person,
            iconColor: Colors.green,
            backgroundColor: Color(0xffe7f9f5),
          ),
        ],
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

  NotificationTile({
    required this.date,
    required this.time,
    required this.orderNumber,
    required this.status,
    required this.statusColor,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        EasyLocalization.of(context)!.currentLocale!.languageCode == 'en';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (date.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
          padding: EdgeInsets.symmetric(horizontal: .01 * mediawidth(context)),
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
                padding:
                    EdgeInsets.symmetric(horizontal: .07 * mediawidth(context)),
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
  DiscountNotificationTile({
    required this.date,
    required this.message,
    required this.detail,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (date.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
              )),
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
    );
  }
}

class AccountSetupTile extends StatelessWidget {
  final String date;
  final String message;
  final String detail;
  final String time;

  AccountSetupTile({
    required this.date,
    required this.message,
    required this.detail,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (date.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              date,
              style: TextStyle(color: Colors.red),
            ),
          ),
        Card(
          color: Colors.green.shade100,
          child: ListTile(
            leading: Icon(Icons.check_circle),
            title: Text(message),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail),
                Text(time),
              ],
            ),
            trailing: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}

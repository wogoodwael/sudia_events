import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';
import 'package:sudia_events/presentation/screens/client/account/account_list.dart';
import 'package:sudia_events/presentation/screens/client/notification/notification.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  AccountListModel? accountListModel;
  bool account = false;
  bool notification = false;
  bool help = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    account = true;
  }

  @override
  Widget build(BuildContext context) {
    List<AccountListModel> accounts = [
      AccountListModel(
          title: 'محمد احمد علي الزهراني ',
          subTitle: '+965326326',
          ontap: () {},
          trailing: Icons.person,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'البطاقات والحسابات ',
          subTitle: '258**********535645',
          ontap: () {},
          trailing: Icons.credit_card_rounded,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'الفواتير',
          subTitle: '',
          ontap: () {
            Navigator.pushNamed(context, pills);
          },
          trailing: Icons.card_giftcard,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'محفظتي',
          subTitle: '',
          ontap: () {},
          trailing: Icons.card_giftcard,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'قيم التطبيق ',
          subTitle: '',
          ontap: () {},
          trailing: Icons.star,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'انضم الينا ',
          subTitle: '',
          ontap: () {},
          trailing: Icons.join_inner,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'الاعدادات  ',
          subTitle: '',
          ontap: () {
            Navigator.pushNamed(context, setting);
          },
          trailing: Icons.settings,
          leading: Icons.arrow_back_ios),
    ];
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(children: [
            Container(
              height: 170,
              width: 400,
              decoration: const BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
            Positioned(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                  color: Colors.white,
                ),
              ),
            )),
            Positioned(
                bottom: account ? 40 : 45,
                right: account ? 20 : 40,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        account = !account;
                        notification = false;
                        help = false;
                      });
                    },
                    child: Container(
                      width: account ? 90 : 70,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: account ? primary : Colors.grey,
                                  width: 2))),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: account ? 30 : 25,
                            backgroundColor: account ? primary : Colors.grey,
                            child: CircleAvatar(
                              radius: account ? 25 : 22,
                              backgroundColor: Colors.white,
                              child: const Center(
                                child: Icon(
                                  Icons.person_3_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "حسابي",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: account ? Colors.black : Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            Positioned(
              bottom: notification ? 50 : 60,
              left: help ? 170 : 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      notification = !notification;
                      account = false;
                      help = false;
                    });
                  },
                  child: Container(
                    width: notification ? 90 : 70,
                    height: notification ? 100 : 80,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: notification ? primary : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: notification ? 30 : 24,
                            backgroundColor:
                                notification ? primary : Colors.grey,
                            child: CircleAvatar(
                              radius: notification ? 25 : 21,
                              backgroundColor: Colors.white,
                              child: const Center(
                                child: Icon(
                                  Icons.notifications_active_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              "التنبيهات",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color:
                                    notification ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: help ? 50 : 60,
                left: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        help = !help;
                        notification = false;
                        account = false;
                      });
                    },
                    child: Container(
                      width: help ? 90 : 70,
                      height: help ? 90 : 80,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: help ? primary : Colors.grey,
                                  width: 2))),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: help ? 30 : 24,
                            backgroundColor: help ? primary : Colors.grey,
                            child: CircleAvatar(
                              radius: help ? 25 : 21,
                              backgroundColor: Colors.white,
                              child: const Center(
                                child: Icon(
                                  Icons.headset_mic_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              "مساعده",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: help ? Colors.black : Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ]),
        ),
        account
            ? Expanded(
                flex: 3,
                child: Container(
                  height: 10,
                  width: 400,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: false,
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: accounts[index].ontap,
                            child: AccountList(
                              accountListModel: accounts[index],
                            ));
                      }),
                ))
            : NotificationBody()
      ],
    );
  }
}

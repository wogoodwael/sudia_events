import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';
import 'package:sudia_events/presentation/screens/client/account/account_list.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  AccountListModel? accountListModel;
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
          trailing: Icons.card_giftcard,
          leading: Icons.arrow_back_ios),
      AccountListModel(
          title: 'نقاطي',
          subTitle: '',
          ontap: () {},
          trailing: Icons.gif_box,
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
          title: 'اللغة ',
          subTitle: '',
          ontap: () {},
          trailing: Icons.language,
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
                bottom: 40,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: 90,
                    height: 100,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: primary, width: 2))),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: primary,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.person_3_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "حسابي",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Positioned(
                bottom: 60,
                left: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: 70,
                    height: 80,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2))),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.notifications_active_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            "التنبيهات",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Positioned(
                bottom: 60,
                left: 50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: 70,
                    height: 80,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2))),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.headset_mic_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            "مساعده",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 100,
            width: 400,
            color: Colors.white,
            child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: accounts[index].ontap,
                      child: AccountList(
                        accountListModel: accounts[index],
                      ));
                }),
          ),
        )
      ],
    );
  }
}

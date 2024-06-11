import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';
import 'package:sudia_events/data/model/user_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/client/account/account_list.dart';
import 'package:sudia_events/presentation/screens/client/notification/notification.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool account = true;
  bool notification = false;
  bool help = false;

  @override
  Widget build(BuildContext context) {
    List<AccountListModel> accounts = _getAccounts();

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          flex: 3,
          child: account
              ? _buildAccountSection(accounts)
              : const NotificationBody(),
        ),
      ],
    );
  }

  List<AccountListModel> _getAccounts() {
    return [
      AccountListModel(
        title: 'البطاقات والحسابات ',
        subTitle: '258**********535645',
        ontap: () {},
        trailing: Icons.credit_card_rounded,
        leading: Icons.arrow_back_ios,
      ),
      AccountListModel(
        title: 'الفواتير',
        subTitle: '',
        ontap: () {
          Navigator.pushNamed(context, pills);
        },
        trailing: Icons.card_giftcard,
        leading: Icons.arrow_back_ios,
      ),
      AccountListModel(
        title: 'محفظتي',
        subTitle: '',
        ontap: () {},
        trailing: Icons.card_giftcard,
        leading: Icons.arrow_back_ios,
      ),
      AccountListModel(
        title: 'قيم التطبيق ',
        subTitle: '',
        ontap: () {},
        trailing: Icons.star,
        leading: Icons.arrow_back_ios,
      ),
      AccountListModel(
        title: 'انضم الينا ',
        subTitle: '',
        ontap: () {},
        trailing: Icons.join_inner,
        leading: Icons.arrow_back_ios,
      ),
      AccountListModel(
        title: 'الاعدادات  ',
        subTitle: '',
        ontap: () {
          Navigator.pushNamed(context, setting);
        },
        trailing: Icons.settings,
        leading: Icons.arrow_back_ios,
      ),
    ];
  }

  Widget _buildHeader() {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          _buildHeaderBackground(),
          _buildHeaderLogo(),
          _buildAccountTab(),
          _buildNotificationTab(),
          _buildHelpTab(),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Positioned(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Image.asset(
            "assets/images/logo.png",
            width: 200,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTab() {
    return Positioned(
      bottom: account ? 40 : 45,
      right: account ? 20 : 40,
      child: _buildTab(
        onTap: () {
          setState(() {
            account = !account;
            notification = false;
            help = false;
          });
        },
        selected: account,
        icon: Icons.person_3_outlined,
        label: "حسابي",
        width: account ? 90 : 70,
        height: 100,
        iconSize: account ? 30 : 25,
        fontSize: 20,
      ),
    );
  }

  Widget _buildNotificationTab() {
    return Positioned(
      bottom: notification ? 50 : 60,
      left: help ? 170 : 150,
      child: _buildTab(
        onTap: () {
          setState(() {
            notification = !notification;
            account = false;
            help = false;
          });
        },
        selected: notification,
        icon: Icons.notifications_active_outlined,
        label: "التنبيهات",
        width: notification ? 90 : 70,
        height: notification ? 100 : 80,
        iconSize: notification ? 30 : 25,
        fontSize: 15,
      ),
    );
  }

  Widget _buildHelpTab() {
    return Positioned(
      bottom: help ? 50 : 60,
      left: 50,
      child: _buildTab(
        onTap: () {
          setState(() {
            help = !help;
            notification = false;
            account = false;
          });
        },
        selected: help,
        icon: Icons.headset_mic_outlined,
        label: "مساعده",
        width: help ? 90 : 70,
        height: help ? 90 : 80,
        iconSize: help ? 30 : 25,
        fontSize: 15,
      ),
    );
  }

  Widget _buildTab({
    required VoidCallback onTap,
    required bool selected,
    required IconData icon,
    required String label,
    required double width,
    required double height,
    required double iconSize,
    required double fontSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? primary : Colors.grey,
              width: 2,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: iconSize,
                backgroundColor: selected ? primary : Colors.grey,
                child: CircleAvatar(
                  radius: iconSize - 3,
                  backgroundColor: Colors.white,
                  child: Icon(icon, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: selected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(List<AccountListModel> accounts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<UserModel>>(
            stream: fetchUserData(id: sharedpref.getString('token')!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: primary));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              }
              return Column(
                children: [
                  ListTile(
                    title: Text(snapshot.data![0].name,
                        textDirection: TextDirection.rtl),
                    subtitle: Text(snapshot.data![0].phone,
                        textDirection: TextDirection.rtl),
                    trailing: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[300],
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(Icons.person, size: 15),
                      ),
                    ),
                    leading: const Icon(Icons.arrow_back_ios, size: 15),
                  ),
                  Divider(
                      height: 0,
                      endIndent: 15,
                      indent: 15,
                      color: Colors.grey[300]),
                ],
              );
            },
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: accounts[index].ontap,
                  child: AccountList(accountListModel: accounts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

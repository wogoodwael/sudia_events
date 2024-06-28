import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/user_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Auth/login.dart';
import 'package:sudia_events/presentation/screens/client/account/message.dart';
import 'package:sudia_events/presentation/screens/client/account/user_profile.dart';
import 'package:sudia_events/presentation/screens/favorite/fav.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Add back button functionality
            },
          ),
        ],
        title: Text('Account'.tr(), style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.more_horiz_outlined),
          onPressed: () {
            // Add more options functionality
          },
        ),
        elevation: 0,
      ),
      body: Container(
        width: mediawidth(context),
        height: mediaheight(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<List<UserModel>>(
                  stream: fetchUserData(id: sharedpref.getString('token')!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: primary));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Row(
                        children: [
                          const Text('لم تقم بانشاء الحساب بعد '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen()));
                            },
                            child: const Text(
                              'انشئ حساب ',
                              style: TextStyle(
                                  color: primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: primary),
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: primary,
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => UserFormScreen()));
                                  },
                                ),
                              ),
                              SizedBox(width: .05 * mediawidth(context)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      snapshot.data![0].name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(snapshot.data![0].phone),
                                        SizedBox(width: 8),
                                        Icon(Icons.phone, size: 16),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![0].email,
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.email, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  snapshot.data![0].img,
                                ), // Your avatar image
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            minWidth: .6 * mediawidth(context),
                            color: secondary,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                        child: Text(
                                      'log out'.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    content: Text(
                                      'sure'.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          MaterialButton(
                                            minWidth: 100,
                                            color: primary,
                                            child: Text(
                                              'next'.tr(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          LoginScreen()));
                                            },
                                          ),
                                          MaterialButton(
                                            minWidth: 100,
                                            child: Text('not sure'.tr()),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'log out'.tr(),
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.exit_to_app,
                                  size: 15,
                                  color: primary,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('location'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to addresses
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorite'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FavouriteScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.local_offer),
                title: Text('trending'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to promotional offers
                },
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('payment methods'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to payment methods
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('My wallet'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to wallet
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MessageScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text('join us'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to join us
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('invite freinds'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to invite friends
                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('security'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to security
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('help center'.tr()),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add navigation to help center
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('language'.tr()),
                        DropdownButton<String>(
                          value: 'العربية',
                          items: <String>['العربية', 'English']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {
                            // Handle language change
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'notification'.tr(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Transform.scale(
                          scale: .7,
                          child: Switch(
                            activeColor: primary,
                            value: false,
                            onChanged: (bool value) {
                              // Handle notification toggle
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Auto Update'.tr(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Transform.scale(
                          scale: .7,
                          child: Switch(
                            activeColor: primary,
                            value: true,
                            onChanged: (bool value) {
                              // Handle notification toggle
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'sounds'.tr(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Transform.scale(
                          scale: .7,
                          child: Switch(
                            activeColor: primary,
                            value: false,
                            onChanged: (bool value) {
                              // Handle notification toggle
                            },
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text(
                        'Auto Update'.tr(),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle automatic updates
                      },
                    ),
                    ListTile(
                      title: Text('conditions'.tr()),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle terms of service
                      },
                    ),
                    ListTile(
                      title: Text('privacy policy'.tr()),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle privacy policy
                      },
                    ),
                    ListTile(
                      title: Text('terms of use'.tr()),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle replacement and refund policy
                      },
                    ),
                    ListTile(
                      title: Text('About App'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle about app
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

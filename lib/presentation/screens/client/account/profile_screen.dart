import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/user_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Auth/login.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';
import 'package:sudia_events/presentation/screens/client/account/feedback.dart';
import 'package:sudia_events/presentation/screens/client/account/help_center.dart';
import 'package:sudia_events/presentation/screens/client/account/invite_freinds.dart';
import 'package:sudia_events/presentation/screens/client/account/message.dart';
import 'package:sudia_events/presentation/screens/client/account/trending.dart';
import 'package:sudia_events/presentation/screens/client/account/user_profile.dart';
import 'package:sudia_events/presentation/screens/favorite/fav.dart';
import 'package:sudia_events/presentation/screens/home/location.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  const ProfileScreen({super.key, required this.id});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _switchValue = false;

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/notify.png"),
              const Text(
                "Notification",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                  "please Enable The notification to recieve updates and reminders?"),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                MaterialButton(
                  minWidth: .9 * mediawidth(context),
                  color: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "Turn on",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    PermissionStatus status =
                        await Permission.notification.request();

                    if (status.isGranted) {
                      print("Notification permission granted");
                      initializeFCM();
                    } else {
                      setState(() {
                        _switchValue = false;
                      });
                      print("Notification permission not granted");
                      if (status.isPermanentlyDenied) {
                        openAppSettings();
                      }
                    }
                  },
                ),
                MaterialButton(
                  minWidth: .9 * mediawidth(context),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: primary),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text("Skip for now "),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _switchValue = false;
                    });
                    print("Notification permission denied by user");
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future _firebaseBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print("Some notification Received in background...");
    }
  }

  void initializeFCM() {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Handle notification when the app is opened from the background
      }
    });
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy/MM/dd', 'ar').format(DateTime.now()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              DateFormat('EEEE', 'ar').format(DateTime.now()),
            ),
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
              .doc(widget.id)
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
      body: SizedBox(
        width: mediawidth(context),
        height: mediaheight(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<List<UserModel>>(
                  stream:
                      fetchUserData(id: sharedpref.getString('token') ?? ""),
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
                    sharedpref.setString("user", snapshot.data![0].name);
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: primary,
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
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
                                      snapshot.data?[0].name ?? "",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(snapshot.data?[0].phone ?? ""),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.phone, size: 16),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data?[0].email ?? "",
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.email, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  snapshot.data?[0].img ?? "",
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    content: Text(
                                      'sure'.tr(),
                                      style: const TextStyle(
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
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              await sharedpref.clear();
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        LoginScreen()),
                                                (Route<dynamic> route) => false,
                                              );
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
                                  style: const TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
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
                leading: const Icon(Icons.location_on),
                title: Text('location'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
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
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: Text('Favorite'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FavouriteScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_offer),
                title: Text('trending'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PromotionScreen()));
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.payment),
              //   title: Text('payment methods'.tr()),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {},
              // ),
              // ListTile(
              //   leading: const Icon(Icons.account_balance_wallet),
              //   title: Text('My wallet'.tr()),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // Add navigation to wallet
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('ملاحظات المستخدمين'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FeedbackScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: Text('Messages'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MessageScreen()));
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.group_add),
              //   title: Text('join us'.tr()),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // Add navigation to join us
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: Text('invite freinds'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => InviteFriendsScreen()));
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.security),
              //   title: Text('security'.tr()),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // Add navigation to security
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.help),
                title: Text('help center'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HelpCenterScreen()));
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('language'.tr()),
                    //     DropdownButton<String>(
                    //       value: 'العربية',
                    //       items: <String>['العربية', 'English']
                    //           .map((String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value),
                    //         );
                    //       }).toList(),
                    //       onChanged: (_) {
                    //         // Handle language change
                    //       },
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'notification'.tr(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Transform.scale(
                          scale: .7,
                          child: Switch(
                            activeColor: primary,
                            value: _switchValue,
                            onChanged: (bool value) async {
                              String? token =
                                  await FirebaseMessaging.instance.getToken();
                              print("device token $token");
                              setState(() {
                                _switchValue = value;
                              });
                              if (value) {
                                // If the switch is turned on, request notification permission
                                _showPermissionDialog(context);
                              } else {
                                openAppSettings();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //       child: Text(
                    //         'Auto Update'.tr(),
                    //         style: const TextStyle(fontSize: 15),
                    //       ),
                    //     ),
                    //     Transform.scale(
                    //       scale: .7,
                    //       child: Switch(
                    //         activeColor: primary,
                    //         value: true,
                    //         onChanged: (bool value) {
                    //           // Handle notification toggle
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //       child: Text(
                    //         'sounds'.tr(),
                    //         style: const TextStyle(fontSize: 15),
                    //       ),
                    //     ),
                    //     Transform.scale(
                    //       scale: .7,
                    //       child: Switch(
                    //         activeColor: primary,
                    //         value: false,
                    //         onChanged: (bool value) {
                    //           // Handle notification toggle
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // ListTile(
                    //   title: Text(
                    //     'Auto Update'.tr(),
                    //   ),
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    //   onTap: () {
                    //     // Handle automatic updates
                    //   },
                    // ),
                    ListTile(
                      title: Text('conditions'.tr()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TermOfServiceScreen()));
                      },
                    ),
                    ListTile(
                      title: Text('privacy policy'.tr()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PrivacyPolicyScreen()));
                      },
                    ),
                    ListTile(
                      title: Text('terms of use'.tr()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ReturnAndRefundPolicyScreen()));
                      },
                    ),
                    // ListTile(
                    //   title: const Text('About App'),
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    //   onTap: () {
                    //     // Handle about app
                    //   },
                    // ),
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

class TermOfServiceScreen extends StatelessWidget {
  const TermOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolicyScreen(
      title: 'شروط الخدمة',
      content: 'شروط الخدمة المحتوى ...',
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolicyScreen(
      title: 'سياسة الخصوصية',
      content: 'سياسة الخصوصية المحتوى ...',
    );
  }
}

class ReturnAndRefundPolicyScreen extends StatelessWidget {
  const ReturnAndRefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolicyScreen(
      title: 'سياسة الاستبدال والاسترجاع',
      content: 'سياسة الاستبدال والاسترجاع المحتوى ...',
    );
  }
}

class PolicyScreen extends StatelessWidget {
  final String title;
  final String content;

  const PolicyScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(content, textAlign: TextAlign.justify),
        ),
      ),
    );
  }
}

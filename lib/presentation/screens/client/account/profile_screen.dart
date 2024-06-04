import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/user_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/client/account/user_profile.dart';

class ProfileScreen extends StatelessWidget {
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
        title: Text('صفحتي', style: TextStyle(color: Colors.black)),
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primary,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => UserFormScreen()));
                    },
                  ),
                ),
                Spacer(),
                SizedBox(width: 16),
                FutureBuilder<List<UserModel>>(
                    future: fetchUserData(id: sharedpref.getString('token')!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(color: primary));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data available');
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              snapshot.data![0].name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                      );
                    }),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/person.png'), // Your avatar image
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
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "تسجيل الخروج",
                    style:
                        TextStyle(color: primary, fontWeight: FontWeight.bold),
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
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('عناويني'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to addresses
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('المفضلة'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to favorites
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('عروضي الترويجية'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to promotional offers
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('طرق الدفع'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to payment methods
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('محفظتي'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to wallet
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('الرسائل'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to messages
            },
          ),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('انضم إلينا'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to join us
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('دعوة أصدقائك'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to invite friends
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('الحماية'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Add navigation to security
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('مركز المساعدة'),
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
                    Text('اللغة'),
                    DropdownButton<String>(
                      value: 'العربية',
                      items: <String>['العربية', 'English'].map((String value) {
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
                        'الإشعارات',
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
                        'التحديث التلقائي',
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
                        'الاصوات',
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
                  title: Text('التحديث تلقائيًا'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle automatic updates
                  },
                ),
                ListTile(
                  title: Text('شروط الخدمة'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle terms of service
                  },
                ),
                ListTile(
                  title: Text('سياسة الخصوصية'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle privacy policy
                  },
                ),
                ListTile(
                  title: Text('سياسة الاستبدال والاسترجاع'),
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
    );
  }
}

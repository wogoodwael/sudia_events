import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/All/continue.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';

class InvitationCardScreen extends StatefulWidget {
  final String id;
  final DateTime date;
  final List<String> price = ['مجانية', '15.00SR', '35.00SR'];
  final List<String> name = ['M458w', 'M8ws', 'Mqqk'];

  InvitationCardScreen({super.key, required this.id, required this.date});

  @override
  _InvitationCardScreenState createState() => _InvitationCardScreenState();
}

class _InvitationCardScreenState extends State<InvitationCardScreen> {
  TextEditingController husband = TextEditingController();
  TextEditingController wife = TextEditingController();
  TextEditingController visitors = TextEditingController();
  String _selectedPrice = '';
  String _selectedRadio = '';
  String _selectedCheckbox = '';
  String _selectedCheckboxCard = '';
  String _selectedImage = '';
  List<bool> isAddedToFavList = [];

  @override
  void initState() {
    super.initState();
    isAddedToFavList = List<bool>.filled(widget.price.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  icon: Icon(
                    Icons.shopify_rounded,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutScreenOverView(
                                  id: widget.id,
                                )));
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$favoriteCount',
                      style: TextStyle(
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
        title: Text('بطاقة الدعوة'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvitationForm(husband: husband, wife: wife, visitors: visitors,),
              SizedBox(height: 16),
              Container(
                color: Colors.white,
                width: .9 * mediawidth(context),
                height: .27 * mediaheight(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.price.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPrice = widget.price[index];
                        });
                      },
                      child: _buildCardItem(context, widget.price[index],
                          widget.name[index], widget.name[index], index),
                    );
                  },
                ),
              ),
              Center(
                child: MaterialButton(
                  minWidth: .9 * mediawidth(context),
                  color: primary,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ContinueInvitation(
                                  id: widget.id,
                                  husband: husband.text,
                                  wife: wife.text,
                                  visitors: visitors.text,
                                  date: widget.date,
                                )));
                  },
                  child: Text(
                    "التالي ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, String price, String title,
      String cardName, int index) {
    Future<void> addToFavorites(BuildContext context) async {
      try {
        // Get current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // User is not logged in
          // You can handle this case according to your app's logic
          return;
        }

        // Add item to favorites collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .add({
          'img':
              'https://firebasestorage.googleapis.com/v0/b/saudievents-99e16.appspot.com/o/invitation_images%2Finvitation.png?alt=media&token=5763a96c-55eb-4995-8625-257d1258f562',
          'name': cardName,
          'discount': "",
          'price': price,
          // You can add more fields if needed
        });
        setState(() {
          isAddedToFavList[index] = !isAddedToFavList[index];
        });
        // Show a snackbar or toast to indicate success
        CustomSnackBar(
          context,
          'add to fav'.tr(),
          Colors.green,
          .75 * mediaheight(context),
        );
      } catch (e) {
        // Handle errors
        print('Error adding to favorites: $e');
      }
    }

    return Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Container(
        width: 150,
        height: .25 * mediaheight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(8.0)),
                  child: Image.asset(
                    'assets/images/invitation.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: () async {
                      await addToFavorites(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                          isAddedToFavList[index]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Checkbox(
                        side: BorderSide(color: Colors.grey),
                        value: _selectedCheckboxCard == title,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedCheckboxCard = value! ? title : '';
                          });
                        },
                      ),
                      Text(
                        cardName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    price,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('4.9'),
                    Icon(Icons.star, size: 20, color: Colors.yellow[600]),
                    SizedBox(width: 4.0),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _additionContainer(String label, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            labelText: 'اسم العريس',
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            context: context,
            controller: husband,
          ),
          SizedBox(
            height: .02 * mediaheight(context),
          ),
          _buildTextField(
            labelText: 'الإسم الإضافي ..',
            icon: Icon(
              Icons.check_circle,
            ),
            iconColor: Colors.orange,
            context: context,
          ),
          SizedBox(height: .02 * mediaheight(context)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: .9 * mediawidth(context),
              height: 45,
              color: Colors.white,
              child: Text(
                'مثال : اسم العروس\nإبنة - كريمة : محمد بن عبدالعزيز ..',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String labelText,
    required Widget icon,
    Color iconColor = Colors.grey,
    TextEditingController? controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: icon,
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class InvitationForm extends StatefulWidget {
  final TextEditingController husband, wife, visitors;

  const InvitationForm({super.key, required this.husband, required this.wife, required this.visitors});
  @override
  _InvitationFormState createState() => _InvitationFormState();
}

class _InvitationFormState extends State<InvitationForm> {
  int _selectedBridegroom = 1;
  int _selectedRole = 1;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('اسم العريس', style: TextStyle(fontSize: 15)),
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: widget.husband,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'محمد احمد ',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text('اختر', style: TextStyle(fontSize: 14)),
            RadioListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text("علي ابنة"),
              ),
              value: 1,
              groupValue: _selectedRole,
              onChanged: (val) {
                setState(() {
                  _selectedRole = val as int; // Ensure the type cast is to int
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
            ),
            RadioListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text("علي كريمة"),
              ),
              value: 2,
              groupValue: _selectedRole,
              onChanged: (val) {
                setState(() {
                  _selectedRole = val as int; // Ensure the type cast is to int
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: widget.wife,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'علي احمد الزهراني',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  )),
            ),
            RadioListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text("الداعي"),
              ),
              value: 1,
              groupValue: _selectedBridegroom,
              onChanged: (val) {
                setState(() {
                  _selectedBridegroom =
                      val as int; // Ensure the type cast is to int
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
            ),
            RadioListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text("الداعون"),
              ),
              value: 2,
              groupValue: _selectedBridegroom,
              onChanged: (val) {
                setState(() {
                  _selectedBridegroom =
                      val as int; // Ensure the type cast is to int
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: widget.visitors,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'الاسم الاول - الاسم الثاني ',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text('العنوان', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'قاعة السلام للاحتفالات الكبري ',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.location_city,
                          color: Colors.grey,
                        )),
                  )),
            ),
            SizedBox(height: 16),
            Text('التلفون', style: TextStyle(fontSize: 18)),
            Center(
              child: Container(
                width: .8 * mediawidth(context),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: .01 * mediaheight(context)),
                  child: IntlPhoneField(
                    controller: _phoneController,
                    dropdownIcon: Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5, left: 10),
                      border: InputBorder.none,
                      counterText: "",
                      errorStyle: TextStyle(
                          fontSize: 0, height: 0), // This hides the error text
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                      sharedpref.setString('phone', phone.completeNumber);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

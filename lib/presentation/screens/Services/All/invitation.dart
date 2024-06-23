import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';

// ignore: must_be_immutable
class InvitationCardScreen extends StatelessWidget {
  final String id;
  List price = ['مجانية', '15.00SR', '35.00SR'];

  InvitationCardScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                                  id: id,
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
              Center(
                child: Container(
                  width: .85 * mediawidth(context),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(.4))),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.check_box,
                        size: 20,
                        color: primary,
                      ),
                      labelText: 'ارفاق',
                      border: InputBorder.none,
                    ),
                    items: <String>['Option 1', 'Option 2', 'Option 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "اختر",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                color: Colors.white,
                width: .9 * mediawidth(context),
                height: .27 * mediaheight(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCardItem(context, price[index]);
                  },
                ),
              ),
              SizedBox(height: 16),
              _additionContainer('اسم العريس', context),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Text(
                      'اختر',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'اللهم بارك لهما ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          leading: RadioTheme(
                            data: RadioThemeData(
                              fillColor: MaterialStateColor.resolveWith(
                                (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.grey;
                                  }
                                  return Colors.grey;
                                },
                              ),
                            ),
                            child: Radio(
                              value: 'option1',
                              groupValue: 'option',
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        RadioTheme(
                          data: RadioThemeData(
                            fillColor: MaterialStateColor.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.grey;
                                }
                                return Colors.grey;
                              },
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              'الحمد لله',
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: Radio(
                              value: 'option2',
                              groupValue: 'option',
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        RadioTheme(
                          data: RadioThemeData(
                            fillColor: MaterialStateColor.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.grey;
                                }
                                return Colors.grey;
                              },
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              'جديد',
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: Radio(
                              value: 'option2',
                              groupValue: 'option',
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: .95 * mediawidth(context),
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'بكل الصفا والود وروعة اريج الورد عسي السعادة في حياتهم تزدهر والحظ يضحك لهما علي طول الزمان ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  _buildCheckbox('ممنوع اصطحاب الأطفال'),
                  _buildCheckbox('ممنوع إستخدام الكاميرا والتصوير'),
                  _buildCheckbox('الدخول ببطاقة الدعوة'),
                ],
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 5,
                child: Container(
                  width: .9 * mediawidth(context),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MaterialButton(
                        minWidth: 150,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: primary,
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              "اضافة",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.check_circle_outline,
                              size: 15,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Text(
                        'SAR 15.00',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, String price) {
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
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, color: Colors.red),
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
                          value: false,
                          onChanged: (bool? value) {}),
                      Text(
                        'بطاقة M24001',
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
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
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

  Widget _buildCheckbox(String title) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (bool? value) {}),
        Text(title),
      ],
    );
  }
}

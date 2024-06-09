import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

class CheckoutScreen extends StatefulWidget {
  final String name;
  final String number;
  CheckoutScreen({required this.name, required this.number});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> _checkoutItems = [];
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _total = 0.0;
  double _deliveryFee = 20.0; // Assuming a fixed delivery fee

  @override
  void initState() {
    super.initState();
    _fetchCheckoutItems();
  }

  Future<void> _fetchCheckoutItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('SubServices')
          .doc(user.uid)
          .collection('checkout')
          .where('name', isEqualTo: widget.name)
          .get();

      List<Map<String, dynamic>> checkoutItems = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        _checkoutItems = checkoutItems;
        _calculatePrices();
      });
    }
  }

  void _calculatePrices() {
    _subtotal = _checkoutItems.fold(0.0, (sum, item) {
      double itemPrice = double.parse(item['price']);
      double itemDiscount = double.parse(item['discount']);
      double itemTotalPrice = itemPrice - (itemPrice * itemDiscount / 100);
      List options = item['options'] as List;
      for (var option in options) {
        itemTotalPrice += double.parse(option['price']);
      }
      return sum + itemTotalPrice;
    });

    _discount = _subtotal * 0.20;
    _total = _subtotal - _discount + _deliveryFee;
  }

  Future<void> _uploadCheckoutData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference bookedServices =
            FirebaseFirestore.instance.collection('booked_services');
        DateTime now = DateTime.now();

        for (var item in _checkoutItems) {
          await bookedServices.add({
            'user_id': user.uid,
            'name': widget.name,
            'number': widget.number,
            'item_name': item['name'],
            'price': item['price'],
            'discount': item['discount'],
            'options': item['options'],
            'timestamp': now,
            'subtotal': _subtotal,
            'discount_amount': _discount,
            'delivery_fee': _deliveryFee,
            'total': _total
          });
        }
        CustomSnackBar(context, 'تم حجز الخدمة', Colors.green);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    BottomBarScreen(id: sharedpref.getString('token')!)));
        // Optionally, clear the checkout items or navigate to a success screen
      }
    } on Exception catch (e) {
      CustomSnackBar(context, e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'SP 0023450',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: _checkoutItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: .09 * mediaheight(context),
                    width: mediawidth(context),
                    child: ListView.builder(
                      itemCount: _checkoutItems.length,
                      itemBuilder: (context, index) {
                        final item = _checkoutItems[index];
                        double optionsTotalPrice =
                            item['options'].fold(0.0, (sum, option) {
                          return sum + double.parse(option['price']);
                        });
                        String all =
                            (double.parse(item['price']) + optionsTotalPrice)
                                .toString();
                        return Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          elevation: 5,
                          child: Container(
                            height: .6 * mediaheight(context),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '09:56 10/05/2024', // Placeholder for date/time
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Text(
                                      item['name'] ??
                                          'حجز رقم SP 0023900', // Placeholder for title
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    SizedBox(width: 16.0),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'عدد الخدمات',
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    Text(
                                      item['options']
                                          .length
                                          .toString(), // Placeholder for quantity
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.red),
                                    ),
                                  ],
                                ),

                                OrderItem(
                                  title: item[
                                      'name'], // Assuming 'title' key exists
                                  price:
                                      'SAR${item['price']}', // Placeholder for price
                                  options: item['options'] as List<
                                      dynamic>, // Assuming 'options' is a List<dynamic>
                                ),
                                Divider(
                                  endIndent: 10,
                                  indent: 10,
                                ),
                                // Repeat _OrderItem as needed based on your data structure
                                SizedBox(height: 10.0),

                                Row(
                                  children: [
                                    Text(
                                      'الاجمالي',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Text(
                                      'SAR${all}', // Total price
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'التوصيل إلى',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_pin,
                                          color: Colors.red),
                                      SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'الاستلام من -- مطعم الديرة', // Placeholder for pickup location
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            'حي السلامة - جدة - المملكة العربية السعودية', // Placeholder for address
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    width: .9 * mediawidth(context),
                    height: .08 * mediaheight(context),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: .9 * mediawidth(context),
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(.5)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, top: 5),
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        color: primary,
                                      ),
                                    ),
                                    Text("طريقة الدفع")
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "كاش ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: .02 * mediaheight(context),
                          ),
                          Container(
                            width: .9 * mediawidth(context),
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(.5)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, top: 5),
                                      child: Icon(
                                        Icons.local_activity,
                                        size: 15,
                                        color: primary,
                                      ),
                                    ),
                                    Text(" خصومات")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: .02 * mediawidth(context),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[700],
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: Center(
                                        child: Text(
                                          "خصم",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 30,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[700],
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: Center(
                                        child: Text(
                                          "20%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'المجموع',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                'SAR${_subtotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'مقدار الخصم',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                '20%',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'مبلغ الخصم',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                'SAR${_discount.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'التوصيل',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                'SAR${_deliveryFee.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الإجمالي',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'SAR${_total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            elevation: 5,
                            child: Container(
                              width: .9 * mediawidth(context),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MaterialButton(
                                    minWidth: 150,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: primary,
                                    onPressed: () {
                                      _uploadCheckoutData();
                                    },
                                    child: Text(
                                      "الدفع",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'SAR${_total.toStringAsFixed(2)}',
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
                )
              ],
            ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String title;
  final String price;
  final List<dynamic> options;

  OrderItem({
    required this.title,
    required this.price,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(
          price,
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        SizedBox(height: 4.0),
        ...options.map((option) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${option['option']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  Text(
                    ' SAR${option['price']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              Divider(
                height: 0,
              ),
              // Repeat _OrderItem as needed based on your data structure
            ],
          );
        }).toList(),
      ],
    );
  }
}

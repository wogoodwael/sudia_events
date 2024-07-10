import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';

class OrderSummaryPage extends StatefulWidget {
  final String name;
  final String number;
  final String uniquId;
  final DateTime date;
  const OrderSummaryPage(
      {super.key,
      required this.name,
      required this.number,
      required this.date,
      required this.uniquId});
  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  List<Map<String, dynamic>> _checkoutItems = [];
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _deliveryFee = 0.0; // Assuming free delivery
  double _total = 0.0;
  String _reasonForCancellation = 'Duplicate order';

  @override
  void initState() {
    super.initState();
    _fetchCheckoutItems();
  }

  bool _isLoading = true;
  bool _hasError = false;

  Future<void> _fetchCheckoutItems() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('SubServices')
            .doc(user.uid)
            .collection('checkout')
            .get();

        List<Map<String, dynamic>> checkoutItems =
            querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();

        setState(() {
          _checkoutItems = checkoutItems;
          _isLoading = false;
          _hasError = false;
          _calculatePrices();
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _checkoutItems.isEmpty
              ? Center(
                  child: Text("لا يوجد اضافات بعد"),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ملخص الحجز"),
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _checkoutItems.length,
                          itemBuilder: (context, index) {
                            var item = _checkoutItems[index];
                            return Card(
                              elevation: 5,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                top:
                                                    .04 * mediaheight(context)),
                                            width: 70,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Reorder",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white),
                                                ),
                                                Icon(
                                                  Icons.shopping_bag,
                                                  color: Colors.white,
                                                  size: 15,
                                                )
                                              ],
                                            )),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'SAR ${(double.parse(item['price']) * (1 - double.parse(item['discount']) / 100)).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'SAR ${item['price']}',
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            item['img'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    ...item['options'].map<Widget>((option) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'SAR ${option['price']}',
                                              style: TextStyle(
                                                  color: primary, fontSize: 12),
                                            ),
                                            Spacer(),
                                            Text(option['option']),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: .9 * mediawidth(context),
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(.5)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primary,
                                    ),
                                    Text("لا يوجد توصيل ")
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                height: 50,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'SAR ${_subtotal.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text('Subtotal'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'FREE',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text('Delivery Fee'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '- SAR ${_discount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text('Discount'),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          Text(
                                            'SAR ${_total.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text('Total'),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(_reasonForCancellation),
                                        ],
                                      ),
                                      SizedBox(
                                        height: .02 * mediaheight(context),
                                      ),
                                      MaterialButton(
                                        color: primary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minWidth: .9 * mediawidth(context),
                                        height: 40,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      CheckoutScreen(
                                                        name: widget.name,
                                                        number: widget.number,
                                                        date: widget.date,
                                                        uniquID: widget.uniquId,
                                                      )));
                                          sharedpref.setString(
                                              'name', widget.name);
                                          sharedpref.setString(
                                              'number', widget.number);
                                          sharedpref.setString(
                                              'date', widget.date.toIso8601String());
                                          sharedpref.setString(
                                              'uniquID', widget.uniquId);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "اضافة ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.shopping_bag,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
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

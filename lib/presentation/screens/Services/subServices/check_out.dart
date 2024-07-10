import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
import 'package:intl/intl.dart' as intl;

class CheckoutScreen extends StatefulWidget {
  final String name;
  final String number;
  final String uniquID;
  final DateTime date;
  const CheckoutScreen(
      {super.key,
      required this.name,
      required this.number,
      required this.date,
      required this.uniquID});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> _checkoutItems = [];
  double _subtotal = 0.0;
  double _discount = 0.0;
  double _total = 0.0;
  final double _deliveryFee = 20.0;
  bool public = false; // Assuming a fixed delivery fee

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

        for (var item in _checkoutItems) {
          await bookedServices.add({
            'user_id': user.uid,
            'name': widget.name,
            'number': widget.number,
            'item_name': item['name'],
            'price': item['price'],
            'discount': item['discount'],
            'options': item['options'],
            'timestamp': widget.date,
            'subtotal': _subtotal,
            'discount_amount': _discount,
            'delivery_fee': _deliveryFee,
            'total': _total,
            'status': 'pending',
            'uniquID': sharedpref.getString("uniquId"),
            'type': "public"
          });
          sharedpref.setString('uniquID', widget.uniquID);
          sharedpref.setString('date', widget.date.timeZoneName);
        }
        CustomSnackBar(
          context,
          'تم حجز الخدمة',
          Colors.green,
          .75 * mediaheight(context),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BottomBarScreen(
                      id: sharedpref.getString('token')!,
                      public: true,
                      uniquId: widget.uniquID,
                      date: widget.date,
                    )));
        // Optionally, clear the checkout items or navigate to a success screen
      }
    } on Exception catch (e) {
      CustomSnackBar(
        context,
        e.toString(),
        Colors.red,
        .9 * mediaheight(context),
      );
    }
  }

  Future<void> _removeFromCheckOut() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is currently signed in.');
        return;
      }

      QuerySnapshot checkoutSnapshot = await FirebaseFirestore.instance
          .collection('SubServices')
          .doc(user.uid)
          .collection('checkout')
          .get();

      // Use WriteBatch for atomic deletion
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot doc in checkoutSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      print('All checkout documents deleted for user: ${user.uid}');
    } catch (e) {
      print('Error removing checkout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'SP 0023450',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: _checkoutItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'حجز رقم ${item['uniquID'].split('-').last}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    Text(
                                      intl.DateFormat('yyyy/MM/dd', 'en')
                                          .format(widget.date),
                                      style: const TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                OrderItem(
                                  title:
                                      '${index + 1}   ${item['name']}', // Assuming 'title' key exists
                                  price:
                                      'SAR${item['price']}', // Placeholder for price
                                  options: item['options'] as List<dynamic>,
                                  number: item['uniquID']
                                      .split('-')
                                      .last, // Assuming 'options' is a List<dynamic>
                                ),
                                const SizedBox(height: 10.0),
                                const SizedBox(height: 16.0),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.grey,
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'التوصيل إلى ->  المنزل',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'حي السلامة - جدة - المملكة العربية السعودية',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                OrderItem(
                                  title:
                                      '${index + 2}   ${item['name']}', // Assuming 'title' key exists
                                  price:
                                      'SAR${item['price']}', // Placeholder for price
                                  options: item['options'] as List<dynamic>,
                                  number: item['uniquID']
                                      .split('-')
                                      .last, // Assuming 'options' is a List<dynamic>
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.grey,
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'الاستلام من ->  مطعم الباشا',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '512 -حي السلامة - جدة - المملكة العربية السعودية',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                const Divider(),
                                const SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
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
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
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
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
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
                                      child: const Center(
                                        child: Text(
                                          "خصم",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 30,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[700],
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: const Center(
                                        child: Text(
                                          "20%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
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
                              const Text(
                                'المجموع',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                'SAR${_subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          const Row(
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
                              const Text(
                                'مبلغ الخصم',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                'SAR${_discount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'التوصيل',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                              Text(
                                'SAR${_deliveryFee.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'الإجمالي',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'SAR${_total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            elevation: 5,
                            child: SizedBox(
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
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('تاكيد  الدفع'),
                                            content: const Text(
                                                'هل انت متاكد من حجز الخدمة ؟ '),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  _uploadCheckoutData();
                                                  _removeFromCheckOut();
                                                  // Close the dialog
                                                },
                                                child: const Text('نعم'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            BottomBarScreen(
                                                              uniquId: widget
                                                                  .uniquID,
                                                              date: widget.date,
                                                              id: sharedpref
                                                                  .getString(
                                                                      'token')!,
                                                              public: false,
                                                            )),
                                                  );
                                                },
                                                child: const Text('لا'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "الدفع",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'SAR${_total.toStringAsFixed(2)}',
                                    style: const TextStyle(
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
  final String number;
  final List<dynamic> options;

  const OrderItem({
    super.key,
    required this.title,
    required this.price,
    required this.options,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(
                "4.9",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.yellow[600],
                size: 15,
              ),
              const Spacer(),
              Text(
                number,
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              )
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        ...options.map((option) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${option['option']}',
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text(
                      ' SAR${option['price']}',
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Repeat _OrderItem as needed based on your data structure
            ],
          );
        }),
      ],
    );
  }
}

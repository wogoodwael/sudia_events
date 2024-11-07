import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/review.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

class MenuItemDetail extends StatefulWidget {
  final String img;
  final String name;
  final String price;
  final String rating;
  final String dis;
  final String uniquID;
  final List options;
  final List optionsprice;
  final String about;
  final DateTime date;
  final String type;
  final bool inside;
  const MenuItemDetail({
    super.key,
    required this.img,
    required this.name,
    required this.price,
    required this.options,
    required this.optionsprice,
    required this.dis,
    required this.rating,
    required this.about,
    required this.date,
    required this.type,
    required this.inside,
    required this.uniquID,
  });

  @override
  _MenuItemDetailState createState() => _MenuItemDetailState();
}

class _MenuItemDetailState extends State<MenuItemDetail> {
  List<bool> _selectedOptions = [];
  int _quantity = 1;
  Future<void> addToCheckOut(BuildContext context) async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User is not logged in
        // Handle this case according to your app's logic
        return;
      }

      // Check if the user's reservations collection is empty
      QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
          .collection('reservation')
          .where('userID', isEqualTo: user.uid)
          .get();

      if (reservationSnapshot.docs.isEmpty || widget.inside == false) {
        // Show an alert dialog if no reservations are found
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('لا يوجد مناسبات '),
              content: const Text('يجب ان تقوم بحجز الخدمة من داخل المناسبة '),
              actions: <Widget>[
                TextButton(
                  child: const Text('حسنا '),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigate back to the bottom bar screen
                    // Replace 'BottomBarScreen()' with the actual widget or navigation logic
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BottomBarScreen(
                          id: user.uid,
                          public: false,
                          uniquId: widget.uniquID,
                          date: widget.date,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
        return; // Exit the method
      } else if (reservationSnapshot.docs.isNotEmpty && widget.inside == true) {
        // Collect selected options and their prices
        List<Map<String, dynamic>> selectedOptions = [];
        for (int i = 0; i < widget.options.length; i++) {
          if (_selectedOptions[i]) {
            selectedOptions.add({
              'option': widget.options[i],
              'price': widget.optionsprice[i],
            });
          }
        }

        // Add item to checkout collection
        for (int i = 0; i < _quantity; i++) {
          await FirebaseFirestore.instance
              .collection('SubServices')
              .doc(user.uid)
              .collection('checkout')
              .add({
            'img': widget.img,
            'name': widget.name,
            'options': selectedOptions,
            'discount': widget.dis,
            'price': widget.price,
            'quantity': _quantity,
            'timestamp': widget.date,
            "uniquID": widget.uniquID // Add a timestamp for ordering
          });
        }

        // Show a snackbar or toast to indicate success
        CustomSnackBar(
          context,
          'add to checkout'.tr(),
          Colors.green,
          .9 * mediaheight(context),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle errors
      print('Error adding to checkout: $e');
      CustomSnackBar(
        context,
        'Failed to add item to checkout',
        Colors.red,
        .9 * mediaheight(context),
      );
    }
  }

  Future<void> _requestLocationPermissionAndFetchLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle it gracefully.
        log('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle it gracefully.
      log('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // When we reach here, permissions are granted or are already granted,
    // we can fetch the location now.
    _fetchLocation();
  }

  void _fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // Handle position data as needed, e.g., save to Firestore.
      log('Location fetched: ${position.latitude}, ${position.longitude}');
      sharedpref.setDouble('lat', position.latitude);
      sharedpref.setDouble('long', position.longitude);
    } catch (e) {
      log('Error fetching location: $e');
      // Handle error fetching location.
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<bool>.filled(widget.options.length, false);
  }

  void _addToCart() {
    addToCheckOut(context);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/heart.png"),
                const Text(
                    "You must give location access to the app so you wanna give this app permission of location ? ")
              ],
            ),
            actions: [
              MaterialButton(
                minWidth: .9 * mediawidth(context),
                color: primary,
                onPressed: () async {
                  await _requestLocationPermissionAndFetchLocation();
                  Navigator.pop(context);
                },
                child: const Text("yes", style: TextStyle(fontFamily: 'JF')),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              flex: widget.type.contains("قاعة")
                  ? 5
                  : widget.type == 'offers'
                      ? 5
                      : 2,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.img,
                        width: double.infinity,
                        height: widget.type.contains('قاعة')
                            ? 500
                            : widget.type == 'offers'
                                ? 700
                                : 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 20,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              child: Text(
                                _quantity.toString(),
                                style: const TextStyle(fontFamily: 'JF',fontSize: 10),
                              ),
                            ),
                            const Icon(
                              Icons.shopify_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                      name: widget.name,
                                      number:
                                          _selectedOptions.length.toString(),
                                      date: widget.date,
                                      uniquID: widget.uniquID,
                                      img: widget.img,
                                    )));
                        sharedpref.setString('name', widget.name);
                        sharedpref.setString(
                          'number',
                          _selectedOptions.length.toString(),
                        );
                        sharedpref.setString(
                          'img',
                          widget.img,
                        );
                        sharedpref.setString(
                            'date', widget.date.toIso8601String());
                        sharedpref.setString('uniquID', widget.uniquID);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.name,
              style: const TextStyle(fontFamily: 'JF',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'SAR ${(double.parse(widget.price) * (1 - double.parse(widget.dis) / 100)).toStringAsFixed(2)}',
                  style: const TextStyle(fontFamily: 'JF',
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'SAR ${widget.price}',
                    style: TextStyle(fontFamily: 'JF',
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ReviewPage()));
                  },
                  child: const Text(
                    "شاهد كل المراجعات",
                    style: TextStyle(fontFamily: 'JF',decoration: TextDecoration.underline),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.rating} (1,205)',
                  style: const TextStyle(fontFamily: 'JF',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.about,
              style: const TextStyle(fontFamily: 'JF',
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                // Show more description
              },
              child: const Text(
                'See more',
                style: TextStyle(fontFamily: 'JF',color: primary),
              ),
            ),
            const SizedBox(height: 16),
            widget.type == 'offers'
                ? const Center(
                    child: Text(
                      'لا توجد اضافات الان ',
                      style: TextStyle(fontFamily: 'JF',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const Text(
                    ':Additional Options',
                    style: TextStyle(fontFamily: 'JF',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            Expanded(
              flex: widget.type == 'offers' ? 1 : 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: widget.options.length,
                  itemBuilder: (context, index) {
                    return OptionItem(
                      label: widget.options[index],
                      price: widget.optionsprice[index],
                      value: _selectedOptions[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedOptions[index] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              surfaceTintColor: Colors.white,
              elevation: 5,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      minWidth: 100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: primary,
                      onPressed: sharedpref.getDouble("lat") != null
                          ? _addToCart
                          : _showDialog,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "اضافه",
                            style: TextStyle(fontFamily: 'JF',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_quantity > 1) _quantity--;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(fontFamily: 'JF',fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String label;
  final String price;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const OptionItem({
    super.key,
    required this.label,
    required this.price,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: primary,
          value: value,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: const TextStyle(fontFamily: 'JF',fontSize: 16),
        ),
        const Spacer(),
        Text(
          '+ SAR $price',
          style: const TextStyle(fontFamily: 'JF',fontSize: 16),
        ),
      ],
    );
  }
}

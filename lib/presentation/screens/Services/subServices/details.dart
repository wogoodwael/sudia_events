import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/add_to_card.dart';

class MenuItemDetail extends StatefulWidget {
  final String img;
  final String name;
  final String price;
  final String rating;
  final String dis;
  final List options;
  final List optionsprice;
  final String about;

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
        // You can handle this case according to your app's logic
        return;
      }

      // Collect selected options and their prices
      List<Map<String, dynamic>> selectedOptions = [];
      for (int i = 0; i < widget.options.length; i++) {
        if (_selectedOptions[i]) {
          selectedOptions.add(
              {'option': widget.options[i], 'price': widget.optionsprice[i]});
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
          'timestamp':
              FieldValue.serverTimestamp(), // Add a timestamp for ordering
        });
      }

      // Show a snackbar or toast to indicate success
      CustomSnackBar(
          context, 'Item added to checkout three times', Colors.green);
    } catch (e) {
      // Handle errors
      print('Error adding to checkout: $e');
      CustomSnackBar(context, 'Failed to add item to checkout', Colors.red);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.img,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
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
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Icon(
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
                                builder: (_) => OrderSummaryPage(
                                      name: widget.name,
                                      number:
                                          _selectedOptions.length.toString(),
                                    )));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'SAR ${widget.dis}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'SAR ${widget.price}',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "شاهد كل المراجعات",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Spacer(),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                SizedBox(width: 4),
                Text(
                  '${widget.rating} (1,205)',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              widget.about,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                // Show more description
              },
              child: Text(
                'See more',
                style: TextStyle(color: primary),
              ),
            ),
            SizedBox(height: 16),
            Text(
              ':Additional Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
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
            SizedBox(height: 16),
            Card(
              surfaceTintColor: Colors.white,
              elevation: 5,
              child: Container(
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
                      onPressed: _addToCart,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "اضافه",
                            style: TextStyle(
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
                    Container(
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
                              child: Icon(Icons.remove),
                            ),
                          ),
                          Text(
                            '$_quantity',
                            style: TextStyle(fontSize: 16),
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
                              child: Icon(Icons.add),
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

  OptionItem({
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
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        Text(
          '+ SAR $price',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/private_sub_services.dart';
import 'package:sudia_events/data/model/sub_services_item.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/details.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

// ignore: must_be_immutable
class SubServicesScreen extends StatelessWidget {
  final String itemName;

  SubServicesScreen({required this.itemName});
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: SearchContainernew(
                  hintText: 'البحث', controller: controller, onTap: () {})),
          SizedBox(
            height: .05 * mediaheight(context),
          ),
          Expanded(
            flex: 9,
            child: StreamBuilder<List<MenuItem>>(
              stream: fetchMenuItems(itemName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print("item name  $itemName");
                  return Center(child: Text('No data available'));
                } else {
                  var menuItems = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      var item = menuItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MenuItemDetail(
                                        img: item.image,
                                        name: item.des,
                                        price: item.price,
                                        options: item.options,
                                        optionsprice: item.optionsprice,
                                        dis: item.dis,
                                        rating: item.rating,
                                        about: item.about,
                                      )));
                        },
                        child: SmallOfferItem(
                          item.image,
                          item.price,
                          item.des,
                          item.rating,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<List<PrivateSubServices>>(
              stream: fetchPrivateItems(itemName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print("item name  $itemName");
                  return Center(child: Text('No data available'));
                } else {
                  var menuItems = snapshot.data!;
                  return Container(
                    width: .95 * mediawidth(context),
                    height: 50,
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = menuItems[index];
                        return PrivateOfferItem(item.image, item.price,
                            item.des, item.rating, item.name);
                      },
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Stream<List<MenuItem>> fetchMenuItems(String itemName) {
    return FirebaseFirestore.instance
        .collection('SubServices')
        .where('name', isEqualTo: itemName)
        .snapshots()
        .map((snapshot) {
      snapshot.docs
          .forEach((doc) => print(doc.data())); // Add this line to log data

      return snapshot.docs.map((doc) => MenuItem.fromMap(doc.data())).toList();
    });
  }

  Stream<List<PrivateSubServices>> fetchPrivateItems(String itemName) {
    return FirebaseFirestore.instance
        .collection('privateSubServices')
        .where('name', isEqualTo: itemName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PrivateSubServices.fromMap(doc.data()))
          .toList();
    });
  }
}

class SmallOfferItem extends StatelessWidget {
  final String img;
  final String des;
  final String rating;
  final String price;
  SmallOfferItem(this.img, this.price, this.des, this.rating);
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
        'img': img,
        'des': des,
        'price': price,
        // You can add more fields if needed
      });

      // Show a snackbar or toast to indicate success
      CustomSnackBar(context, 'Item added to favorites', Colors.green);
    } catch (e) {
      // Handle errors
      print('Error adding to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: 150,
      margin: EdgeInsets.only(right: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(img,
                        fit: BoxFit.cover, height: 100, width: double.infinity),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        await addToFavorites(context);
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(des, style: GoogleFonts.cairo(fontSize: 16)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(rating, style: TextStyle(color: Colors.orange)),
                        Icon(Icons.star, color: Colors.orange, size: 16),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('SAR $price', style: TextStyle(color: Colors.red)),
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

class PrivateOfferItem extends StatelessWidget {
  final String img;
  final String des;
  final String name;
  final String rating;
  final String price;
  PrivateOfferItem(this.img, this.price, this.des, this.rating, this.name);
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
        'img': img,
        'des': des,
        'price': price,
        // You can add more fields if needed
      });

      // Show a snackbar or toast to indicate success
      CustomSnackBar(context, 'Item added to favorites', Colors.green);
    } catch (e) {
      // Handle errors
      print('Error adding to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 70,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: GoogleFonts.cairo(fontSize: 16)),
                          SizedBox(height: 4),
                          Text(des,
                              style: GoogleFonts.cairo(
                                  fontSize: 14, color: Colors.grey)),
                          Text('SAR $price',
                              style: TextStyle(color: Colors.red)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(rating,
                                  style: TextStyle(color: Colors.orange)),
                              Icon(Icons.star, color: Colors.orange, size: 16),
                            ],
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
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

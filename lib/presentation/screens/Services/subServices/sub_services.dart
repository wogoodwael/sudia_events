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

class SubServicesScreen extends StatefulWidget {
  final String itemName;

  SubServicesScreen({required this.itemName});

  @override
  _SubServicesScreenState createState() => _SubServicesScreenState();
}

class _SubServicesScreenState extends State<SubServicesScreen> {
  TextEditingController controller = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        searchQuery = controller.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<MenuItem> _filterMenuItems(List<MenuItem> items, String query) {
    if (query.isEmpty) {
      return items;
    } else {
      return items.where((item) {
        var name = item.des.toLowerCase();
        return name.contains(query);
      }).toList();
    }
  }

  List<PrivateSubServices> _filterPrivateItems(
      List<PrivateSubServices> items, String query) {
    if (query.isEmpty) {
      return items;
    } else {
      return items.where((item) {
        var name = item.name.toLowerCase();
        return name.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: SearchContainernew(
                      hintText: 'البحث',
                      controller: controller,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<List<MenuItem>>(
              stream: fetchMenuItems(widget.itemName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  var menuItems = _filterMenuItems(snapshot.data!, searchQuery);
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
                              ),
                            ),
                          );
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
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 6,
            child: StreamBuilder<List<PrivateSubServices>>(
              stream: fetchPrivateItems(widget.itemName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  var privateItems =
                      _filterPrivateItems(snapshot.data!, searchQuery);
                  return Container(
                    width: .95 * mediawidth(context),
                    height: 50,
                    child: ListView.builder(
                      itemCount: privateItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = privateItems[index];
                        return PrivateOfferItem(
                          item.image,
                          item.price,
                          item.des,
                          item.rating,
                          item.name,
                        );
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .add({
        'img': img,
        'des': des,
        'price': price,
      });

      CustomSnackBar(context, 'Item added to favorites', Colors.green);
    } catch (e) {
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .add({
        'img': img,
        'des': des,
        'price': price,
      });

      CustomSnackBar(context, 'Item added to favorites', Colors.green);
    } catch (e) {
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

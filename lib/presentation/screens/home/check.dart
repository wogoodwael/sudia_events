import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class CheckoutScreenOverView extends StatefulWidget {
  const CheckoutScreenOverView({super.key, required this.id});
  final String id;
  @override
  State<CheckoutScreenOverView> createState() => _CheckoutScreenOverViewState();
}

class _CheckoutScreenOverViewState extends State<CheckoutScreenOverView> {
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

  Future<void> _removeFromCheckOut(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('SubServices')
          .doc(widget.id)
          .collection('checkout')
          .doc(docId)
          .delete();
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  List<DocumentSnapshot> _filterFavorites(
      List<DocumentSnapshot> favorites, String query) {
    if (query.isEmpty) {
      return favorites;
    } else {
      return favorites.where((favorite) {
        var data = favorite.data() as Map<String, dynamic>;
        var name = data['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('المفضلة'),
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
                    Icons.shopify_sharp,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    // Handle cart button press
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
      ),
      body: Column(
        children: [
          SearchContainernew(
            hintText: 'البحث',
            controller: controller,
            onTap: () {},
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 9,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('SubServices')
                  .doc(widget.id)
                  .collection('checkout')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No favorites found'));
                }

                var favorites = snapshot.data!.docs;
                var filteredFavorites =
                    _filterFavorites(favorites, searchQuery);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: filteredFavorites.length,
                  itemBuilder: (context, index) {
                    var favorite = filteredFavorites[index];
                    var data = favorite.data() as Map<String, dynamic>;
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Image.network(data['img'],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: double.infinity),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await _removeFromCheckOut(favorite.id);
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['name'] ?? "",
                                      style: GoogleFonts.cairo(fontSize: 16)),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text('4.9',
                                          style:
                                              TextStyle(color: Colors.orange)),
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 16),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text('SAR ${data['price']}',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough)),
                                  Text(
                                      'SAR ${data['discount'] ?? data['price']}',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

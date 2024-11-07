import 'package:cloud_firestore/cloud_firestore.dart';
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
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: const Text('السلة'),
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
                  icon: const Icon(
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
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$favoriteCount',
                      style: const TextStyle(fontFamily: 'JF',
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
          const SizedBox(
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                var favorites = snapshot.data!.docs;
                var filteredFavorites =
                    _filterFavorites(favorites, searchQuery);

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: filteredFavorites.length,
                  itemBuilder: (context, index) {
                    var favorite = filteredFavorites[index];
                    var data = favorite.data() as Map<String, dynamic>;
                    return GestureDetector(

onTap: () {
  
},                      child: Container(
                        margin: const EdgeInsets.all(10),
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
                                      child: const CircleAvatar(
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['name'] ?? "",
                                          style: GoogleFonts.cairo(fontSize: 16)),
                                      const SizedBox(height: 4),
                                      const Row(
                                        children: [
                                          Text('4.9',
                                              style: TextStyle(fontFamily: 'JF',
                                                  color: Colors.orange)),
                                          Icon(Icons.star,
                                              color: Colors.orange, size: 16),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text('SAR ${data['price']}',
                                          style: const TextStyle(fontFamily: 'JF',
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                      Text(
                                          'SAR ${data['discount'] ?? data['price']}',
                                          style: const TextStyle(fontFamily: 'JF',color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

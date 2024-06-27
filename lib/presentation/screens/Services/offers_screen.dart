import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Services/services_body.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class OffersScreen extends StatefulWidget {
  final bool inside;
  final String uniquId;
  const OffersScreen({super.key, required this.inside, required this.uniquId});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
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

  List<Map<String, dynamic>> _filterOffers(
      List<Map<String, dynamic>> offers, String query) {
    if (query.isEmpty) {
      return offers;
    } else {
      return offers.where((offer) {
        final name = offer['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("العروض الاسبوعية "),
        centerTitle: true,
        actions: [Icon(Icons.arrow_forward)],
      ),
      body: Column(
        children: [
          SizedBox(
            height: .02 * mediaheight(context),
          ),
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
          Expanded(
            flex: 13,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('offers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No offers found'));
                }

                var offers = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  // Ensure data contains the required fields, otherwise use default values
                  return {
                    'img': data['img'] ?? '',
                    'name': data['name'] ?? 'Unknown',
                    'discount': data['discount'] ?? '0%',
                    'price': data['price'] ?? 'N/A',
                  };
                }).toList();

                // Filter offers based on the search query
                var filteredOffers = _filterOffers(offers, searchQuery);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredOffers.length,
                  itemBuilder: (context, index) {
                    var offer = filteredOffers[index];
                    return WeeklyOfferItem(
                      offer['img'],
                      offer['name'],
                      offer['discount'],
                      offer['price'],widget.inside,
                  widget.uniquId  );
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

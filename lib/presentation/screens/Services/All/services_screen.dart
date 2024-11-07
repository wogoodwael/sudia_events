import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/All/services_body.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';
import 'package:sudia_events/presentation/screens/home/location.dart';
import 'package:sudia_events/presentation/screens/home/slider_body.dart';

class AddServices extends StatefulWidget {
  const AddServices({
    super.key,
    required this.date,
    required this.inside,
    required this.id,
    required this.uniquId,
  });
  final DateTime date;
  final bool inside;
  final String id;
  final String uniquId;
  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  bool chooseday = false;
  bool addService = false;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addService = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LocationScreen(
                            lat: sharedpref.getDouble('lat')!,
                            long: sharedpref.getDouble('long')!,
                            fromHome: true,
                          )));
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              width: 100,
              height: 30,
              decoration: BoxDecoration(color: Colors.yellow[100]),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Text(
                        'location'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_rounded),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy/MM/dd', 'ar').format(DateTime.now()),style: const TextStyle(fontFamily: 'JF')
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              DateFormat('EEEE', 'ar').format(DateTime.now()),style: const TextStyle(fontFamily: 'JF')
            ),
          ],
        ),
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SubServices')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('checkout')
              .snapshots(),
          builder: (context, snapshot) {
            int favoriteCount = 0;
            if (snapshot.hasData) {
              favoriteCount = snapshot.data?.docs.length ?? 0;
            }
            return Stack(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutScreenOverView(
                                  id: widget.id,
                                )));
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: .9 * mediawidth(context),
            height: 45,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'البحث ',
                  hintStyle: TextStyle(fontFamily: 'JF',color: Colors.grey[400]),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                  ),
                  suffixIcon: Icon(
                    Icons.tune,
                    color: Colors.grey[400],
                  )),
            ),
          ),
          const Expanded(
            flex: 3,
            child: SliderBodeyHomePage(),
          ),
          Expanded(
              flex: 7,
              child: Container(
                child: ServicesBodey(
                  date: widget.date,
                  inside: widget.inside,
                  id: widget.id,
                  uniquId: widget.uniquId,
                ),
              ))
        ],
      ),
    );
  }
}

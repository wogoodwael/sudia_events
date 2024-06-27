import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/Services/services_body.dart';
import 'package:sudia_events/presentation/screens/favorite/fav.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';
import 'package:sudia_events/presentation/screens/home/slider_body.dart';

class AddServices extends StatefulWidget {
  AddServices({
    super.key,
    required this.date,
    required this.inside,
    required this.id, required this.uniquId,
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
          Text('موقعك'),
          SizedBox(width: 10),
          Icon(Icons.location_on_rounded),
          SizedBox(width: 10),
        ],
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SubServices')
              .doc(FirebaseAuth.instance.currentUser!.uid)
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SliderBodeyHomePage(),
          ),
          Expanded(
              flex: 7,
              child: Container(
                child: ServicesBodey(
                  date: widget.date,
                  inside: widget.inside,
                  id: widget.id, uniquId: widget.uniquId,
                ),
              ))
        ],
      ),
    );
  }
}

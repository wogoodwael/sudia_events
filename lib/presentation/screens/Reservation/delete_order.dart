import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/appBar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

class CancelOrderScreen extends StatefulWidget {
  final String uniquID;

  const CancelOrderScreen({super.key, required this.uniquID});
  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String _selectedReason = '';
  final TextEditingController _otherReasonController = TextEditingController();
  Future<void> _deleteReservation() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Query the collection to find the document with the specified field value
      QuerySnapshot querySnapshot = await firestore
          .collection('booked_services')
          .where('uniquID', isEqualTo: widget.uniquID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Loop through the results and delete each matching document
        for (DocumentSnapshot doc in querySnapshot.docs) {
          await firestore.collection('booked_services').doc(doc.id).delete();
        }
        print("Document(s) deleted successfully");
      } else {
        print("No document found with the specified field value");
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar('حذف الحجز', context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildRadioOption('تغيير موعد المناسبة'),
              _buildRadioOption('وجدت سعر أفضل في مكان آخر'),
              _buildRadioOption('موعد التسليم'),
              _buildRadioOption('لايوجد توصيل'),
              _buildRadioOption('تكرار الطلب أكثر من مرة'),
              _buildRadioOption('سبب آخر'),
              if (_selectedReason == 'سبب آخر')
                Container(
                  width: .9 * mediawidth(context),
                  height: .17 * mediaheight(context),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _otherReasonController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'سبب آخر',
                    ),
                  ),
                ),
              SizedBox(
                height: .1 * mediaheight(context),
              ),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: primary,
                  onPressed: () async {
                    await _deleteReservation();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("تم الغاء حجزك",
                                  style: TextStyle(fontFamily: 'JF')),
                              Image.asset("assets/images/heart.png"),
                              const Text(
                                "نأسف لرؤية حجزك لم يتم تنفيذه",
                                style: TextStyle(
                                    fontFamily: 'JF',
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                  "نأمل ان نخدمك بشكل افضل في المرة القادمة",
                                  style: TextStyle(fontFamily: 'JF')),
                            ],
                          ),
                          actions: [
                            MaterialButton(
                              color: primary,
                              minWidth: mediawidth(context),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BottomBarScreen(
                                              id: sharedpref
                                                  .getString('token')!,
                                            )));
                              },
                              child: const Text(
                                "التالي",
                                style: TextStyle(
                                    fontFamily: 'JF', color: Colors.white),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'التالي',
                    style: TextStyle(
                        fontFamily: 'JF', color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: .9 * mediawidth(context),
      height: 60,
      decoration: BoxDecoration(
     //   color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(.5))),
      child: RadioListTile<String>(
        title: Text(title),
        value: title,
        activeColor: (Colors.orange),
        hoverColor: Colors.grey.withOpacity(1),
        groupValue: _selectedReason,
        onChanged: (value) {
          setState(() {
            _selectedReason = value!;
          });
        },
      ),
    );
  }
}

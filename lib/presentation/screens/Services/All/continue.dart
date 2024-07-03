import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';

class ContinueInvitation extends StatefulWidget {
  final String id;
  final String husband, wife, visitors;
  final DateTime date;
  const ContinueInvitation(
      {super.key,
      required this.id,
      required this.husband,
      required this.wife,
      required this.visitors,
      required this.date});

  @override
  State<ContinueInvitation> createState() => _ContinueInvitationState();
}

class _ContinueInvitationState extends State<ContinueInvitation> {
  final GlobalKey _screenshotKey = GlobalKey();
  String _selectedCheckbox = '';
  List<String> texts = [
    'دعوة زواج',
    'دعوة ',
    'دعوة خاصة',
    'ومن اياته ',
    'وجعل بينكم مودة ورحمة  ',
    'بارك الله لهما وبارك عليهما ',
    'افراحنا تزداد بحضوركم ',
    'حياكم الله وبياكم  ',
    'ودامت دياركم عامرةبالافراح  ',
    'شكرا لتلبيتكم الدعوة زواج',
    'شكرا لتلبيتكم الدعوة زواج',
    'شكرا لتلبيتكم الدعوة زواج',
  ];
  List<String> images = [
    'assets/images/marry.png',
    'assets/images/invite.png',
    'assets/images/private.png',
    'assets/images/aya.png',
    'assets/images/aya2.png',
    'assets/images/bark.png',
    'assets/images/afrah.png',
    'assets/images/haya.png',
    'assets/images/deyar.png',
    'assets/images/thanks.png',
    'assets/images/thanks.png',
    'assets/images/thanks.png',
  ];
  List<int> value = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
  ];
  List<int?> _selected = List<int?>.filled(
      6, null); // List to store selected values for each container

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    Icons.shopify_rounded,
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
        title: Text('بطاقة الدعوة'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    4,
                    (index) => Container(
                          margin: EdgeInsets.all(10),
                          width: .9 * mediawidth(context),
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                3,
                                (index2) => RadioListTile(
                                    title: Row(
                                      children: [
                                        Text(texts[index * 3 + index2],
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey)),
                                        Image.asset(images[index * 3 + index2]),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    value: value[index * 3 + index2],
                                    groupValue: _selected[index],
                                    onChanged: (val) {
                                      setState(() {
                                        _selected[index] = val as int?;
                                      });
                                    })),
                          ),
                        )),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckbox('ممنوع اصطحاب الاطفال'),
                _buildCheckbox('دخول القاعة ببطاقة الدعوة  '),
                _buildCheckbox('ممنوع اصطحاب االكاميرا بقاعات النساء  '),
                _buildCheckbox('اضافة رقم الهاتف  '),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  child: Container(
                    width: .9 * mediawidth(context),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MaterialButton(
                          minWidth: 150,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: primary,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return RepaintBoundary(
                                    key: _screenshotKey,
                                    child: AlertDialog(
                                      content: Stack(
                                        children: [
                                          Container(
                                            width: mediawidth(context),
                                            height: .8 * mediaheight(context),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/1.png'),
                                                    fit: BoxFit.fitHeight)),
                                          ),
                                          Positioned(
                                            top: .2 * mediaheight(context),
                                            left: 20,
                                            right: 20,
                                            child: Column(
                                              children: _buildSelectedTexts(
                                                  widget.husband,
                                                  widget.wife,
                                                  widget.visitors,
                                                  _selectedCheckbox),
                                            ),
                                          ),
                                          Positioned(
                                              top: 30,
                                              right: 30,
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                    onPressed: _shareScreenshot,
                                                    icon: Icon(
                                                      Icons.share,
                                                      size: 15,
                                                    )),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Text(
                                "اضافة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.check_circle_outline,
                                size: 15,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        Text(
                          'SAR 15.00',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> shareWidgets({required GlobalKey globalKey}) async {
    try {
      if (globalKey.currentContext == null) {
        throw Exception("GlobalKey's currentContext is null");
      }

      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("RenderRepaintBoundary is null");
      }

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("ByteData is null");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/screenshot.png').create();
      await imagePath.writeAsBytes(pngBytes);

      return imagePath.path;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void _shareScreenshot() async {
    final imagePath = await shareWidgets(globalKey: _screenshotKey);
    if (imagePath != null) {
      Share.shareXFiles(
        [XFile(imagePath, mimeType: "image/png")],
        text: 'Screenshot from Sudia Events app',
        subject: 'Screenshot',
      );
    }
  }

  Widget _buildCheckbox(String title) {
    return Row(
      children: [
        Checkbox(
          value: _selectedCheckbox == title,
          onChanged: (bool? value) {
            setState(() {
              _selectedCheckbox = value! ? title : '';
            });
          },
        ),
        Text(title),
      ],
    );
  }

  List<Widget> _buildSelectedTexts(
      String husband, String wife, String visitors, String selected) {
    List<Widget> selectedTexts = [];
    for (int i = 0; i < _selected.length; i++) {
      if (_selected[i] != null) {
        selectedTexts.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              texts[value.indexOf(_selected[i]!)],
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        // Add the strings after the second text
        if (i == 1) {
          selectedTexts.addAll([
            SizedBox(
              height: 5,
            ),
            Text(
              husband,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "علي ابنة",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              wife,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset("assets/images/2.png"),
            SizedBox(
              height: 5,
            ),
            Text(
              "ويشرفنا حضوركم الكريم ومشاركتنا فرحتنا وتناول طعام العشاء",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "الموافق يوم ${DateFormat('yyyy/MM/dd').format(widget.date)}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ]);
        }
      }
    }

    // Add "المدعون :" after the last index
    selectedTexts.addAll([
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'الداعون',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        width: .8 * mediawidth(context),
        height: 30,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text(visitors)),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        selected,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
    return selectedTexts;
  }
}

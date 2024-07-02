import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';

class ContinueInvitation extends StatefulWidget {
  final String id;
  const ContinueInvitation({super.key, required this.id});

  @override
  State<ContinueInvitation> createState() => _ContinueInvitationState();
}

class _ContinueInvitationState extends State<ContinueInvitation> {
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
            onPressed: () {},
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
                                  return AlertDialog(
                                    content: Stack(
                                      children: [
                                        Container(
                                          width: mediawidth(context),
                                          height: .7 * mediaheight(context),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/1.png'),
                                                  fit: BoxFit.fitWidth)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 20,
                                          right: 20,
                                          child: Column(
                                            children: _buildSelectedTexts(),
                                          ),
                                        ),
                                      ],
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

  List<Widget> _buildSelectedTexts() {
    List<Widget> selectedTexts = [];
    for (int i = 0; i < _selected.length; i++) {
      if (_selected[i] != null) {
        selectedTexts.add(
          Text(
            texts[value.indexOf(_selected[i]!)],
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        );
      }
    }
    return selectedTexts;
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

// ignore: must_be_immutable
class DoneScreen extends StatefulWidget {
  DoneScreen({
    super.key,
    required this.id,
  });
  final String id;
  Api api = Api();
  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                child: Image.asset(
                  "assets/images/logo.png",
                  color: primary,
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: primary,
                      size: 200,
                    ),
                    Text(
                      "تم انشاء حسابكم ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("الموافقة علي الشروط والاحكام"),
                          Transform.scale(
                            scale: .6,
                            child: Checkbox(
                              activeColor: primary,
                              visualDensity: VisualDensity.compact,
                              value:
                                  value, // Set the initial value of the checkbox
                              onChanged: (bool? value) {
                                setState(() {
                                  this.value = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: primary,
                      height: 35,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minWidth: .8 * mediawidth(context),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BottomBarScreen(
                                      id: widget.id,
                                    )));
                        print("ooooooId${widget.id}");
                      },
                      child: Text(
                        "بدء الخدمة ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

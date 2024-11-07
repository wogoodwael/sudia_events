import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class OpinionBody extends StatefulWidget {
  const OpinionBody({super.key});

  @override
  State<OpinionBody> createState() => _OpinionBodyState();
}

class _OpinionBodyState extends State<OpinionBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              width: mediawidth(context),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: .01 * mediaheight(context)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "محمد احمد الشمري",
                          style: TextStyle(
                              fontFamily: 'JF',
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                        Text(
                          "محامي",
                          style: TextStyle(
                              fontFamily: 'JF',
                              fontSize: 10,
                              color: Colors.grey),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 120,
                            child: Text(
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'JF',
                                    fontSize: 7,
                                    color: Colors.white),
                                """قاعة غيم هي إحدى القا    ممتاز جدا  ممتاز جدا  ممتاز جدا  ممتاز جدا  ممتاز جدا  ممتاز جدا  ممتاز جدا  ممتاز جدا  ا  ممتاز جدا 
                                                                              """,
                               ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 25,
                    child: Center(
                      child: Image.asset(
                        "assets/images/just_logo.png",
                        color: primary,
                        width: 40,
                      ),
                    ),
                  ),
                ],
              )),
          const Divider(
            endIndent: 10,
            indent: 10,
          )
        ],
      ),
    );
  }
}

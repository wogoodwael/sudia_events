import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/header_services.dart';

class PillScreen extends StatelessWidget {
  const PillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> firstRow = [
      Text(' '),
      Text(' المبلغ'),
      Text(' تاريخ الحجز '),
      Text(' رقم الفاتورة  '),
    ];
    List<Widget> data = [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, pilldetails);
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 10,
        ),
      ),
      Text(' 4300'),
      Text('2/8/2024'),
      Text(' 00255555712 '),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(children: [
            Header(
              text: 'الفواتير',
              paddingButtom: 50,
              paddingTop: 70,
            ),
            Positioned(
                right: 10,
                top: 50,
                child: Transform.scale(
                  scale: 1.5,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ))
          ]),
          Expanded(
              flex: 4,
              child: Container(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      width: 400,
                      height: 70,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: firstRow,
                          ),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: data,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}

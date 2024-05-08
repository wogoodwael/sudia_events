
import 'package:flutter/material.dart';

import 'package:sudia_events/presentation/screens/Services/discount_slider.dart';
import 'package:sudia_events/presentation/screens/Services/hotel_container.dart';
import 'package:sudia_events/presentation/screens/Services/services_slider.dart';
import 'package:sudia_events/presentation/screens/Services/text_divider.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  List<bool> onTapped = [false, false, false, false, false];
  List<String> data = [
    " سيارات",
    "افراح",
    "استراحات",
    "سيارات",
    "قاعات افراح",
  ];
  List title = [
    'قاعات افراح ',
    'خدمات',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> indexData = [
      "قسم المجد للافراح",
      "قاعة غيم",
    ];
    List<String> servicesData = [
      "سيارات",
      "مطاعم الرياض",
    ];
    List widgets = [
      HotelContainer(
        indexData: indexData,
      ),
      HotelContainer(
        indexData: servicesData,
      ),
    ];
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ServiceSlider(),
        DiscountSlider(),
        Divider(
          endIndent: 10,
          indent: 10,
        ),
        SizedBox(
          height: 70,
        ),
        Column(
          children: List.generate(2, (index) {
            return Column(
              children: [
                TextDivider(title: title[index]),
                widgets[index],
                SizedBox(
                  height: 10,
                ),
                
              ],
              
            );
            
          }),
          
        ),
      

      ]),

    );
    
  }
}

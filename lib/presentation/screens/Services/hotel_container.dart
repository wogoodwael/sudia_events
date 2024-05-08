import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/helper/custom_checkBox.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Services/tapped_container.dart';
import 'package:sudia_events/presentation/screens/Services/untapped_container.dart';

class HotelContainer extends StatefulWidget {
  const HotelContainer({super.key, required this.indexData});
  final List<String> indexData;

  @override
  State<HotelContainer> createState() => _HotelContainerState();
}

class _HotelContainerState extends State<HotelContainer> {
  List<bool> tapped = [false, false,];
  List<String> indexPrice = ['8000', "300",];
  @override
  Widget build(BuildContext context) {
    return Column(
        // mainAxisSize: MainAxisSize.min,
        children: List.generate(indexPrice.length, (index) {
      return Column(
        children: [
          UnTappedContainer(
            tapped: tapped[index],
            indexData: widget.indexData[index],
            indexPrice: indexPrice[index],
            onTap: () {
              setState(() {
                tapped[index] = !tapped[index];
              });
            },
          ),
          tapped[index]
              ? TappedContainer()
              : SizedBox(
                  height: 20,
                ),
        ],
      );
    }));
  }
}

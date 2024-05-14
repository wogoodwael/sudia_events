import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/helper/custom_checkBox.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/booked_services.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/presentation/screens/Services/tapped_container.dart';
import 'package:sudia_events/presentation/screens/Services/untapped_container.dart';

class HotelContainer extends StatefulWidget {
  const HotelContainer({
    super.key,
  });

  @override
  State<HotelContainer> createState() => _HotelContainerState();
}

class _HotelContainerState extends State<HotelContainer> {
  List<bool> tapped = [
    false,
    false,
  ];
  // List<String> indexPrice = ['8000', "300",];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookedServicesModel>>(
      future: fetchBookedData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<BookedServicesModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: primary,
          )); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('لم تقم بحجز اي خدمة بعد'));
        }
        return Column(
            // mainAxisSize: MainAxisSize.min,
            children: List.generate(snapshot.data!.length, (index) {
          return Column(
            children: [
              UnTappedContainer(
                tapped: tapped[index],
                indexData: snapshot.data![index].name,
                indexPrice: snapshot.data![index].price,
                onTap: () {
                  setState(() {
                    tapped[index] = !tapped[index];
                  });
                },
                des: snapshot.data![index].des,
              ),
              tapped[index]
                  ? TappedContainer()
                  : SizedBox(
                      height: 20,
                    ),
            ],
          );
        }));
      },
    );
  }
}

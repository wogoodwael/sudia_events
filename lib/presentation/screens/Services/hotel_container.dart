import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudia_events/business_logic/cubit/booked_data/booked_data_cubit.dart';
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
  List<BookedServicesModel>? bookedServices;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BookedDataCubit>(context).getBookedDataCubitfun();
  }

  // List<String> indexPrice = ['8000', "300",];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookedDataCubit, BookedDataState>(
      builder: (BuildContext context, BookedDataState state) {
        bookedServices =
            BlocProvider.of<BookedDataCubit>(context).bookedServices;
        if (state is BookedDataLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BookedDataSuccess) {
          return Column(
              // mainAxisSize: MainAxisSize.min,
              children: List.generate(bookedServices!.length, (index) {
            return Column(
              children: [
                UnTappedContainer(
                  tapped: tapped[index],
                  indexData: bookedServices![index].name,
                  indexPrice: bookedServices![index].price,
                  onTap: () {
                    setState(() {
                      tapped[index] = !tapped[index];
                    });
                  },
                  des: bookedServices![index].des,
                ),
                tapped[index]
                    ? TappedContainer()
                    : SizedBox(
                        height: 20,
                      ),
              ],
            );
          }));
        } else {
          return Center(
            child: Text("لم تقم بحجز اي خدمات بعد "),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudia_events/business_logic/cubit/get_services/services_cubit.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/services_model.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/presentation/screens/Services/resturants/resturants.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/wedding_hotels.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<bool> onTapped = [false, false, false, false, false];
  late Future<List<ServicesModel>> data;
  late Future<List<SubServicesModel>> servicesDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ServicesCubit>(context).getServicesCubitfun();
    Future.delayed(const Duration(seconds: 5)); // data = fetchServicesData();
  }

  List<ServicesModel>? services;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (BuildContext context, ServicesState state) {
        services = BlocProvider.of<ServicesCubit>(context).servicesModel;
        if (state is ServicesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ServicesSuccess) {
          return SizedBox(
            width: mediawidth(context),
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services!.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          onTapped[index] = !onTapped[index];
                        });
                        // print(
                        //     "sub services list idddddddddddd ${snapshot.data![index].id}");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    services![index].type == 'castle'
                                        ? WeddingsHotels(
                                            id: services![index].id,
                                          )
                                        : Resturants(
                                            id: services![index].id,
                                          )));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: onTapped[index] ? primary : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Text(
                                services![index].name,
                                style: TextStyle(fontFamily: 'JF',
                                    color: onTapped[index]
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            Icon(
                              Icons.check,
                              size: 15,
                              color: onTapped[index]
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("لا يوجد خدمات", style: TextStyle(fontFamily: 'JF')),
          );
        }
      },
    );
  }
}

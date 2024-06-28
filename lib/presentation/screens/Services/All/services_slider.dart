import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudia_events/business_logic/cubit/get_services/services_cubit.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/services_model.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/resturants/resturants.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/wedding_hotels.dart';

class ServiceSlider extends StatefulWidget {
  const ServiceSlider({super.key});

  @override
  State<ServiceSlider> createState() => _ServiceSliderState();
}

class _ServiceSliderState extends State<ServiceSlider> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  List<bool> onTapped = [false, false, false, false, false];
  late Future<List<ServicesModel>> data;
  late Future<List<SubServicesModel>> servicesDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ServicesCubit>(context).getServicesCubitfun();
    Future.delayed(Duration(seconds: 5)); // data = fetchServicesData();
  }

  int _current = 0;

  final CarouselController _controller = CarouselController();
  List<ServicesModel>? services;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: const Text(
            "عرض الكل ",
            style: TextStyle(height: 0, color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 15,
              ),
              onPressed: () async {
              
              },
            ),
            const SizedBox(width: 5.0),
            BlocBuilder<ServicesCubit, ServicesState>(
              builder: (BuildContext context, ServicesState state) {
                services =
                    BlocProvider.of<ServicesCubit>(context).servicesModel;
                if (state is ServicesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServicesSuccess) {
                  return Container(
                    width: 250,
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
                                height: 25,
                                decoration: BoxDecoration(
                                    color: onTapped[index]
                                        ? primary
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: onTapped[index]
                                            ? Colors.transparent
                                            : primary)),
                                child: Center(
                                  child: Text(
                                    services![index].name,
                                    style: TextStyle(
                                        color: onTapped[index]
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text("لا يوجد خدمات"),
                  );
                }
              },
            ),
            const SizedBox(width: 5.0),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onPressed: () {},
            ),
          ],
        ),
        FutureBuilder<List<SubServicesModel>>(
          future: fetchDetailsServicesData("dj0RK7S6XcGnHQt1XVf8"),
          builder: (BuildContext context,
              AsyncSnapshot<List<SubServicesModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Container(
                width: mediawidth(context),
                height: .24 * mediaheight(context),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot
                      .data!.length, // Use docs.length instead of length
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final List imgList = snapshot.data![index].image;

                    return Container(
                      width: mediawidth(context),
                      height: .24 * mediaheight(context),
                      child: Column(
                        children: [
                          CarouselSlider(
                            items: imgList
                                .map((item) => Container(
                                      child: Container(
                                        margin: const EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.network(item,
                                                  fit: BoxFit.cover,
                                                  width: 1000.0),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            200, 0, 0, 0),
                                                        Color.fromARGB(
                                                            0, 0, 0, 0)
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "35%",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'قاعات الرياض',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "جدة - حي الشاطئ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            carouselController: _controller,
                            options: CarouselOptions(
                                viewportFraction: .9,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2.5,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 70.0,
                                  height: 5.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : primary)
                                          .withOpacity(_current == entry.key
                                              ? 0.9
                                              : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return CircularProgressIndicator(); // Show loading indicator while data is being fetched
            }
          },
        )
      ],
    );
  }
}

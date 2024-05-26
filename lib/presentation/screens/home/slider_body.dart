import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';

class SliderBodeyHomePage extends StatefulWidget {
  const SliderBodeyHomePage({super.key});

  @override
  State<SliderBodeyHomePage> createState() => _SliderBodeyHomePageState();
}

class _SliderBodeyHomePageState extends State<SliderBodeyHomePage> {
    int _current = 0;

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubServicesModel>>(
      future: fetchDetailsServicesData("dj0RK7S6XcGnHQt1XVf8"),
      builder: (BuildContext context,
          AsyncSnapshot<List<SubServicesModel>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            width: mediawidth(context),
            height: .24 * mediaheight(context),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount:
                  snapshot.data!.length, // Use docs.length instead of length
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
                                              fit: BoxFit.cover, width: 1000.0),
                                          Positioned(
                                            bottom: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        200, 0, 0, 0),
                                                    Color.fromARGB(0, 0, 0, 0)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                            FontWeight.bold),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'قاعات الرياض',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "جدة - حي الشاطئ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: Colors.white,
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
                            onTap: () => _controller.animateToPage(entry.key),
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
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
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
          return Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while data is being fetched
        }
      },
    );
  }
}

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
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
  List<String> data = [
    " سيارات",
    "مطاعم الرياض",
    "استراحات",
    "سيارات",
    "قاعات افراح",
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    List<String> weddingsImages = [
      "assets/images/w1.jpg",
      "assets/images/w2.jpg",
      "assets/images/w3.jpeg",
    ];
    List<String> resturant = [
      "assets/images/r1.jpg",
      "assets/images/r2.jpg",
      "assets/images/r3.jpg",
    ];
    final List<String> imgList = [
      "assets/images/s1.jpg",
      "assets/images/s2.jpg",
      "assets/images/s3.jpg",
      "assets/images/s4.jpg",
    ];
    List goToPages = [
      WeddingsHotels(
        imagePaths: imgList,
      ),
      Resturants(
        imagePaths: resturant, //*
      ),
      WeddingsHotels(
        imagePaths: imgList,
      ),
      WeddingsHotels(
        imagePaths: imgList,
      ),
      WeddingsHotels(
        imagePaths: weddingsImages,
      ),
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "35%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'منتجعات سياحيه',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "جدة - حي الشاطئ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Icon(
                                          Icons.location_on_outlined,
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
                    )),
              ),
            ))
        .toList();
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
              onPressed: () {},
            ),
            const SizedBox(width: 5.0),
            Container(
              width: 250,
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            onTapped[index] = !onTapped[index];
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => goToPages[index]));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: 100,
                          height: 25,
                          decoration: BoxDecoration(
                              color:
                                  onTapped[index] ? primary : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: onTapped[index]
                                      ? Colors.transparent
                                      : primary)),
                          child: Center(
                            child: Text(
                              data[index],
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
        CarouselSlider(
          items: imageSliders,
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
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : primary)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

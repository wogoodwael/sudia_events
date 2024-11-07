import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/data/model/service.dart';

class SliderBodeyHomePage extends StatefulWidget {
  const SliderBodeyHomePage({super.key});

  @override
  State<SliderBodeyHomePage> createState() => _SliderBodeyHomePageState();
}

class _SliderBodeyHomePageState extends State<SliderBodeyHomePage> {
  final int _current = 0;

  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('services').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var services = snapshot.data!.docs
              .map((doc) =>
                  Service.fromFirestore(doc.data() as Map<String, dynamic>))
              .toList();

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.24,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: services.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final String imageUrl = services[index].imageUrl;

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CarouselSlider(
                          items: [imageUrl].map((item) {
                            return Container(
                              margin: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "35%",
                                              style: TextStyle(fontFamily: 'JF',
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'قاعات الرياض',
                                                  style: TextStyle(fontFamily: 'JF',
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "جدة - حي الشاطئ",
                                                      style: TextStyle(fontFamily: 'JF',
                                                          color: Colors.white,
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
                            );
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

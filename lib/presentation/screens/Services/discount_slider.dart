import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class DiscountSlider extends StatefulWidget {
  const DiscountSlider({super.key});

  @override
  State<DiscountSlider> createState() => _DiscountSliderState();
}

class _DiscountSliderState extends State<DiscountSlider> {
  final PageController _pageController = PageController();
  final int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                "الخصومات",
                style: TextStyle(fontFamily: 'JF',fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5.0),
            Expanded(
              child: SizedBox(
                width: 260,
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              width: 110,
                              height: 100,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(1,
                                        5), // Offset in x and y axes from the box
                                  ),
                                ],
                                // border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                "assets/images/fresh.jpg",
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                bottom: -1,
                                left: 10,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Container(
                                    width: 110,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "خصم",
                                              style: TextStyle(fontFamily: 'JF',
                                                  fontSize: 7,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "20%",
                                              style: TextStyle(fontFamily: 'JF',
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "فيتامين",
                                          style: TextStyle(fontFamily: 'JF',
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onPressed: () {
                if (_currentPage > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

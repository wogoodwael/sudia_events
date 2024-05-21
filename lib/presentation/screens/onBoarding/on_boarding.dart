import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                buildPage(
                  image: "assets/images/flight.png",
                  title: 'سهلنا عليك',
                  subtitle: 'مع تاب وتدارا',
                ),
                buildPage(
                  image: "assets/images/calender.png",
                  title: 'معنا فقط',
                  subtitle: 'تشاهد المواعيد المحجوزة',
                ),
                buildPage(
                  image: "assets/images/third.png",
                  title: 'عروض خاصة',
                  subtitle: 'مناسبتك في باكدج واحد',
                ),
                buildPage(
                  image: "assets/images/location.png",
                  title: ' خيارات متعددة',
                  subtitle: 'اكتر من 100 خدمة لمناسبتك',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => buildDot(index, context)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                MaterialButton(
                  color: primary,
                  minWidth: .7 * mediawidth(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () {
                    if (_currentPage < 3) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigate to the next screen or perform any action
                    }
                  },
                  child: _currentPage == 3
                      ? Text(
                          "ابدأ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          'التالي',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                MaterialButton(
                  minWidth: .7 * mediawidth(context),
                  elevation: _currentPage == 3 ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: _currentPage == 3 ? Colors.white : Colors.transparent,
                  onPressed: () {
                    // Skip button action
                    Navigator.pushNamed(context, login);
                  },
                  child: _currentPage == 3
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "دخول / تسجيل ",
                              style: TextStyle(
                                  color: primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.exit_to_app,
                              size: 15,
                              color: primary,
                            )
                          ],
                        )
                      : Text(
                          'تخطي',
                          style: TextStyle(color: Colors.grey),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(
      {required String image,
      required String title,
      required String subtitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            image,
            width: 200,
            height: 200, // Fixed height to ensure all images have the same size
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: primary),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: primary),
        ),
      ],
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentPage == index ? Colors.orange : Colors.grey,
      ),
    );
  }
}

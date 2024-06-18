import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

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
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('onBoarding').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // Make sure the docs list is not empty
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }

            // Get the first document snapshot
            var firstDoc = snapshot.data!.docs.first;
            var secondDoc = snapshot.data!.docs[1];
            var thirdDoc = snapshot.data!.docs[2];
            var fourthDoc = snapshot.data!.docs[3];

            return Column(
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
                        image: firstDoc['image'],
                        title: firstDoc['title'],
                        subtitle: firstDoc['subtitle'],
                      ),
                      buildPage(
                        image: secondDoc['image'],
                        title: secondDoc['title'],
                        subtitle: secondDoc['subtitle'],
                      ),
                      buildPage(
                        image: thirdDoc['image'],
                        title: thirdDoc['title'],
                        subtitle: thirdDoc['subtitle'],
                      ),
                      buildPage(
                        image: fourthDoc['image'],
                        title: fourthDoc['title'],
                        subtitle: fourthDoc['subtitle'],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List.generate(4, (index) => buildDot(index, context)),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BottomBarScreen(id: '123')));
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
                        color: _currentPage == 3
                            ? Colors.white
                            : Colors.transparent,
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
            );
          }),
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
          child: Image.network(
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

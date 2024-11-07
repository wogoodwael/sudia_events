import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('onBoarding').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // Make sure the docs list is not empty
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            // Get the first document snapshot
            var firstDoc = snapshot.data!.docs.first;
            var secondDoc = snapshot.data!.docs[1];
            var thirdDoc = snapshot.data!.docs[2];
            var fourthDoc = snapshot.data!.docs[3];

            return Column(
              children: [
                SizedBox(
                  height: .1 * mediaheight(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      List.generate(4, (index) => buildDot(index, context)),
                ),
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
                        image: fourthDoc['image'],
                        title: fourthDoc['title'],
                        subtitle: fourthDoc['subtitle'],
                      ),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      _currentPage == 3
                          ? MaterialButton(
                              color: primary,
                              minWidth: .7 * mediawidth(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () {
                                if (_currentPage < 3) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BottomBarScreen(
                                                id: '123',
                                                public: false,
                                                uniquId: '111',
                                                date: DateTime.now(),
                                              )));
                                }
                              },
                              child: const Text(
                                "ابدأ",
                                style: TextStyle(fontFamily: 'JF',
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ))
                          : CircleAvatar(
                              backgroundColor: primary,
                              radius: 30,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_currentPage < 3) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BottomBarScreen(
                                                  id: '123',
                                                  public: false,
                                                  uniquId: '111',
                                                  date: DateTime.now(),
                                                )));
                                  }
                                },
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
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "دخول / تسجيل ",
                                    style: TextStyle(fontFamily: 'JF',
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
                            : const Text(
                                'تخطي',
                                style: TextStyle(fontFamily: 'JF',color: Colors.grey),
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
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontFamily: 'JF',
              fontSize: 24, fontWeight: FontWeight.bold, color: primary),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(fontFamily: 'JF',fontSize: 16, color: primary),
        ),
      ],
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentPage == index ? Colors.orange : Colors.grey,
      ),
    );
  }
}

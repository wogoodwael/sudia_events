import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/onBoarding/on_boarding.dart';

// Define your primary color

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progressValue = 0.0;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        progressValue += 0.3; // Increase by 0.333 for three steps
        currentStep =
            (progressValue * 3).floor(); // Update current step (0 or 1)
        if (progressValue >= 1.0) {
          timer.cancel();
          navigateToNextScreen();
        }
      });
    });
  }

  void navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: IndexedStack(
              index: currentStep,
              children: <Widget>[
                StepContent(
                  image: 'assets/images/logo.svg',
                  title: 'أكثر مما تريد',
                ),
                StepContent(
                  image: 'assets/images/logo.svg',
                  title: 'مناسبتك بمنظور اخر',
                ),
                Stack(children: [
                  Container(
                    width: mediawidth(context),
                    height: mediaheight(context),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/background.png",
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned.fill(
                    bottom: 0 * MediaQuery.of(context).size.height,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    top: .27 * mediaheight(context),
                    right: .2 * mediawidth(context),
                    left: .2 * mediawidth(context),
                    child: StepContent(
                      image: 'assets/images/logo.svg',
                      title: '',
                    ),
                  ),
                  Positioned(
                      bottom: 50,
                      right: .2 * mediawidth(context),
                      left: .2 * mediawidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'اهلا بك في ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'مناسبة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                      right: 15,
                      left: 15,
                      bottom: 10,
                      child: LinearProgressIndicator(
                        backgroundColor: primary,
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                        value: progressValue,
                      ))
                ])
              ],
            ),
          ),
          currentStep == 2
              ? SizedBox()
              : LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  value: progressValue,
                ),
          SizedBox(height: currentStep == 2 ? 0 : 30),
        ],
      ),
    );
  }
}

class StepContent extends StatelessWidget {
  final String image;
  final String title;

  StepContent({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          image,
          width: 150,
          height: 150,
        ),
        SizedBox(height: 150),
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Text('Welcome to the second screen!'),
      ),
    );
  }
}

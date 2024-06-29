import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
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
    Future.delayed(Duration(seconds: 12), () => navigateToNextScreen());
  }

  void navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => sharedpref.getString('token') != null
            ? BottomBarScreen(id: sharedpref.getString('token')!)
            : OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: Container(
          width: mediawidth(context),
          height: mediaheight(context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/splash.gif"),
                  fit: BoxFit.cover)),
        ));
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

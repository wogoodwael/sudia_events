import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Auth/done.dart';
import 'package:sudia_events/presentation/screens/Auth/login.dart';
import 'package:sudia_events/presentation/screens/Auth/register.dart';
import 'package:sudia_events/presentation/screens/Auth/verify.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
import 'package:sudia_events/presentation/screens/client/account/my_account.dart';
import 'package:sudia_events/presentation/screens/client/pills/pills.dart';
import 'package:sudia_events/presentation/screens/client/pills/pills_details.dart';
import 'package:sudia_events/presentation/screens/client/settings/my_services.dart';
import 'package:sudia_events/presentation/screens/client/settings/settings.dart';
import 'package:sudia_events/presentation/screens/splash.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case buttomBar:
        return MaterialPageRoute(builder: (_) => const ButtomBarScreen());
      case myAccount:
        return MaterialPageRoute(builder: (_) => const MyAccountScreen());
      case verify:
        return MaterialPageRoute(builder: (_) => VerifyScreen());
      case done:
        return MaterialPageRoute(builder: (_) => const DoneScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case myServices:
        return MaterialPageRoute(builder: (_) => const MyServices());
      case pills:
        return MaterialPageRoute(builder: (_) => const PillScreen());
      case pilldetails:
        return MaterialPageRoute(builder: (_) =>  PillDetails());
    }
    return null;
  }
}

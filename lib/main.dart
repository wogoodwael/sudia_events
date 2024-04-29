import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/app_routes.dart';
import 'package:sudia_events/presentation/screens/splash.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  AppRouter appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/': (context) => SplashScreen()},
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: '/',
    );
  }
}

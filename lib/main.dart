import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudia_events/core/utils/app_routes.dart';
import 'package:sudia_events/firebase_options.dart';
import 'package:sudia_events/presentation/screens/splash.dart';
  late SharedPreferences sharedpref;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sharedpref = await SharedPreferences.getInstance();
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

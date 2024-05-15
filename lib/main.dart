import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudia_events/business_logic/cubit/booked_data/booked_data_cubit.dart';
import 'package:sudia_events/business_logic/cubit/family/family_filter_cubit.dart';
import 'package:sudia_events/business_logic/cubit/get_services/services_cubit.dart';
import 'package:sudia_events/core/utils/app_routes.dart';
import 'package:sudia_events/data/services/api.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FamilyFilterCubit(Api()),
        ),
        BlocProvider(
          create: (context) => ServicesCubit(),
        ),
        BlocProvider(
          create: (context) => BookedDataCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {'/': (context) => SplashScreen()},
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

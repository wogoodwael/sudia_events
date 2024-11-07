import 'package:easy_localization/easy_localization.dart' as ea;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudia_events/business_logic/cubit/booked_data/booked_data_cubit.dart';
import 'package:sudia_events/business_logic/cubit/family/family_filter_cubit.dart';
import 'package:sudia_events/business_logic/cubit/get_services/services_cubit.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
import 'package:sudia_events/core/utils/app_routes.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/firebase_options.dart';
import 'package:sudia_events/presentation/screens/onBoarding/splash_screen.dart';

late SharedPreferences sharedpref;
final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    // ignore: avoid_print
    print("Some notification Received in background...");
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    ),
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ea.EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sharedpref = await SharedPreferences.getInstance();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  runApp(MyApp());
  runApp(
    ea.EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: MyApp(),
      ),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    // Access the current locale
    Locale currentLocale = context.locale;

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
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, Widget? child) {
          // Set text direction based on the current locale
          TextDirection textDirection = currentLocale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr;

          return MaterialApp(
            color: Colors.white,
            builder: (context, child) {
             
              return Directionality(
                textDirection: textDirection,
                child: child!,
              );
            },
            theme: ThemeData(primarySwatch: Colors.deepOrange),
            locale: currentLocale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return supportedLocales.first;

              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            routes: {'/': (context) => const SplashScreen()},
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: '/',
          );
        },
      ),
    );
  }
}

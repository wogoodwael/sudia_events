import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Auth/register.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool visable = false;
  bool remember = false;
  bool register = false;
  bool login = false;
  bool loading = false;

  TextEditingController phoneE = TextEditingController();
  @override
  void initState() {
    super.initState();
    login = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            "تسجيل الدخول",
            style: TextStyle(
                fontFamily: 'JF', fontWeight: FontWeight.w700, fontSize: 22),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 100, 10, 100),
                  items: [
                    PopupMenuItem(
                      onTap: () {
                        Provider.of<LanguageProvider>(context, listen: false)
                            .setLocale(const Locale('ar'));
                        easy.EasyLocalization.of(context)
                            ?.setLocale(const Locale('ar'));
                      },
                      value: 1,
                      child: const Text("عربي",
                          style: TextStyle(fontFamily: 'JF')),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        Provider.of<LanguageProvider>(context, listen: false)
                            .setLocale(const Locale('en'));
                        easy.EasyLocalization.of(context)
                            ?.setLocale(const Locale('en'));
                      },
                      value: 1,
                      child: const Text("English",
                          style: TextStyle(fontFamily: 'JF')),
                    ),
                  ],
                );
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 20),
                child: Image.asset(
                  "assets/images/lang.png",
                  //   width: 200,
                  // //  size: 120,

                  color: primary,
                ),
              ),
            )
          ]),
      backgroundColor: Colors.white,
      body: Consumer<LanguageProvider>(
        builder: (BuildContext context, LanguageProvider value, Widget? child) {
          return Column(
            children: [
              Expanded(
                flex: 6,
                child: SizedBox(
                  width: .9 * mediawidth(context),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntlPhoneField(
                              keyboardType:TextInputType.number,
                              controller: phoneE,
                              onSubmitted: (p0) {
                                setState(() {
                                  phoneE;
                                });
                              },
                              dropdownIcon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 12),
                                border: InputBorder.none,
                                counterText: "",
                                errorStyle: TextStyle(
                                    fontFamily: 'JF',
                                    fontSize: 0,
                                    height: 0), // This hides the error text
                              ),
                              initialCountryCode: 'AE',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                                sharedpref.setString(
                                    'phone', phone.completeNumber);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: .05 * mediaheight(context),
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: .8,
                              child: Checkbox(
                                activeColor: primary,
                                visualDensity: VisualDensity.compact,
                                value:
                                    remember, // Set the initial value of the checkbox
                                onChanged: (bool? value) {
                                  setState(() {
                                    remember = value!;
                                  });
                                },
                              ),
                            ),
                            Text(
                              'remember'.tr(),
                              style: const TextStyle(
                                  fontFamily: 'JF',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "شروط الخدمة",
                                style: GoogleFonts.roboto(
                                    color: primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                " و ",
                                style: GoogleFonts.roboto(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "سياسة الخصوصية",
                                style: GoogleFonts.roboto(
                                    color: primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "اقبل",
                                style: GoogleFonts.roboto(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Center(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: phoneE.text.isNotEmpty ? primary : primary,
                              minWidth: 300,
                              onPressed: phoneE.text.isNotEmpty
                                  ? () async {
                                      Api().login(
                                          context,
                                          sharedpref.getString("phone")!,
                                          loading, (bool value) {
                                        setState(() {
                                          loading = value;
                                        });
                                      });
                                    }
                                  : () {
                                      Api().login(
                                          context,
                                          sharedpref.getString("phone")!,
                                          loading, (bool value) {
                                        setState(() {
                                          loading = value;
                                        });
                                      });
                                    },
                              child: loading
                                  ? const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                  : Text(
                                      'login'.tr(),
                                      style: const TextStyle(
                                          fontFamily: 'JF',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                register ? "have".tr() : "donthave".tr(),
                                style: const TextStyle(
                                    fontFamily: 'JF',
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen()));
                                },
                                child: Text(
                                  register ? "login".tr() : "signup".tr(),
                                  style: const TextStyle(
                                      fontFamily: 'JF',
                                      decoration: TextDecoration.underline,
                                      decorationColor: primary,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}

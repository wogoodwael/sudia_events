import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  LoginScreen({super.key});

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
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: GestureDetector(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(100, 100, 10, 100),
                      items: [
                        PopupMenuItem(
                          onTap: () {
                            Provider.of<LanguageProvider>(context,
                                    listen: false)
                                .setLocale(Locale('ar'));
                            easy.EasyLocalization.of(context)
                                ?.setLocale(Locale('ar'));
                          },
                          value: 1,
                          child: Text("عربي"),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Provider.of<LanguageProvider>(context,
                                    listen: false)
                                .setLocale(Locale('en'));
                            easy.EasyLocalization.of(context)
                                ?.setLocale(Locale('en'));
                          },
                          value: 1,
                          child: Text("English"),
                        ),
                      ],
                    );
                  },
                  child: ImageIcon(
                    AssetImage(
                      "assets/images/lang.png",
                    ),
                    size: 90,
                    color: primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                child: Text(
                  "تسجيل الدخول",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      body: Consumer<LanguageProvider>(
        builder: (BuildContext context, LanguageProvider value, Widget? child) {
          return Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: .9 * mediawidth(context),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Container(
                            width: .8 * mediawidth(context),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: .01 * mediaheight(context)),
                              child: IntlPhoneField(
                                controller: phoneE,
                                onSubmitted: (p0) {
                                  setState(() {
                                    phoneE;
                                  });
                                },
                                dropdownIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 5, left: 10),
                                  border: InputBorder.none,
                                  counterText: "",
                                  errorStyle: TextStyle(
                                      fontSize: 0,
                                      height: 0), // This hides the error text
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                  sharedpref.setString(
                                      'phone', phone.completeNumber);
                                },
                              ),
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
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
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
                              Text(
                                "اقبل",
                                style: GoogleFonts.roboto(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "شروط الخدمة",
                                style: GoogleFonts.roboto(
                                    color: primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                " و ",
                                style: GoogleFonts.roboto(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "سياسة الخصوصية",
                                style: GoogleFonts.roboto(
                                    color: primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Center(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color:
                                  phoneE.text.isNotEmpty ? primary : secondary,
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
                                  : () {},
                              child: loading
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                  : Text(
                                      'login'.tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                register ? "have".tr() : "donthave".tr(),
                                style: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => RegisterScreen()));
                                },
                                child: Text(
                                  register ? "login".tr() : "signup".tr(),
                                  style: GoogleFonts.roboto(
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

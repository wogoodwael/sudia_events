import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
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

  TextEditingController phone = TextEditingController();
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
              SizedBox(
                width: 10,
              ),
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
              )
            ],
          )),
      backgroundColor: Colors.white,
      body: Consumer<LanguageProvider>(
        builder: (BuildContext context, LanguageProvider value, Widget? child) {
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: mediawidth(context),
                  height: 50,
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: primary,
                  ),
                ),
              ),
              register
                  ? RegisterScreen()
                  : Expanded(
                      flex: 4,
                      child: Container(
                        width: .9 * mediawidth(context),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height:
                                    52, // Increase height to account for border

                                child: Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'phone'.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: primary))),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Container(
                                  width: .8 * mediawidth(context),
                                  height: 45,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 10, left: 5),
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      controller: phone,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            '513245458                                    966',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[300]),
                                        hintTextDirection: value.textDirection,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: .6,
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: remember ? primary : secondary,
                                  minWidth: 300,
                                  onPressed: () async {
                                    Api().login(context, phone, loading,
                                        (bool value) {
                                      setState(() {
                                        loading = value;
                                      });
                                    });
                                  },
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
                            ],
                          ),
                        ),
                      ),
                    ),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          register ? "have".tr() : "donthave".tr(),
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              register = !register;
                            });
                          },
                          child: Text(
                            register ? "login".tr() : "signup".tr(),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: primary,
                                color: primary,
                                fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}

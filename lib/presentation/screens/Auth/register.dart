import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool visable = false;
  bool remember = false;
  Api api = Api();
  TextEditingController phoneE = TextEditingController();
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        title: Text(
          "التسجيل",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Consumer<LanguageProvider>(
            builder:
                (BuildContext context, LanguageProvider value, Widget? child) {
              return Expanded(
                flex: 5,
                child: Container(
                  width: .9 * mediawidth(context),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: .8 * mediawidth(context),
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, right: 10),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                controller: name,
                                // textDirection: value.textDirection,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'name'.tr(),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  // hintTextDirection: value.textDirection,
                                  prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 4),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: .8 * mediawidth(context),
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, right: 10),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                controller: email,
                                // textDirection: value.textDirection,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'email'.tr(),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  // hintTextDirection: value.textDirection,
                                  prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 4),
                                      child: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
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
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            flex: 1,
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
                      color: phoneE.text.isNotEmpty ? primary : secondary,
                      minWidth: 300,
                      onPressed: () async {
                        api.verifyPhoneNumber(
                            context, phoneE, email.text, loading, (bool value) {
                          setState(() {
                            loading = value;
                          });
                        }, name.text);
                      },
                      child: loading
                          ? Container(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text(
                              "login".tr(),
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
        ],
      ),
    );
  }
}
